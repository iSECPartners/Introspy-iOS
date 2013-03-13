import shutil
from TraceStorage import TraceStorage
from Analysis import Analyzer

class HTMLReport:
    """
    Generates an HTML report given an Introspy DB file and 
    a list of vuln signatures to check for.
    """
    def __init__(self, introspy_db_path, signature_list):
        self.traceStorage = TraceStorage(introspy_db_path)
        self.analyzer = Analyzer(introspy_db_path, signature_list)
        
    def write_to_directory(self, directory):
        
        # Copy the template
        shutil.copytree('./html', directory)
        
        # Dump the traced calls
        self.traceStorage.write_to_JS_file(directory)
        
        # Dump the findings
        self.analyzer.write_to_JS_file(directory)
        