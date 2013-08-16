from Filters import MethodsFilter, ArgumentsFilter, ArgumentsNotSetFilter
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
        # TODO: Define the metadata we actually need 
        self.title = title
        self.description = description
        self.severity = severity
        self.filter = filter
        # Figure out the signature's group and subgroup based
        # on the classes / methods it looks for
        self.subgroup = APIGroups.find_subgroup_from_filter(filter)
        self.group = APIGroups.find_group(self.subgroup)


    def analyze_trace(self, trace):
        matching_calls = []
        for call in self.filter.find_matching_calls(trace):
            matching_calls.append(call)
        return matching_calls


# Global list of signatures
signature_list = []

# Signature titles have to be unique or HTML reports will break
# TODO: Fix it

# XML signature
signature_list.append(Signature(
    title = 'Vulnerable XML Parser',
    description = 'An XML parser is configured to resolve external entities.',
    severity = Signature.SEVERITY_HIGH,
    filter = ArgumentsFilter(
        classes_to_match = ['NSXMLParser'],
        methods_to_match = ['setShouldResolveExternalEntities:'],
        args_to_match = [
            (['arguments', 'shouldResolveExternalEntities'], 'True')])))

# Security Framework signatures
signature_list.append(Signature(
    title = 'Client Certificate Import',
    description = 'The application imported a private key and a certificate from a PKCS12 file.',
    severity = Signature.SEVERITY_INF,
    filter = MethodsFilter(
        classes_to_match = ['C'],
        methods_to_match = ['SecPKCS12Import'])))

# Keychain signatures
KSECATTR_VALUES = [
    #('kSecAttrAccessibleWhenUnlocked', Signature.SEVERITY_INF, 'AccessibleWhenUnlocked'),
    #('kSecAttrAccessibleWhenUnlockedThisDeviceOnly', Signature.SEVERITY_INF, 'AccessibleWhenUnlockedThisDeviceOnly'),
    ('kSecAttrAccessibleAlways', Signature.SEVERITY_HIGH, 'AccessibleAlways'),
    ('kSecAttrAccessibleAlwaysThisDeviceOnly', Signature.SEVERITY_HIGH, 'AccessibleAlwaysThisDeviceOnly'),
    ('kSecAttrAccessibleAfterFirstUnlock', Signature.SEVERITY_MEDIUM, 'AccessibleAfterFirstUnlock'),
    ('kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly', Signature.SEVERITY_MEDIUM, 'AccessibleAfterFirstUnlockThisDeviceOnly')
]

for (kSecAttr_value, severity, kSecAttr_title) in KSECATTR_VALUES:
    signature_list.append(Signature(
        title = 'Keychain Data Protection - ' + kSecAttr_title,
        description = 'An item was added to the KeyChain with the accessibility options "{0}".'.format(kSecAttr_value),
        severity = severity,
        filter = ArgumentsFilter(
            classes_to_match = ['C'],
            methods_to_match = ['SecItemAdd'],
            args_to_match = [
                (['arguments', 'attributes', 'pdmn'], kSecAttr_value)])))

signature_list.append(Signature(
    title = 'Keychain Data Protection Not Specified',
    description = 'An item was added to the KeyChain without any accessibility '
        'options. Prior to iOS 6, the default setting is kSecAttrAccessibleAlways.',
    severity = Signature.SEVERITY_LOW,
    filter = ArgumentsNotSetFilter(
        classes_to_match = ['C'],
        methods_to_match = ['SecItemAdd'],
        args_to_match = [
            (['arguments', 'attributes', 'pdmn'], None)])))


# Pasteboard signatures
signature_list.append(Signature(
    title = 'Pasteboard Usage',
    description = 'The application instantiates one or multiple Pasteboards.',
    severity = Signature.SEVERITY_INF,
    filter = MethodsFilter(
        classes_to_match = ['UIPasteboard'],
        methods_to_match = ['generalPasteboard', 
                            'pasteboardWithName:create:',
                            'pasteboardWithUniqueName'])))

# HTTP signatures
signature_list.append(Signature(
    title = 'NSURLCredential Stored Permanently',
    description = 'An NSURLCredential object is permanently stored into the Keychain with a' \
		    ' persistence value of NSURLCredentialPersistencePermanent',
    severity = Signature.SEVERITY_LOW,
    filter = ArgumentsFilter(
        classes_to_match = ['NSURLCredential'],
	methods_to_match = ['initWithUser:password:persistence:',
		'initWithIdentity:certificates:persistence:'],
	args_to_match = [ (['arguments', 'persistence'],
		'NSURLCredentialPersistencePermanent')])))

signature_list.append(Signature(
    title = 'HTTPS Caching',
    description = 'Data received over HTTPS is being cached on disk.',
    severity = Signature.SEVERITY_LOW,
    filter = ArgumentsFilter(
        classes_to_match = ['NSURLConnectionDelegate'],
        methods_to_match = ['connection:willCacheResponse:'],
        args_to_match = [
            (['returnValue', 'response', 'URL', 'scheme'], 'https'),
            (['returnValue', 'storagePolicy'], 0) ])))

signature_list.append(Signature(
	title = 'Lack of Credential Validation',
	description = 'The application is bypassing credential validation.',
	severity = Signature.SEVERITY_HIGH,
	filter = MethodsFilter(
		classes_to_match = ['NSURLConnectionDelegate'],
		methods_to_match = ['continueWithoutCredentialForAuthenticationChallenge:'])))

