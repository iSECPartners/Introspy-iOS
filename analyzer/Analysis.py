import json, os
from TraceStorage import TraceStorage
from TracedCall import TracedCallJSONEncoder
from ScpClient import ScpClient

class Analyzer:
	""" Manages signature loading and matching """

	def __init__(self, introspy_db_path, signatures, group=None, subgroup=None):
		self.tracedCalls = self.open_or_find_db(introspy_db_path)
		self.signatures = self.get_group_signatures(signatures, group, subgroup)
		self.findings = []
		# Try each signature on the list of traced calls
		for sig in self.signatures:
			self.findings.append((sig, sig.analyze_trace(self.tracedCalls)))

	def get_findings(self):
		return self.findings

	def open_or_find_db(self, introspy_db_path):
		# the db is on device so we need to grab a local copy
		if introspy_db_path == 'remote':
		  scp = ScpClient()
		  remote_db_path = scp.find_all_dbs()
		  introspy_db_path = scp.fetch_db(remote_db_path)
		return TraceStorage(introspy_db_path).get_traced_calls()

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
		
