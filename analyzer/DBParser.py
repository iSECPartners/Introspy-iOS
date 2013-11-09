#!/usr/bin/env python
import sqlite3
import json
import plistlib
import datetime

from TracedCall import TracedCall
from IOS_ENUM_LIST import IOS_ENUM_LIST
from Signature import Signature


class DBParser(object):
    """Parses an Introspy DB to extract all function calls stored in it."""

    def __init__(self, dbPath):
        """
        Opens the SQLite database at dbPath and extracts all traced calls from it.
        """

        self.dbPath = dbPath
        self.tracedCalls = []
        SqlConn = None
        try:
            SqlConn = sqlite3.connect(dbPath).cursor()
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


    def get_traced_calls_as_text(self, group=None, subgroup=None):
        """Returns a list of traced calls belonging to the supplied API group and/or subgroup as printable text."""
        for call in self.tracedCalls:
            if group and call.group.lower() != group.lower():
                continue
            if subgroup and call.subgroup.lower() != subgroup.lower():
                continue

            print "  %s" % call


    def get_traced_calls_as_JSON(self):
        """Returns the list of all traced calls as JSON."""
        tracedCalls_dict = {}
        tracedCalls_dict['calls'] =  self.tracedCalls
        return json.dumps(tracedCalls_dict, default=self._json_serialize)


    def get_all_URLs(self):
        """Returns the list of all URLs accessed within the traced calls."""
        urlsList = []
        for call in self.tracedCalls:
            if 'request' in call.argsAndReturnValue['arguments']:
                urlsList.append(call.argsAndReturnValue['arguments']['request']['URL']['absoluteString'])
        # Sort and remove duplicates
        urlsList = dict(map(None,urlsList,[])).keys()
        urlsList.sort()
        return urlsList


    def get_all_files(self):
        """Returns the list of all files accessed within the traced calls."""
        filesList = []
        for call in self.tracedCalls:
            if 'url' in call.argsAndReturnValue['arguments']:
                filesList.append(call.argsAndReturnValue['arguments']['url']['absoluteString'])
            if 'path' in call.argsAndReturnValue['arguments']:
                filesList.append(call.argsAndReturnValue['arguments']['path'])
        # Sort and remove duplicates
        filesList = dict(map(None,filesList,[])).keys()
        filesList.sort()
        return filesList


# TODO: This code crashes with my DB
#    def get_all_keys(self):
#        keysList = []
#        for call in self.traced_calls:
#            if call.method == "SecItemAdd":
#                keysList.append("{0} = {1}".format(call.argsAndReturnValue['arguments']['attributes']['acct'],
#                    call.argsAndReturnValue['arguments']['attributes']['v_Data']))
#            elif call.method == "SecItemUpdate":
#                keysList.append("{0} = {1}".format(call.argsAndReturnValue['arguments']['query']['acct'],
#                    call.argsAndReturnValue['arguments']['attributesToUpdate']['v_Data']))
#        return keysList


    def _sanitize_args_dict(self, argsDict):
        """Goes through a dict of arguments or return values and replaces specific values to make them easier to read."""
        for (arg, value) in argsDict.items():
            if isinstance(value, dict):
                self._sanitize_args_dict(value)
            elif isinstance(value, list):
                sanList = []
                for elem in value:
                    sanList.append(self._sanitize_args_single_value(elem))
                argsDict[arg] = sanList
            else: # Looking at a single value
                argsDict[arg] = self._sanitize_args_single_value(value, arg)

        return argsDict


    @staticmethod
    def _sanitize_args_single_value(value, arg=None):
        """Makes a single value easier to read."""
        if isinstance(value, plistlib.Data):
            try: # Does it seem to be ASCII ?
                return value.data.encode('ascii')
            except UnicodeDecodeError: # No => base64 encode it
                return value.asBase64(maxlinelength=1000000).strip()
        elif isinstance(value, datetime.datetime):
            # Keychain items can contain a date. We just store a string representation of it
            return str(value)
        else: 
            # Try to replace this value with a more meaningful string
            if arg in IOS_ENUM_LIST:
                try:
                    if 'mask' in IOS_ENUM_LIST[arg]:
                        return IOS_ENUM_LIST[arg][value] & IOS_ENUM_LIST[arg]['mask']
                    else:
                        return IOS_ENUM_LIST[arg][value]
                except KeyError:
                    return value
            else:
                return value


    @staticmethod
    def _json_serialize(obj):
        """
        Used to specify to json.dumps() how to JSON serialize Signature and TracedCall objects.
        """
        if isinstance(obj, TracedCall) or isinstance(obj, Signature):
            return obj.to_JSON_dict()

