from Filters import MethodsFilter, ArgumentsWithMaskFilter, ArgumentsFilter


class Signature(object):
	"""
	A Signature contains some metadata (name, description, etc.) plus a filter 
	that defines which calls the signature is going to match.
	"""

	SEVERITY_INF = 'Informational'
	SEVERITY_LOW = 'Low'
	SEVERITY_MEDIUM = 'Medium'
	SEVERITY_HIGH = 'High'


	def __init__(self, name, group, description, severity, filter):
		# TODO: Define the metadata we actually need 
		self.name = name
		self.group = group
		self.description = description
		self.severity = severity
		self.filter = filter


	def analyze_trace(self, trace):
		matching_calls = []
		for call in self.filter.find_matching_calls(trace):
			matching_calls.append(call)
		return matching_calls


# Global list of signatures
signature_list = []

# XML signature
signature_list.append(Signature(
	name = 'XML', 
	group = '',
	description = 'XML parser is configured to resolve external entities.',
	severity = Signature.SEVERITY_HIGH,
	filter = ArgumentsFilter(
		classes_to_match = ['NSXMLParser'],
		methods_to_match = ['setShouldResolveExternalEntities:'],
		args_to_match = [
			(['arguments', 'shouldResolveExternalEntities'], 'True')])))


# Security Framework signatures
signature_list.append(Signature(
	name = 'Client Certificate', 
	group = 'SecurityFramework',
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

for (kSecAttr_value, kSecAttr_name, severity) in KSECATTR_VALUES:
	signature_list.append(Signature(
		name = 'KeyChain', 
		group = 'KeyChain',
		description = 'Item added to KeyChain with accessibility options {0}.'.format(kSecAttr_name),
		severity = severity,
		filter = ArgumentsFilter(
			classes_to_match = ['C'],
			methods_to_match = ['SecItemAdd'],
			args_to_match = [
				(['arguments', 'attributes', 'pdmn'], kSecAttr_value)])))


# URL scheme signatures
signature_list.append(Signature(
	name = 'URLschemes', 
	group = '',
	description = 'Specific URL schemes implemented by the application.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['CFBundleURLTypes'],
		methods_to_match = ['CFBundleURLSchemes:'])))


# Pasteboard signatures
signature_list.append(Signature(
	name = 'generalPasteboard', 
	group = 'Pasteboard',
	description = 'Application instantiates the shared generalPasteboard.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['UIPasteboard'],
		methods_to_match = ['generalPasteboard:'])))


# HTTP signatures
signature_list.append(Signature(
	name = 'CachePolicy', 
	group = 'HTTP',
	description = 'Data received over HTTPS is being cached on disk',
	severity = Signature.SEVERITY_MEDIUM,
	filter = ArgumentsFilter(
		classes_to_match = ['NSURLConnectionDelegate'],
		methods_to_match = ['connection:willCacheResponse:'],
		args_to_match = [
			(['returnValue', 'response', 'URL', 'scheme'], 'https'),
			(['returnValue', 'storagePolicy'], 0) ])))


# Filesystem signatures
FILEPROTECTION_VALUES = {
	(0x10000000, 'NSDataWritingFileProtectionNone', Signature.SEVERITY_HIGH),
	(0x20000000, 'NSDataWritingFileProtectionComplete', Signature.SEVERITY_INF),
	(0x30000000, 'NSDataWritingFileProtectionCompleteUnlessOpen', Signature.SEVERITY_INF),
	(0x40000000, 'NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication', Signature.SEVERITY_INF)}


for (fileProt_value, fileProt_name, severity) in FILEPROTECTION_VALUES:
	signature_list.append(Signature(
		name = 'NSDataWritingFileProtection', 
		group = 'FileSystem',
		description = 'File written with data protection options {0}'.format(fileProt_name),
		severity = severity,
		filter = ArgumentsWithMaskFilter(
			classes_to_match = ['NSData'],
			methods_to_match = ['writeToFile:options:error:', 'writeToURL:options:error:'],
			args_to_match = [
				(['arguments', 'mask'], fileProt_value)],
			value_mask = 0xf0000000)))


signature_list.append(Signature(
	name = 'NSDataWritingFileProtection', 
	group = 'FileSystem',
	description = 'File written without any data protection options.',
	severity = severity,
	filter = MethodsFilter(
		classes_to_match = ['NSData'],
		methods_to_match = ['writeToFile:atomically:', 'writeToURL:atomically:'])))	


# Crypto
signature_list.append(Signature(
	name = 'CCCrypt', 
	group = 'Crypto',
	description = 'The application used crypto APIs.',
	severity = Signature.SEVERITY_INF,
	filter = MethodsFilter(
		classes_to_match = ['C'],
		methods_to_match = ['CCCryptorCreate', 'CCCryptorCreateFromData', 'CCCryptorUpdate', 'CCCryptorFinal', 'CCCrypt' ])))
