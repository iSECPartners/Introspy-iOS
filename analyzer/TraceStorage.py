#!/usr/bin/env python

import sqlite3
from sys import exit
from TracedCall import TracedCall

class TraceStorage:
	""" Object representation of an introspy database """

	def __init__(self, db):
	    try:
		self.conn = sqlite3.connect(db)
		self.db = self.conn.cursor()
		self.db.execute("SELECT * FROM tracedCalls")
		self.calls = []
		for row in self.db:
			self.calls.append(TracedCall(row[0], row[1], row[2], row[3]))
	    except sqlite3.Error, e:
		print "Fatal error: %s" % e
		exit(1)
	    finally:
		if self.conn:
		    self.conn.close()
