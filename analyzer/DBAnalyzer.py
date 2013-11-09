from json import dumps
from IOS_SIGNATURES import IOS_SIGNATURES
from DBParser import DBParser


class DBAnalyzer(DBParser):
    """
    Parses and analyzes an introspy DB using a supplied set of signatures.
    """

    def __init__(self, dbPath, signatures=IOS_SIGNATURES):
        # Parse the DB
        super(DBAnalyzer, self).__init__(dbPath)
        
        # Try each signature on the list of traced calls
        self.findings = []
        for sig in signatures:
            self.findings.append((sig, sig.find_matching_calls(self.tracedCalls)))

    
    def get_findings_as_text(self, group=None, subgroup=None):
        """
        Returns the list of findings belonging to the supplied API group and/or subgroup as printable text.
        """
        for (signature, matching_calls) in self.findings:
            if matching_calls:

                if group and signature.group.lower() != group.lower():
                    continue
                if subgroup and signature.subgroup.lower() != subgroup.lower():
                    continue

                print "# %s" % signature if isinstance(signature, str) else signature.description
                for traced_call in matching_calls:
                    print "  %s" % traced_call


    def get_findings_as_JSON(self):
        """Returns the list of findings as JSON."""
        findings_dict = {}
        findings_dict['findings'] = []
        for (sig, tracedCalls) in self.findings:
            if tracedCalls:
                findings_dict['findings'].append({'signature' : sig,
                'calls' : tracedCalls})
        
        return dumps(findings_dict, default=self._json_serialize)


