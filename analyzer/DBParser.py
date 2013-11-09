#!/usr/bin/env python
import os
import sqlite3
import json
from TracedCall import TracedCall


#TODO: Refactor this
from Signature import Signature
import plistlib
class IntrospyJSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, TracedCall) or isinstance(obj, Signature):
            return obj.to_JSON_dict()        
        elif isinstance(obj, plistlib.Data):
            # Serialize a plist <data> 
            try: # Does it seem to be ASCII ?
                data = obj.data.encode('ascii')
            except UnicodeDecodeError: # No => base64 encode it
                data = obj.asBase64(maxlinelength=1000000).strip()
            return data
        else:
            return super(IntrospyJSONEncoder, self).default(obj)


class DBParser:
    """Parses an Introspy DB to extract function calls stored in it."""

    def __init__(self, dbPath):
        self.tracedCalls = []
        SqlConn = None

        try:
            SqlConn = sqlite3.connect(dbPath)
            SqlConn = SqlConn.cursor()
            SqlConn.execute("SELECT * FROM tracedCalls")
            rowid = 1
            for row in SqlConn:
                self.tracedCalls.append(TracedCall(rowid, row[0], row[1], row[2]))
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

