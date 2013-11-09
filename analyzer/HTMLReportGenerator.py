import shutil
import os

from APIGroups import APIGroups
from DBAnalyzer import DBAnalyzer
from DBParser import DBParser


class HTMLReportGenerator:
    """
    Generates an HTML report given an analyzed Introspy DB.
    """

    TRACED_CALLS_FILE_NAME =  'tracedCalls.js'
    FINDINGS_FILE_NAME =      'findings.js'
    API_GROUPS_FILE_NAME =    'apiGroups.js'

    TEMPLATE_FOLDER = './html'


    def __init__(self, analyzedDB):
        self.analyzedDB = analyzedDB


    def write_report_to_directory(self, outDir):
        # Copy the template
        shutil.copytree(self.TEMPLATE_FOLDER, outDir)

        # Copy the DB file
        shutil.copy(self.analyzedDB.dbPath, outDir)

        # Dump the traced calls
        with open(os.path.join(outDir, self.TRACED_CALLS_FILE_NAME), 'w') as jsFile:
            jsFile.write('var tracedCalls = ' + self.analyzedDB.get_traced_calls_as_JSON() + ';')

        # Dump the findings
        with open(os.path.join(outDir, self.FINDINGS_FILE_NAME), 'w') as jsFile:
            jsFile.write( 'var findings = ' + self.analyzedDB.get_findings_as_JSON() + ';')

        # Dump the API groups
        with open(os.path.join(outDir, self.API_GROUPS_FILE_NAME), 'w') as jsFile:
            jsFile.write('var apiGroups = ' + APIGroups.get_groups_as_JSON() + ';')
 
