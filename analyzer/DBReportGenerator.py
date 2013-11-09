import shutil
import os

from APIGroups import APIGroups
from DBAnalyzer import DBAnalyzer
from DBParser import DBParser


class DBReportGenerator:
    """
    Generates an HTML report given an Introspy DB file and 
    a list of vuln signatures to check for.
    """

    TRACED_CALLS_FILE_NAME =  'tracedCalls.js'
    FINDINGS_FILE_NAME =      'findings.js'
    API_GROUPS_FILE_NAME =    'apiGroups.js'

    TEMPLATE_FOLDER = './html'


    @classmethod
    def write_report_to_directory(cls, dbPath, outDir):
        tracedCallsDB = DBParser(dbPath)
        analyzer = DBAnalyzer(tracedCallsDB)

        # Copy the template
        shutil.copytree(cls.TEMPLATE_FOLDER, outDir)

        # Copy the DB file
        shutil.copy(dbPath, outDir)

        # Dump the traced calls
        with open(os.path.join(outDir, cls.TRACED_CALLS_FILE_NAME), 'w') as jsFile:
            jsFile.write('var tracedCalls = ' + tracedCallsDB.get_traced_calls_as_JSON() + ';')

        # Dump the findings
        with open(os.path.join(outDir, cls.FINDINGS_FILE_NAME), 'w') as jsFile:
            jsFile.write( 'var findings = ' + analyzer.get_findings_as_JSON() + ';')

        # Dump the API groups
        with open(os.path.join(outDir, cls.API_GROUPS_FILE_NAME), 'w') as jsFile:
            jsFile.write('var apiGroups = ' + APIGroups.get_groups_as_JSON() + ';')
 
