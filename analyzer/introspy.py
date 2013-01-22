#!/usr/bin/env python

""" Command-line parser for an introspy generated db. """

from sys import argv
from Analysis import Analyzer, Vuln
from jinja2 import Environment, PackageLoader

__author__	= "Tom Daniels & Alban Diquet"
__license__	= "?"
__copyright__	= "Copyright 2013, iSEC Partners, Inc."

def main(argv):
	env = Environment(loader=PackageLoader('introspy', 'html'))
	analyzer = Analyzer(argv[0], argv[1])
	findings = analyzer.runTests()
	template = env.get_template('templates/introspy.html')
	print template.render(findings=findings)

if __name__ == "__main__":
	main(argv[1:])
