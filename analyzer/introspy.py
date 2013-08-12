#!/usr/bin/env python

""" Command-line parser for an introspy generated db. """

__version__   = '0.1.0'
__author__    = "Tom Daniels & Alban Diquet"
__license__   = "See ../LICENSE"
__copyright__ = "Copyright 2013, iSEC Partners, Inc."

from sys import argv
from argparse import ArgumentParser
from re import match
from Analysis import Analyzer
from Signatures import signature_list
from ScpClient import ScpClient
from HTMLReport import HTMLReport
from APIGroups import APIGroups

class Introspy:
    """ Sets up and initiates analysis """

    def __init__(self, args):
	if match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$", args.db):
            # the db is on device so we need to grab a local copy
            scp = ScpClient(ip=args.db)
            db_path = scp.select_and_fetch_db()
        else:
            db_path = args.db
        self.analyzer = Analyzer(db_path, signature_list, args.group, args.sub_group, args.list)
	self.print_results(args.outdir)

    def print_results(self, outdir=None):
        if outdir:
            report = HTMLReport(self.analyzer)
            report.write_to_directory(outdir)
        else:
            for (signature, matching_calls) in self.analyzer.get_findings():
                if matching_calls:
                    print "# %s" % signature if isinstance(signature, str) else signature.description
                    for traced_call in matching_calls:
                        print "  %s" % traced_call

def main(argv):
    parser = ArgumentParser(description="introspy analysis and report\
        generation tool", version=__version__)
    html_group = parser.add_argument_group('html report format options')
    html_group.add_argument("-o", "--outdir",
        help="Generate an HTML report and write it to the\
        specified directory (ignores all other command line\
        optons).")
    cli_group = parser.add_argument_group('command-line options')
    cli_group.add_argument("-l", "--list",
        action="store_true",
        help="List traced calls (no signature analysis\
        performed)")
    cli_group.add_argument("-g", "--group",
        choices=APIGroups.API_GROUPS_LIST,
        help="Filter by signature group")
    cli_group.add_argument("-s", "--sub-group",
        choices=APIGroups.API_SUBGROUPS_LIST,
        help="Filter by signature sub-group")
    parser.add_argument("db",
        help="The introspy-generated database to analyze.\
        specifying an IP address initiates the analyzer to fetch a\
        remote database from the specified iOS device.")
    args = parser.parse_args()
 
    Introspy(args)

if __name__ == "__main__":
    main(argv[1:])
