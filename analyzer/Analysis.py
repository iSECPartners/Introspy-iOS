from TraceStorage import TraceStorage
from Signatures import Signature, NoAttrSignature, SingleAttrSignature, MultiAttrRVSignature

class Analyzer:
	""" Manages signature loading and matching """

	def __init__(self, db, sigs, filter, info):
		self.trace = TraceStorage(db)
		self.signatures = []
		self.load_signatures(sigs, filter, info)

	def load_signatures(self, signatures, sclass=None, info=True):
		for sig in signatures:
			if sclass is None or sclass == sig['sig_class']:
				if info or sig['severity'] != "Informational":
					self.add_signature(sig)

	def add_signature(self, sig):
		if sig['val'] is None:
			self.signatures.append(NoAttrSignature(sig))
		elif len(sig['val']) == 1:
			self.signatures.append(SingleAttrSignature(sig))
		elif (len(sig['val']) > 1) and ('returnValue' in sig['attr'][0]):
			self.signatures.append(MultiAttrRVSignature(sig))

	def check_signatures(self):
		findings = {}
		for sig in self.signatures:
			key, results = sig.check_signature(self.trace.calls)
			if results:
				if key not in findings.keys():
					findings[key] = results
				else:
					findings[key] += results
		return findings

