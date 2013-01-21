#!/usr/bin/env python

import sqlite3
from TracedCall import TracedCall

class TraceStorage:
	def __init__(self, db):
		self.conn = sqlite3.connect(db)
		self.db = self.conn.cursor()
		self.db.execute("SELECT * FROM tracedCalls WHERE methodName LIKE 'generalPasteboard' LIMIT 10")
		self.calls = []
		for row in self.db:
			self.calls.append(TracedCall(row[0], row[1], row[2], row[3]))

