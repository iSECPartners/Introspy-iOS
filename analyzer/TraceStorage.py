#!/usr/bin/env python
import os
import sqlite3
import json
from TracedCall import TracedCall, TracedCallJSONEncoder

class TraceStorage:
	""" Object representation of an introspy database """

	def __init__(self, db):
		try:
			self.conn = sqlite3.connect(db)
			self.db = self.conn.cursor()
			self.db.execute("SELECT * FROM tracedCalls")
			self.calls = []
			for row in self.db:
				self.calls.append(TracedCall(row[0], row[1], row[2]))
		except sqlite3.Error as e:
			print "Fatal error: %s" % e
			raise
		finally:
			if self.conn:
				self.conn.close()


	def dump_to_JS(self, fileDir, fileName='tracedCalls.js'):
		# Convert the list of traced calls to a JS var declaration
		tracedCalls_dict = {}
		tracedCalls_dict['tracedCalls'] =  self.calls
		try:
			tracedCalls_json = json.dumps(tracedCalls_dict, cls=TracedCallJSONEncoder)
		except TypeError as e:
			print e
			raise
		JS_data = 'var tracedCalls = ' + tracedCalls_json + ';'
		
		# Write the result to a file
		JS_filePath = os.path.join(fileDir, fileName)
		JS_file = open(JS_filePath, 'w')
		JS_file.write(JS_data)
		