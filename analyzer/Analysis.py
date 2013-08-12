from json import dumps
from os import path
from TraceStorage import TraceStorage
from TracedCall import TracedCallJSONEncoder

class Analyzer:
    """ Manages signature loading and matching """

    def __init__(self, db_path, signatures, group=None, subgroup=None, list_only=False):
        self.storage = TraceStorage(db_path)
        self.tracedCalls = self.storage.get_traced_calls(group, subgroup)
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

    def write_to_JS_file(self, fileDir, fileName='findings.js'):
        # Convert the list of findings to a JS var declaration
        findings_dict = {}
        findings_dict['findings'] = []
        for (sig, tracedCalls) in self.findings:
            if tracedCalls:
                findings_dict['findings'].append({'signature' : sig,
                'calls' : tracedCalls})
        try:
            findings_json = dumps(findings_dict, cls=TracedCallJSONEncoder)
        except TypeError as e:
            print e
            raise
        JS_data = 'var findings = ' + findings_json + ';'
        
        # Write the result to a file
        JS_filePath = path.join(fileDir, fileName)
        JS_file = open(JS_filePath, 'w')
        JS_file.write(JS_data)
