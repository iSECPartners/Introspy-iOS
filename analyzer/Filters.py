

class MethodsFilter(object):
	"""
	Basic filter used to find traced calls matching specific classes and method 
	names.
	"""

	def __init__(self, classes_to_match, methods_to_match):
		self.classes_to_match = classes_to_match
		self.methods_to_match = methods_to_match

	def find_matching_calls(self, trace):
		for call in trace:
		  if call.clazz in self.classes_to_match:
		    if call.method in self.methods_to_match:
			yield call

class ArgumentsFilter(MethodsFilter):
	"""
	Filter to find calls that match one or multiple attributes within the
	call's arguments or return value. All specified attributes have to be part
	of the traced call.
	"""

	def __init__(self, classes_to_match, methods_to_match, args_to_match, value_mask=None):
		super(ArgumentsFilter, self).__init__(classes_to_match, methods_to_match)
		self.args_to_match = args_to_match
		self.value_mask = value_mask

	def extract_matching_values(self, trace):
		"""Returns a list of matching calls and values found for the given arguments"""
		# First find the calls matching the methods and classes
		for call in super(ArgumentsFilter, self).find_matching_calls(trace):
			# Find the argument we're interested in
			# Assuming only one argument with the name we're looking for
			found_values = []
			try:
				for (arg_path, value) in self.args_to_match:
					# Get the value of each argument and fail if one is missing
					found_values.append(call.extract_value_for_argument(arg_path))
				yield (call, found_values)
			except KeyError:
					pass

	def find_matching_calls(self, trace):
		for (call, found_values) in self.extract_matching_values(trace):
			# Check that found values match the expected values
			match = True
			for position, (arg_path, value_to_match) in enumerate(self.args_to_match):
				# treat the value as an int because we found a value_mask
				if value_to_match and self.value_mask is not None:
					if value_to_match != (int(found_values[position]) & self.value_mask):
						match = False
						break
				# string comparison
				else:
					if str(value_to_match) != str(found_values[position]):
						match = False
						break
			# None for the expected value means any value is OK
			if match:
				yield call
