#!/usr/bin/env python
import sqlite3
import json
import plistlib
import datetime

from TracedCall import TracedCall
from IOS_ENUM_LIST import IOS_ENUM_LIST

#TODO: Refactor this
from Signature import Signature
class IntrospyJSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, TracedCall) or isinstance(obj, Signature):
            return obj.to_JSON_dict()
        elif isinstance(obj, plistlib.Data):
            # Store data nodes as ASCII or base64-encoded data
            try: # Does it seem to be ASCII ?
                return obj.data.encode('ascii')
            except UnicodeDecodeError: # No => base64 encode it
                return obj.asBase64(maxlinelength=1000000).strip()
        else:
            return super(IntrospyJSONEncoder, self).default(obj)


class DBParser:
    """Parses an Introspy DB to extract all function calls stored in it."""

    def __init__(self, dbPath):
        """
        Opens the SQLite database at dbPath and extracts all traced calls from it.
        """

        self.tracedCalls = []
        SqlConn = None
        try:
            SqlConn = sqlite3.connect(dbPath)
            SqlConn = SqlConn.cursor()
            SqlConn.execute("SELECT * FROM tracedCalls")
            rowid = 1
            for row in SqlConn:
                self.tracedCalls.append(TracedCall(
                    callId = rowid, 
                    clazz = unicode(row[0]), 
                    method = unicode(row[1]), 
                    argsAndReturnValue = self._sanitize_args_dict(plistlib.readPlistFromString(row[2].encode('utf-8')))))
                rowid += 1
        except sqlite3.Error as e:
            print "Fatal error: %s" % e
            raise
        finally:
            if SqlConn:
                SqlConn.close()


    def get_traced_calls(self, group=None, subgroup=None):
        """
        Returns a list of function calls stored in the DB belonging to the supplied API group and/or subgroup.
        """

        filteredCalls = []
        for call in self.tracedCalls:
            if group and call.group.lower() != group.lower():
                continue
            if subgroup and call.subgroup.lower() != subgroup.lower():
                continue

            filteredCalls.append(call)
        
        return filteredCalls


    def get_traced_calls_as_text(self, group=None, subgroup=None):
        """Returns the list of traced calls as printable text."""
        for tracedCall in self.get_traced_calls(group, subgroup):
            print "  %s" % tracedCall


    def get_traced_calls_as_JSON(self):
        """Returns the list of traced calls as JSON."""
        tracedCalls_dict = {}
        tracedCalls_dict['calls'] =  self.tracedCalls
        return json.dumps(tracedCalls_dict, cls=IntrospyJSONEncoder)


    def _sanitize_args_dict(self, argsDict):
        """Goes through a dict of arguments or return values and replaces specific values to make them easier to read."""

        for (arg, value) in argsDict.items():
            if isinstance(value, dict):
                self._sanitize_args_dict(value)
            elif isinstance(value, list):
                continue
            elif isinstance(value, plistlib.Data):
                # Store data nodes as ASCII or base64-encoded data
                try: # Does it seem to be ASCII ?
                    argsDict[arg] = value.data.encode('ascii')
                except UnicodeDecodeError: # No => base64 encode it
                    argsDict[arg] = value.asBase64(maxlinelength=1000000).strip()
            elif isinstance(value, datetime.datetime):
                # Keychain items can contain a date. We just store a string representation of it
                argsDict[arg] = str(value)
            else: # Looking at a single value
                # Try to eplace this value with a more meaningful string
                if arg in IOS_ENUM_LIST:
                    try:
                        if 'mask' in IOS_ENUM_LIST[arg]:
                            argsDict[arg] = IOS_ENUM_LIST[arg][value] & IOS_ENUM_LIST[arg]['mask']
                        else:
                            argsDict[arg] = IOS_ENUM_LIST[arg][value]
                    except KeyError:
                        continue

        return argsDict

