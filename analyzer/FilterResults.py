

class FilterResults(object):
	"""
	A list of TracedCalls that match a filter run against
	the TraceStorage, ie. the list of all TracedCalls stored
	in the introspy DB.
	"""

	def __init__(self, group, severity, description, matching_calls):

		self.group = group 
		self.severity = severity 
		self.description = description
		self.matching_calls = matching_calls
