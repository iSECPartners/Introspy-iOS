
from APIGroups import APIGroups


class Signature(object):
    """
    A Signature contains some metadata (title, description, etc.) plus a filter 
    that defines which calls the signature is going to match.
    """

    SEVERITY_INF = 'Informational'
    SEVERITY_LOW = 'Low'
    SEVERITY_MEDIUM = 'Medium'
    SEVERITY_HIGH = 'High'


    def __init__(self, title, description, severity, filter):
        self.title = title
        self.description = description
        self.severity = severity
        self.filter = filter
        # Figure out the signature's group and subgroup based
        # on the classes / methods it looks for
        self.subgroup = APIGroups.find_subgroup_from_filter(filter)
        self.group = APIGroups.find_group(self.subgroup)


    def find_matching_calls(self, calls):
        """
        Extracts from the supplied list of function calls a list of calls
        matching the signature.
        """
        matching_calls = []
        for call in self.filter.find_matching_calls(calls):
            matching_calls.append(call)
        return matching_calls


    def to_JSON_dict(self):
        """Returns a dictionnary of the signature that can be serialized to JSON."""
        # TODO: copy the dict
        sigDict = self.__dict__
        # Do not try to serialize the filter attribute
        del sigDict['filter']
        return sigDict


