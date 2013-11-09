
# Mapping of values as seen by the tracer when hooking functions, and the corresponding names as described in the Apple documentation
# We use this to make put human-readable values in the report/output

IOS_ENUM_LIST = {
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

