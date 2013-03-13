


"""
Giant mapping of Classes/Methods and API groups and subgroups.
This affects how we present and group the traced calls for 
example when generating an HTML report.
"""

# Data Storage
DATASTORAGE_GROUP = 'Data Storage'
FILESYSTEM_SUBGROUP = 'Filesystem'
USRPREFERENCES_SUBGROUP = 'User Preferences'
KEYCHAIN_SUBGROUP = 'Keychain'

# Crypto
CRYPTO_GROUP = 'Crypto'
COMMONCRYPTO_SUBGROUP = 'Common Crypto'
SECURITY_SUBGROUP = 'Security Framework'

# Network
NETWORK_GROUP = 'Network'
HTTP_SUBGROUP = 'HTTP'

# IPC
IPC_GROUP = 'IPC'
PASTEBOARD_SUBGROUP = 'Pasteboard'
URISCHEME_SUBGROUP = 'URI Schemes'

# Misc
XML_SUBGROUP = 'Misc'
XML_SUBGROUP = 'XML Parsing'

API_GROUPS_MAP = {
    FILESYSTEM_SUBGROUP : DATASTORAGE_GROUP,
    USRPREFERENCES_SUBGROUP : DATASTORAGE_GROUP,
    KEYCHAIN_SUBGROUP : DATASTORAGE_GROUP,
    COMMONCRYPTO_SUBGROUP : CRYPTO_GROUP,
    SECURITY_SUBGROUP : CRYPTO_GROUP,
    HTTP_SUBGROUP : NETWORK_GROUP,
    HTTP_SUBGROUP : NETWORK_GROUP,
    PASTEBOARD_SUBGROUP : IPC_GROUP,
    URISCHEME_SUBGROUP : IPC_GROUP,
    XML_SUBGROUP : XML_SUBGROUP,
    }


API_SUBGROUPS_MAP = {
    # Filesystem
    'NSData' : FILESYSTEM_SUBGROUP, 
    'NSFileHandle' : FILESYSTEM_SUBGROUP,
    'NSFileManager' : FILESYSTEM_SUBGROUP,
    'NSInputStream' : FILESYSTEM_SUBGROUP,
    'NSOutputStream' : FILESYSTEM_SUBGROUP,
    # User Preferences
    'NSUserDefaults' : USRPREFERENCES_SUBGROUP,
    # Keychain
    'SecItemAdd' : KEYCHAIN_SUBGROUP,
    'SecItemCopyMatching' : KEYCHAIN_SUBGROUP,
    'SecItemDelete' : KEYCHAIN_SUBGROUP,
    'SecItemUpdate' : KEYCHAIN_SUBGROUP,
    # Common Crypto
    'CCCryptorCreate' : COMMONCRYPTO_SUBGROUP,
    'CCCryptorCreateFromData' : COMMONCRYPTO_SUBGROUP,
    'CCCryptorUpdate' : COMMONCRYPTO_SUBGROUP,
    'CCCryptorFinal' : COMMONCRYPTO_SUBGROUP,
    'CCCrypt' : COMMONCRYPTO_SUBGROUP,
    'CCHmacInit' : COMMONCRYPTO_SUBGROUP,
    'CCHmacUpdate' : COMMONCRYPTO_SUBGROUP,
    'CCHmacFinal' : COMMONCRYPTO_SUBGROUP,
    'CCHmac' : COMMONCRYPTO_SUBGROUP,
    'CCKeyDerivationPBKDF' : COMMONCRYPTO_SUBGROUP,
    # Security Framework
    'SecPKCS12Import' : SECURITY_SUBGROUP,
    # HTTP
    'NSURLConnection' : HTTP_SUBGROUP,
    'NSURLConnectionDelegate' : HTTP_SUBGROUP,
    'NSURLCredential' : HTTP_SUBGROUP,
    'NSHTTPCookie' : HTTP_SUBGROUP,
    # Pasteboard
    'UIPasteboard' : PASTEBOARD_SUBGROUP,
    # URI Schemes
    'CFBundleURLTypes' : URISCHEME_SUBGROUP,
    # XML
    'NSXMLParser' : XML_SUBGROUP
}
    

        
        
