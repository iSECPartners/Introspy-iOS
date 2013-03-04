from TraceStorage import TraceStorage


class Analyzer:
	""" Manages signature loading and matching """

	def __init__(self, db, sigs, filter, info):
		self.trace = TraceStorage(db)
		self.signatures = []
		self.load_signatures(sigs, filter, info)

	def load_signatures(self, signatures, sclass=None, info=True):
		for sig in signatures:
			if sclass is None or sclass == sig['sig_class']:
				if info or sig['severity'] != SEVERITY_INF:
					self.signatures.append(sig)

	def check_signatures(self):
		findings = []
		for sig in self.signatures:
			findings.append((sig, sig.analyze_trace(self.trace.calls)))
		return findings

