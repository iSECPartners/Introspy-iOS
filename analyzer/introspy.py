#!/usr/bin/env python

""" Command-line parser for an introspy generated db. """

from sys import argv
from Analysis import Analyzer, Vuln

__author__	= "Tom Daniels & Alban Diquet"
__license__	= "?"
__copyright__	= "Copyright 2013, iSEC Partners, Inc."

def main(argv):
	analyzer = Analyzer(argv[0])
	analyzer.addVulnToTestFor(Vuln(
		"Application copies data to the UIPasteboard's publicly accessible generalPasteboard",
		"UIPasteboard",
		"generalPasteboard",
		None))

if __name__ == "__main__":
	main(argv[1:])
