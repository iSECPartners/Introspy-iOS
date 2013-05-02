#!/usr/bin/env python

import plistlib, json, datetime
from Signatures import Signature
from APIGroups import APIGroups

class TracedCall:
    """ Object representation of a introspy database row (a traced call) """


    def __init__(self, callId, clazz, method, argsAndReturnValue):
        self.callId = callId
        self.clazz = unicode(clazz)
        self.method = unicode(method)
        self.argsAndReturnValue = plistlib.readPlistFromString(argsAndReturnValue.encode('utf-8'))
        # Get the call's group and subgroup
        self.subgroup = APIGroups.find_subgroup(clazz, method)
        self.group =  APIGroups.find_group(self.subgroup)


    def walk_dict(self, d, level=0):
        arg_str = ""
        items = d.items()
        items.sort()
        for v in items:
            if isinstance(v[1], dict):
                arg_str += "\t\t%s%s =>\n" % ("  " * level, v[0])
                nextlevel = level + 1
                arg_str += self.walk_dict(v[1], nextlevel)
            else:
                arg_str += "\t\t%s%s => %s\n" % ("  " * level, v[0], v[1])
        return arg_str


    def extract_value_for_argument(self, arg_path):
        # Walk the dictionnary
        nextLevel = self.argsAndReturnValue[arg_path[0]]
        for attr in arg_path[1:]:
            try:
                if isinstance(nextLevel, str):
                  raise KeyError
                nextLevel = nextLevel[attr]
            except KeyError:
                raise
        return nextLevel


    def __str__(self):
        call = "%s:%s\n" % (self.clazz, self.method)
        call += "%s" % self.walk_dict(self.argsAndReturnValue)
        return call


class TracedCallJSONEncoder(json.JSONEncoder):
    # TODO: Move to a different file
    def default(self, obj):
        if isinstance(obj, TracedCall):
            # Serialize a traced call as a dictionary
            return obj.__dict__
        elif isinstance(obj, plistlib.Data):
            # Serialize a plist <data> 
            try: # Does it seem to be ASCII ?
                data = obj.data.encode('ascii')
            except UnicodeDecodeError: # No => base64 encode it
                data = obj.asBase64(maxlinelength=1000000).strip()
            return data
        elif isinstance(obj, Signature):
            sig_dict = obj.__dict__
            # Do not try to serialize the filter attribute
            del sig_dict['filter']
            return sig_dict
        elif isinstance(obj, datetime.datetime):
            # Keychain items can contain a date. We just store a string representation of it
            return str(obj)
        else:
            return super(TracedCallJSONEncoder, self).default(obj)
