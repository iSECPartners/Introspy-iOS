from TraceStorage import TraceStorage

class Vuln:
	def __init__(self, severity, desc, clazz, method, attrs, val):
		self.severity = severity
		self.desc = desc
		self.clazz = clazz
		self.method = method
		self.attrs = attrs.split('/')
		self.val = val

	def __str__(self):
		return self.desc

	def checkConditions(self, trace):
		for call in trace:
			if call.clazz == self.clazz and \
 			   call.method == self.method:
				attribute = call.args
				for key in self.attrs:
					try:
						attribute = attribute[key]
					except KeyError, e:
						break
				if attribute == self.val:
					print "%s\n\t%s" % (self, call)

class Analyzer:
	def __init__(self, db, vulns):
		self.trace = TraceStorage(db)
		self.vulns_to_test_for = []
		self.loadVulnsToTestFor(vulns)

	def loadVulnsToTestFor(self, filename):
		vulnList = open(filename, 'r')
		for line in vulnList:
			args = line.split(',')
			self.addVulnToTestFor(
			  Vuln(args[0], args[1], args[2], args[3], args[4], args[5].strip()))

	def addVulnToTestFor(self, vuln):
		self.vulns_to_test_for.append(vuln)

	def runTests(self):
		for vuln in self.vulns_to_test_for:
			vuln.checkConditions(self.trace.calls)

