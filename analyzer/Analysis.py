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
		findings = []
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
					call.vuln = self
					findings.append(call)
		return findings

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
			  Vuln(args[0],			# severity
			       args[1],			# description
			       args[2],			# class name
			       args[3],			# method name
			       args[4],			# attribute to test for
			       args[5].strip())) 	# attribute value

	def addVulnToTestFor(self, vuln):
		self.vulns_to_test_for.append(vuln)

	def runTests(self):
		findings = []
		for vuln in self.vulns_to_test_for:
			result = vuln.checkConditions(self.trace.calls)
			if result:
				findings.append(result)
		return findings

