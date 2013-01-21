from TraceStorage import TraceStorage

class Vuln:
	def __init__(self, desc, clazz, method, attrs):
		self.desc = desc
		self.clazz = clazz
		self.method = method
		self.attrs = attrs

	def __str__(self):
		return self.desc

	def checkConditions(self, trace):
		for call in trace:
			if call.clazz == self.clazz and call.method == self.method:
				   print "%s\n\t%s" % (self, call)


class Analyzer:
	def __init__(self, db):
		self.trace = TraceStorage(db)
		self.vulns_to_test_for = []

	def addVulnToTestFor(self, vuln):
		self.vulns_to_test_for.append(vuln)
		vuln.checkConditions(self.trace.calls)

