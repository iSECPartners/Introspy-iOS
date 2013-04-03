import json, os
from TraceStorage import TraceStorage
from TracedCall import TracedCallJSONEncoder
from ScpClient import ScpClient
from Signatures import Signature

class Analyzer:
	""" Manages signature loading and matching """

	def __init__(self, introspy_db_path, signatures, group=None, subgroup=None, list_only=False):
		self.tracedCalls = self.fetch_and_filter_calls(introspy_db_path, group, subgroup)
		self.signatures = signatures
		self.findings = []
		# List all calls (optionally filtered by group/subgroup) and bypass signature analysis
		if list_only:
			self.findings.append(("Call List", self.tracedCalls))
		# Try each signature on the list of traced calls
		else:
		    for sig in self.signatures:
			self.findings.append((sig, sig.analyze_trace(self.tracedCalls)))

	def get_findings(self):
		return self.findings

	def fetch_and_filter_calls(self, introspy_db_path, group=None, subgroup=None):
		# the db is on device so we need to grab a local copy
		if introspy_db_path == 'remote':
		  scp = ScpClient()
		  introspy_db_path = scp.select_and_fetch_db()
		return TraceStorage(introspy_db_path).get_traced_calls(group, subgroup)

	def write_to_JS_file(self, fileDir, fileName='findings.js'):
		# Convert the list of findings to a JS var declaration
		findings_dict = {}
		findings_dict['findings'] = []
		for (sig, tracedCalls) in self.findings:
			if tracedCalls:
				findings_dict['findings'].append({
					'signature' : sig, 'calls' : tracedCalls})
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

