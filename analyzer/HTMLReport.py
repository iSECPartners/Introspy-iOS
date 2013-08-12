import shutil
from TraceStorage import TraceStorage
from Analysis import Analyzer
from APIGroups import APIGroups

class HTMLReport:
    """
    Generates an HTML report given an Introspy DB file and 
    a list of vuln signatures to check for.
    """
    def __init__(self, analyzer):
        self.analyzer = analyzer
        self.traceStorage = self.analyzer.storage

    def write_to_directory(self, directory):
        # Copy the template
        shutil.copytree('./html', directory)
        # Copy the DB file
#        shutil.copy(self.db_filename, directory)
        # Dump the traced calls
        self.traceStorage.write_to_JS_file(directory)
        # Dump the findings
        self.analyzer.write_to_JS_file(directory)
        # Dump the API groups
        APIGroups.write_to_JS_file(directory)
 
