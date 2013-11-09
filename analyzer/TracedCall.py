#!/usr/bin/env python

import plistlib, json, datetime
from Signatures import Signature
from APIGroups import APIGroups
from TypeRefToStr import TypeRefToStr


class TracedCall:
    """ Object representation of a introspy database row (a traced call) """


    def __init__(self, callId, clazz, method, argsAndReturnValue):
        self.callId = callId
        self.clazz = unicode(clazz)
        self.method = unicode(method)
        self.argsAndReturnValue = TypeRefToStr(plistlib.readPlistFromString(argsAndReturnValue.encode('utf-8'))).args
        # Get the call's group and subgroup
        self.subgroup = APIGroups.find_subgroup(clazz, method)
        self.group =  APIGroups.find_group(self.subgroup)


    def extract_value_for_argument(self, arg_path):
        """Returns the value of the specific argument."""
        nextLevel = self.argsAndReturnValue[arg_path[0]]
        for attr in arg_path[1:]:
            try:
                if isinstance(nextLevel, str):
                    raise KeyError
                nextLevel = nextLevel[attr]
            except KeyError:
                raise
        return nextLevel


    def to_JSON_dict(self):
        """Returns a dictionnary of the traced call that can be serialized to JSON."""
        return self.__dict__


    def _walk_dict(self, d, level=0):
        arg_str = ""
        items = d.items()
        items.sort()
        for v in items:
            if isinstance(v[1], dict):
                arg_str += "\t\t%s%s =>\n" % ("  " * level, v[0])
                nextlevel = level + 1
                arg_str += self._walk_dict(v[1], nextlevel)
            else:
                arg_str += "\t\t%s%s => %s\n" % ("  " * level, v[0], v[1])
        return arg_str


    def __str__(self):
        call = "%s:%s\n" % (self.clazz, self.method)
        call += "%s" % self._walk_dict(self.argsAndReturnValue)
        return call
