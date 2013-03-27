import json, os
from TraceStorage import TraceStorage
from TracedCall import TracedCallJSONEncoder

class Analyzer:
	""" Manages signature loading and matching """

	def __init__(self, introspy_db_path, signatures, group=None, subgroup=None):
		self.tracedCalls = TraceStorage(introspy_db_path).get_traced_calls()
		self.signatures = self.get_group_signatures(signatures, group, subgroup)
		self.findings = []
		# Try each signature on the list of traced calls
		for sig in self.signatures:
			self.findings.append((sig, sig.analyze_trace(self.tracedCalls)))

	def get_findings(self):
		return self.findings

	def get_group_signatures(self, signatures, group, subgroup=None):
		if group == None:
		  return signatures
		filtered_sigs = []
		for sig in signatures:
		  if sig.group.lower() == group.lower():
		    filtered_sigs.append(sig)
		return self.get_subgroup_signatures(filtered_sigs, subgroup)

	def get_subgroup_signatures(self, signatures, subgroup):
		if subgroup == None:
		  return signatures
	  	filtered_sigs = []
		for sig in signatures:
		  if sig.subgroup.lower() == subgroup.lower():
		    filtered_sigs.append(sig)
		return filtered_sigs

	def write_to_JS_file(self, fileDir, fileName='findings.js'):
		# Convert the list of findings to a JS var declaration
		findings_dict = {}
		findings_dict['findings'] = []
		for (sig, tracedCalls) in self.findings:
			if tracedCalls:
				findings_dict['findings'].append({	'signature' : sig,
												'calls' : tracedCalls})
		
		try:
			findings_json = json.dumps(findings_dict, cls=TracedCallJSONEncoder)
		except TypeError as e:
			print e
			raise
		JS_data = 'var findings = ' + findings_json + ';'
		
		# Write the result to a file
		JS_filePath = os.path.join(fileDir, fileName)
		JS_file = open(JS_filePath, 'w')
		JS_file.write(JS_data)
		
