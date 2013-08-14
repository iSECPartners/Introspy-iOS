from plistlib import Data

enum_list = {
    # Keychain
    ## kSecAttrAccessible values
    'pdmn' : {'ak' : 'kSecAttrAccessibleWhenUnlocked',
              'aku': 'kSecAttrAccessibleWhenUnlockedThisDeviceOnly',
              'dk' : 'kSecAttrAccessibleAlways',
              'dku': 'kSecAttrAccessibleAlwaysThisDeviceOnly',
              'ck' : 'kSecAttrAccessibleAfterFirstUnlock',
              'cku': 'kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly'},
    ## kSecClass values
    'class' : {'idnt' : 'kSecClassIdentity',
               'genp' : 'kSecClassGenericPassword',
               'inet' : 'kSecClassInternetPassword',
               'cert' : 'kSecClassCertificate',
               'keys' : 'kSecClassKey'},
    # NSData
    ## NSDataWritingOptions
    'mask' : {0x10000000 : 'NSDataWritingFileProtectionNone',
              0x20000000 : 'NSDataWritingFileProtectionComplete',
              0x30000000 : 'NSDataWritingFileProtectionCompleteUnlessOpen',
              0x40000000 : 'NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication',
              'mask'     : 0xf0000000},
    # CCCrypt and friends
    ## algorithm
    'alg'  : {0 : 'kCCAlgorithmAES128',
              1 : 'kCCAlgorithmDES',
              2 : 'kCCAlgorithm3DES',
              3 : 'kCCAlgorithmCAST',
              4 : 'kCCAlgorithmRC4',
              5 : 'kCCAlgorithmRC2',
              6 : 'kCCAlgorithmBlowfish'},
    ## operation
    'op'   : {0 : 'kCCEncrypt',
	      1 : 'kCCDecrypt'},
    ## options
    'options' : {0x001 : 'kCCOptionPKCS7Padding',
	         0x002 : 'kCCOptionECBMode'},
    # NSURLCredentialPersistence
    'persistence' : {0 : 'NSURLCredentialPersistenceNone',
                     1 : 'NSURLCredentialPersistenceForSession',
                     2 : 'NSURLCredentialPersistencePermanent'}
}

class TypeRefToStr:
    """ Converts enum values to human-readable strings. """

    def __init__(self, argsAndReturnValue):
        self.args = self.find_and_replace(argsAndReturnValue)

    def find_and_replace(self, d):
        items = d.items()
        items.sort()
        for v in items:
            if isinstance(v[1], dict):
                self.find_and_replace(v[1])
            elif isinstance(v[1], list):
                continue
            elif isinstance(v[1], Data):
                # Serialize a plist <data>
                try: # Does it seem to be ASCII ?
                    d[v[0]] = v[1].data.encode('ascii')
                except UnicodeDecodeError: # No => base64 encode it
                    d[v[0]] = v[1].data.encode('base64')
            else:
                if v[0] in enum_list:
                    try:
                        if 'mask' in enum_list[v[0]]:
			    d[v[0]] = enum_list[v[0]][v[1] & enum_list[v[0]]['mask']]
                        else:
                            d[v[0]] = enum_list[v[0]][v[1]]
                    except KeyError:
                        continue
        return d
