import subprocess
from sys import exit
from ntpath import basename

class ScpClient:
	"""
	Identifies and securely copies an introspy database from a device to
	the localhost for analysis.
	"""

	def __init__(self):
	  ip = raw_input("Enter device domain name or IP address: ")
	  self.cnx_str = "mobile@%s" % ip

	def find_all_dbs(self):
	  cmd = "ssh %s find . -iname introspy-*.db" % self.cnx_str
	  proc = subprocess.Popen(cmd.split(),
			  stdout=subprocess.PIPE,
			  stderr=subprocess.PIPE)
	  dbs, err = proc.communicate()
	  # something went wrong
	  if err or len(dbs) is 0:
	    print "err => %s" % err
	    print "dbs => %s" % dbs
	    print "Couldn't find any introspy databases."
	    exit(0)
	  # remove local and parent directory entries
	  dbs = dbs.split()
	  # let the user choose which db to grab
	  for num, db in enumerate(dbs):
		print "%s. %s" % (num, db)
	  choice = int(raw_input("Select the database to analyze: "))
	  return dbs[choice]

	def fetch_db(self, remote_db_path):
	  cmd = "scp %s:%s ./" % (self.cnx_str, remote_db_path)
	  proc = subprocess.Popen(cmd.split(),
			  stdout=subprocess.PIPE,
			  stderr=subprocess.PIPE)
	  out, err = proc.communicate()
	  # something went wrong
	  if err:
	    print "Error copying file from remote device."
	    exit(0)
	  return basename(remote_db_path)

