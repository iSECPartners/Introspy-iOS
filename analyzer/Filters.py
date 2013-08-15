

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

    def __init__(self, classes_to_match, methods_to_match, args_to_match):
        super(ArgumentsFilter, self).__init__(classes_to_match, methods_to_match)
        self.args_to_match = args_to_match


    def find_matching_calls(self, trace):
        for (call, found_values) in self._extract_matching_values(trace):
            # Check that found values match the expected values
            match = True
            for position, (_, value_to_match) in enumerate(self.args_to_match):
                if value_to_match: 
                    if str(value_to_match) != str(found_values[position]):
                        match = False
                        break

            # None for the expected value means any value is OK
            if match:
                yield call


    def _extract_matching_values(self, trace):
        """Returns a list of matching calls and values found for the given arguments"""
        # First find the calls matching the methods and classes
        for call in super(ArgumentsFilter, self).find_matching_calls(trace):
            # Find the argument we're interested in
            # Assuming only one argument with the name we're looking for
            found_values = []
            try:
                for (arg_path, _) in self.args_to_match:
                    # Get the value of each argument and fail if one is missing
                    found_values.append(call.extract_value_for_argument(arg_path))
                yield (call, found_values)
            except KeyError:
                # Argument wasn't found
                pass


class ArgumentsNotSetFilter(ArgumentsFilter):

    def _extract_matching_values(self, trace):
        # First find the calls matching the methods and classes
        for call in super(ArgumentsFilter, self).find_matching_calls(trace):
            # Look for the argument we're interested and return the call if the
            # argument isn't there
            try:
                for (arg_path, _) in self.args_to_match:
                    call.extract_value_for_argument(arg_path)
            except KeyError:
                # Argument wasn't found
                yield (call, [None])
            

class ArgumentsWithMaskFilter(ArgumentsFilter):
    """
    Filter to find a specific argument and check specific bits within its
    value using a bit mask. To simplify, it only works with one argument for now.
    Only used for NSData atm.
    TODO: Fix it
    """

    def __init__(self, classes_to_match, methods_to_match, args_to_match, value_mask):

        super(ArgumentsWithMaskFilter, self).__init__(classes_to_match, methods_to_match, args_to_match)
        self.value_mask = value_mask


    def _extract_matching_values(self, trace):
        """Returns a list of values found for the arg_to_match"""
        # First find the calls matching the classes, methods and args
        for (call, found_values) in super(ArgumentsWithMaskFilter, self)._extract_matching_values(trace):
            try: # The value has to be an int for a bit mask to be meaningful
            # Only checl one value for now
                int_value = int(found_values[0])
            except ValueError:
                # Not a valid int... something is wrong with the data, crash the program
                raise

            # Extract the actual flag using the provided mask
            yield (call, [(self.value_mask & int_value)])
