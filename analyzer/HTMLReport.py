import shutil
from TraceStorage import TraceStorage

class HTMLReport:
    
    def __init__(self, introspy_db_path):
        self.traceStorage = TraceStorage(introspy_db_path)
        
        
    def write_to_directory(self, directory):
        
        # Copy the template
        shutil.copytree('./html', directory)
        
        # Dump the traced calls
        self.traceStorage.dump_to_JS(directory)
        