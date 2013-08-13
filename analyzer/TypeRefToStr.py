from plistlib import Data

enum_list = {
    'ak' : 'kSecAttrAccessibleWhenUnlocked',
    'aku': 'kSecAttrAccessibleWhenUnlockedThisDeviceOnly',
    'dk' : 'kSecAttrAccessibleAlways',
    'dku': 'kSecAttrAccessibleAlwaysThisDeviceOnly',
    'ck' : 'kSecAttrAccessibleAfterFirstUnlock',
    'cku': 'kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly'
}

class TypeRefToStr:
    """ Converts enum values to human-readable strings. """

    def __init__(self, argsAndReturnValue):
        self.args = self.find_and_replace(argsAndReturnValue)

    def find_and_replace(self, d, level=0):
        arg_str = ""
        items = d.items()
        items.sort()
        for v in items:
            if isinstance(v[1], dict):
                nextlevel = level + 1
                self.find_and_replace(v[1], nextlevel)
            elif isinstance(v[1], list) or isinstance(v[1], Data):
                continue
            else:
                if v[1] in enum_list:
                    print "{0} => {1}".format(v[0], enum_list[v[1]])
                    d[v[0]] = enum_list[v[1]]
        return d
