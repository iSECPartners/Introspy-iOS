import os, shutil
from TraceStorage import TraceStorage

class HTMLReport:
    
    def __init__(self, introspy_db_path):
        self.traceStorage = TraceStorage(introspy_db_path)
        
        
    def write_to_directory(self, directory):
        
        # Create the directory
        os.makedirs(directory)
        
        # Copy the template
        shutil.copy('./html/report.html', directory)
        shutil.copy('./html/jquery.min.js', directory)
        shutil.copy('./html/handlebars.js', directory)
        
        # Dump the traced calls
        self.traceStorage.dump_to_JS(directory)
        