# Filesystem signatures
# For NSData

NSDATA_DPAPI_VALUES = {
    ('NSDataWritingFileProtectionNone', Signature.SEVERITY_HIGH, 'ProtectionNone'),
    #('NSDataWritingFileProtectionComplete', Signature.SEVERITY_INF, 'Complete'),
    #('NSDataWritingFileProtectionCompleteUnlessOpen', Signature.SEVERITY_INF, 'CompleteUnlessOpen'),
    ('NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication', Signature.SEVERITY_INF, 'ProtectionCompleteUntilFirstUserAuthentication')}

for (fileProt_mask, severity, fileProt_title) in NSDATA_DPAPI_VALUES:
    signature_list.append(Signature(
        title = 'Data Protection With NSData - ' + fileProt_title,
        description = 'A file was written with the data protection option "{0}".'.format(fileProt_mask),
        severity = severity,
        filter = ArgumentsFilter(
            classes_to_match = ['NSData'],
            methods_to_match = ['writeToFile:options:error:', 'writeToURL:options:error:'],
            args_to_match = [
                (['arguments', 'mask'], fileProt_mask)])))

signature_list.append(Signature(
    title = 'Lack of Data Protection With NSData',
    description = 'A file was written without any data protection options.',
    severity = Signature.SEVERITY_MEDIUM,
    filter = MethodsFilter(
        classes_to_match = ['NSData'],
        methods_to_match = ['writeToFile:atomically:', 'writeToURL:atomically:'])))    

# For NSFileManager
NSFILEMANAGER_DPAPI_VALUES = {
    ('NSFileProtectionNone', Signature.SEVERITY_HIGH, 'ProtectionNone'),
    #('NSFileProtectionComplete', Signature.SEVERITY_INF, 'Complete'),
    #('NSFileProtectionCompleteUnlessOpen', Signature.SEVERITY_INF, 'CompleteUnlessOpen'),
    ('NSFileProtectionCompleteUntilFirstUserAuthentication', Signature.SEVERITY_INF, 'ProtectionCompleteUntilFirstUserAuthentication')}

for (fileProt_value, severity, fileProt_title) in NSFILEMANAGER_DPAPI_VALUES:
    signature_list.append(Signature(
        title = 'Data Protection With NSFileManager - ' + fileProt_title,
        description = 'A file written with the data protection option "{0}".'.format(fileProt_value),
        severity = severity,
        filter = ArgumentsFilter(
            classes_to_match = ['NSFileManager'],
            methods_to_match = ['createFileAtPath:contents:attributes:'],
            args_to_match = [
                (['arguments', 'attributes', 'NSFileProtectionKey'], fileProt_value)])))


signature_list.append(Signature(
    title = 'Lack of Data Protection With NSFileManager',
    description = 'A file was written without any data protection options.',
    severity = Signature.SEVERITY_MEDIUM,
    filter = ArgumentsNotSetFilter(
            classes_to_match = ['NSFileManager'],
            methods_to_match = ['createFileAtPath:contents:attributes:'],
            args_to_match = [
                (['arguments', 'attributes', 'NSFileProtectionKey'], None)])))


# URL scheme signatures
signature_list.append(Signature(
    title = 'URL Schemes',
    description = 'The following URL schemes are exposed by the application.',
    severity = Signature.SEVERITY_INF,
    filter = MethodsFilter(
        classes_to_match = ['CFBundleURLTypes'],
        methods_to_match = ['CFBundleURLSchemes'])))

# UIApplicationDelegate signatures
#signature_list.append(Signature(
#    title = 'Custom URL scheme accessed.',
#    description = 'Custom URL scheme accessed.',
#    severity = Signature.SEVERITY_INF,
#    filter = MethodsFilter(
#        classes_to_match = ['UIApplicationDelegate'],
#        methods_to_match = ['application:openURL:sourceApplication:annotation:', 'application:handleOpenURL:'])))

# NSURLConnectionDelegate signatures
signature_list.append(Signature(
    title = 'HTTPS to HTTP Redirection',
    description = 'The application transitioned from a TLS to plaintext connection.',
    severity = Signature.SEVERITY_HIGH,
    filter = ArgumentsFilter(
        classes_to_match = ['NSURLConnectionDelegate'],
	methods_to_match = ['connection:willSendRequest:redirectResponse:'],
	args_to_match = [
            (['arguments', 'request', 'URL', 'scheme'], "https"),
            (['returnValue', 'URL', 'scheme'], 'http')])))

# CCCrypt signatures
signature_list.append(Signature(
    title = 'Null Initialization Vector',
    description = 'An encryption routine used a null initialization vector',
    severity = Signature.SEVERITY_MEDIUM,
    filter = ArgumentsFilter(
        classes_to_match = ['C'],
        methods_to_match = ['CCCryptorCreate', 'CCCrypt', 'CCCryptorCreateFromData'],
        args_to_match = [(['arguments', 'iv'], None)])))

# LibC signatures
signature_list.append(Signature(
    title = 'Weak PRNG',
    description = 'The application uses a weak random number generator',
    severity = Signature.SEVERITY_MEDIUM,
    filter = MethodsFilter(
        classes_to_match = ['C'],
        methods_to_match = ['rand', 'random'])))

