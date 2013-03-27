#!/usr/bin/env python

""" Command-line parser for an introspy generated db. """

from sys import argv
from argparse import ArgumentParser
from Analysis import Analyzer
from Signatures import signature_list
from HTMLReport import HTMLReport

__author__	= "Tom Daniels & Alban Diquet"
__license__	= "?"
__copyright__	= "Copyright 2013, iSEC Partners, Inc."

def main(argv):
	parser = ArgumentParser(description="introspy analysis tool")
	parser.add_argument("db",
			help="the introspy-generated database to analyze")
	parser.add_argument("-o", "--outdir",
			help="generate an HTML report and write it to the specified directory")
	parser.add_argument("-s", "--signature",
			help="filter by signature class [FileSystem, HTTP, \
			UserPreferences, Pasteboard, XML, Crypto, KeyChain, \
			Schemes]")
#	parser.add_argument("-n", "--no-info",
#			action="store_false",
#			help="Don't run signatures that are purely informational")
	args = parser.parse_args()
	analyzer = Analyzer(args.db, signature_list, args.signature)
	
	if args.outdir: 
		report = HTMLReport(args.db, signature_list)
		report.write_to_directory(args.outdir)
	else:
		for (signature, matching_calls) in analyzer.get_findings():
			# Hide empty results
			# TODO: Print other stuff ? signature name or group ?
			if matching_calls:
				print "# %s" % signature.description
				for traced_call in matching_calls:
					print "  %s" % traced_call

if __name__ == "__main__":
	main(argv[1:])
	
