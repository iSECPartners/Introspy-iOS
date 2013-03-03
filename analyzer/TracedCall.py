#!/usr/bin/env python

import plistlib
from pprint import pformat

class TracedCall:
	""" Object representation of a introspy database row (a traced call) """

	def __init__(self, clazz, method, args, returnValue):
		self.clazz = unicode(clazz)
		self.method = unicode(method)
		self.args = plistlib.readPlistFromString(args.encode('utf-8'))
		self.return_value = plistlib.readPlistFromString(returnValue.encode('utf-8'))

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

	def __str__(self):
		call = "%s:%s\n" % (self.clazz, self.method)
		call += "\tArguments:\n%s" % self.walk_dict(self.args)
		call += "\tReturn Value:\n%s" % self.walk_dict(self.return_value)
		return call
