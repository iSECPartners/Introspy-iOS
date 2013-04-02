from Filters import MethodsFilter, ArgumentsFilter
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

# XML signature
signature_list.append(Signature(
	title = 'Vulnerable XML Parser',
	description = 'XML parser is configured to resolve external entities.',
	severity = Signature.SEVERITY_HIGH,
	filter = ArgumentsFilter(
		classes_to_match = ['NSXMLParser'],
		methods_to_match = ['setShouldResolveExternalEntities:'],
		args_to_match = [
			(['arguments', 'shouldResolveExternalEntities'], 'True')])))

# NSUserDefault signatures
signature_list.append(Signature(
	title = 'Data stored to user defaults',
	description = 'Data was stored in the application\'s user defaults.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['NSUserDefaults'],
		methods_to_match = ['setBool:forKey:',
			'setFloat:forKey:',
			'setInteger:forKey:',
			'setURL:forKey:',
			'setDouble:forKey:'])))

signature_list.append(Signature(
	title = 'Data accessed from user defaults',
	description = 'Data was accessed from the application\'s user defaults.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['NSUserDefaults'],
		methods_to_match = ['arrayForKey:',
			'boolForKey:',
			'dataForKey:',
			'dictionaryForKey:',
			'floatForKey:',
			'doubleForKey:',
			'integerForKey:',
			'stringArrayForKey:',
			'stringForKey:',
			'URLForKey:,',
			'dictionaryRepresentation'])))

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
	('ak', 'kSecAttrAccessibleWhenUnlocked', Signature.SEVERITY_INF),
	('aku', 'kSecAttrAccessibleWhenUnlockedThisDeviceOnly', Signature.SEVERITY_INF),
	('dk', 'kSecAttrAccessibleAlways', Signature.SEVERITY_HIGH),
	('dku', 'kSecAttrAccessibleAlwaysThisDeviceOnly', Signature.SEVERITY_HIGH),
	('ck', 'kSecAttrAccessibleAfterFirstUnlock', Signature.SEVERITY_MEDIUM),
	('cku', 'kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly', Signature.SEVERITY_MEDIUM)
]

for (kSecAttr_value, kSecAttr_title, severity) in KSECATTR_VALUES:
	signature_list.append(Signature(
		title = 'Keychain Data Protection',
		description = 'Item added to the KeyChain with accessibility options "{0}".'.format(kSecAttr_title),
		severity = severity,
		filter = ArgumentsFilter(
			classes_to_match = ['C'],
			methods_to_match = ['SecItemAdd'],
			args_to_match = [
				(['arguments', 'attributes', 'pdmn'], kSecAttr_value)])))

# Pasteboard signatures
signature_list.append(Signature(
    title = 'Pasteboard Usage',
    description = 'Application instantiates one or multiple Pasteboards.',
    severity = Signature.SEVERITY_INF,
    filter = MethodsFilter(
        classes_to_match = ['UIPasteboard'],
        methods_to_match = ['generalPasteboard', 'pasteboardWithName:create:'])))

# HTTP signatures
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
	title = 'NSURLConnection',
	description = 'Remote connection.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['NSURLConnection'],
		methods_to_match = ['initWithRequest:delegate:',
		'sendSynchronousRequest:returningResponse:error:',
		'initWithRequest:delegate:',
		'initWithRequest:delegate:startImmediately:'])))

signature_list.append(Signature(
	title = 'Remote connection with credentials.',
	description = 'The application is authenticating to remote resources.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['NSURLCredential'],
		methods_to_match = ['initWithUser:password:persistence:',
			'initWithTrust:'])))

signature_list.append(Signature(
	title = 'Cookie usage',
	description = 'The application instantiated the following cookies.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['NSHTTPCookie'],
		methods_to_match = ['initWithProperties:'])))

# Filesystem signatures
# For NSData
NSDATA_DPAPI_VALUES = {
	(0x10000000, 'NSDataWritingFileProtectionNone', Signature.SEVERITY_HIGH),
	(0x20000000, 'NSDataWritingFileProtectionComplete', Signature.SEVERITY_INF),
	(0x30000000, 'NSDataWritingFileProtectionCompleteUnlessOpen', Signature.SEVERITY_INF),
	(0x40000000, 'NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication', Signature.SEVERITY_INF)}

for (fileProt_mask, fileProt_title, severity) in NSDATA_DPAPI_VALUES:
	signature_list.append(Signature(
		title = 'Data Protection APIs Usage',
		description = 'File written with data protection option "{0}".'.format(fileProt_title),
		severity = severity,
		filter = ArgumentsFilter(
			classes_to_match = ['NSData'],
			methods_to_match = ['writeToFile:options:error:', 'writeToURL:options:error:'],
			args_to_match = [
				(['arguments', 'mask'], fileProt_mask)],
			value_mask = 0xf0000000)))


signature_list.append(Signature(
	title = 'Lack of Data Protection APIs Usage',
	description = 'File written without any data protection options.',
	severity = severity,
	filter = MethodsFilter(
		classes_to_match = ['NSData'],
		methods_to_match = ['writeToFile:atomically:', 'writeToURL:atomically:'])))	

signature_list.append(Signature(
	title = 'File system access.',
	description = 'File system access',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['NSData'],
		methods_to_match = ['dataWithContentsOfFile:',
			'dataWithContentsOfFile:options:error:',
			'dataWithContentsOfURL',
			'dataWithContentsOfURL:options:error:',
			'initWithContentsOfFile:',
			'initWithContentsOfFile:options:error:',
			'initWithContentsOfURL:',
			'initWithContentsOfURL:options:error:'])))


# For NSFileManager
NSFILEMANAGER_DPAPI_VALUES = {
	('NSFileProtectionNone', Signature.SEVERITY_HIGH),
	('NSFileProtectionComplete', Signature.SEVERITY_INF),
	('NSFileProtectionCompleteUnlessOpen', Signature.SEVERITY_INF),
	('NSFileProtectionCompleteUntilFirstUserAuthentication', Signature.SEVERITY_INF)}

for (fileProt_title, severity) in NSFILEMANAGER_DPAPI_VALUES:
	signature_list.append(Signature(
		title = 'Data Protection APIs Usage',
		description = 'File written with data protection option "{0}".'.format(fileProt_title),
		severity = severity,
		filter = ArgumentsFilter(
			classes_to_match = ['NSFileManager'],
			methods_to_match = ['createFileAtPath:contents:attributes:'],
			args_to_match = [
				(['arguments', 'attributes', 'NSFileProtectionKey'], fileProt_title)])))

signature_list.append(Signature(
	title = 'File system access.',
	description = 'File system access',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['NSFileManager'],
		methods_to_match = ['contentsAtPath:'])))

# URL scheme signatures
signature_list.append(Signature(
	title = 'URL Schemes',
	description = 'Specific URL schemes are implemented by the application.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['CFBundleURLTypes'],
		methods_to_match = ['CFBundleURLSchemes'])))

# UIApplicationDelegate hooks
signature_list.append(Signature(
	title = 'Custom URL scheme accessed.',
	description = 'Custom URL scheme accessed.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['UIApplicationDelegate'],
		methods_to_match = ['application:openURL:sourceApplication:annotation:', 'application:handleOpenURL:'])))

