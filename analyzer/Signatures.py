
from FilterResults import FilterResults

# Global list of signatures
signature_list = []

class Signature(object):
	"""
	Abstract Signature class for inheritence.

	A signature takes a list of classes and methods 
	that should be checked with check_signature().
	"""

	def __init__(self, sig_dict):
		self.sclass = sig_dict['sig_class']
		self.key = sig_dict['key']
		self.severity = sig_dict['severity']
		self.desc = sig_dict['desc']
		self.clazz_list = sig_dict['clazz_list']
		self.method_list = sig_dict['method_list']
		self.attr = sig_dict['attr']
		self.val = sig_dict['val']

	def check_signature(self, trace):
		vulnerable_calls = []
		for call in trace:
			if call.clazz in self.clazz_list:
				if call.method in self.method_list:
					if (self.signature_match(call)):
						vulnerable_calls.append(call)

		return FilterResults(self.sclass, self.severity, self.desc, vulnerable_calls)

	def signature_match(self, call):
		return NotImplemented

	def __str__(self):
		return self.desc


class NoAttrSignature(Signature):
	"""Signature based purely on the existence of a call"""

	def __init__(self, sig_dict):
		super(NoAttrSignature, self).__init__(sig_dict)

	def signature_match(self, call):
		return True


class SingleAttrSignature(Signature):
	"""Signature based on a single attribute within a given call"""

	def __init__(self, sig_dict):
		super(SingleAttrSignature, self).__init__(sig_dict)

	def signature_match(self, call):
		attribute = call.args
		for attr in self.attr:
			try:
				attribute = attribute[attr]
			except KeyError, e:
				return False
		if str(attribute) == str(self.val[0]):
			return True
		return False


class MultiAttrRVSignature(Signature):
	"""Signature based on multiple attributes within the call's return value"""

	def __init__(self, sig_dict):
		super(MultiAttrRVSignature, self).__init__(sig_dict)

	def signature_match(self, call):
		vals = self.val
		for sig in self.attr:
			attribute = call.return_value
			val, vals = vals[0], vals[1:]
			for attr in sig:
				try:
					attribute = attribute[attr]
				except KeyError, e:
					return False
			if str(attribute) != str(val):
				return False
		return True


# TODO: Split the signatures in different files ?

SEVERITY_INF = 'Informational'
SEVERITY_LOW = 'Low'
SEVERITY_MEDIUM = 'Medium'
SEVERITY_HIGH = 'High'

# XML signature
signature_list.append({'sig_class' :'XML',
			'key' :'XML',
			'severity' :SEVERITY_HIGH,
			'desc' :'XML parser is configured to resolve external entities.',
			'clazz_list' :['NSXMLParser'],
			'method_list' :['setShouldResolveExternalEntities:'],
			'attr' : ['shouldResolveExternalEntities'],
			'val' : ['True']})

# Security Framework signatures
signature_list.append({'sig_class' :'Security',
			'key' :'Client certificate',
			'severity' :SEVERITY_INF,
			'desc' :'The application imported a private key and a certificate from a PKCS12 file.',
			'clazz_list' :['C'],
			'method_list' :['SecPKCS12Import'],
			'attr' : None,
			'val' : None})

# KeyChain signatures


signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleWhenUnlocked',
			'severity' :SEVERITY_INF,
			'desc' :'Item added to KeyChain with accessibility options (kSecAttrAccessibleWhenUnlocked)',
			'clazz_list' :['C'],
			'method_list' :['SecItemAdd'],
			'attr' : ['attributes', 'pdmn'],
			'val' : ['ak']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleAlways',
			'severity' :SEVERITY_MEDIUM,
			'desc' :'Item added to KeyChain with weak accessibility options (kSecAttrAccessibleAlways)',
			'clazz_list' :['C'],
			'method_list' :['SecItemAdd'],
			'attr' : ['attributes', 'pdmn'],
			'val' : ['dk']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleAlwaysThisDeviceOnly',
			'severity' :SEVERITY_MEDIUM,
			'desc' :'Item added to KeyChain with weak accessibility options (kSecAttrAccessibleAlwaysThisDeviceOnly)',
			'clazz_list' :['C'],
			'method_list' :['SecItemAdd'],
			'attr' : ['attributes', 'pdmn'],
			'val' : ['dku']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleAfterFirstUnlock',
			'severity' :SEVERITY_LOW,
			'desc' :'Item added to KeyChain with weak accessibility options (kSecAttrAccessibleAfterFirstUnlock)',
			'clazz_list' :['C'],
			'method_list' :['SecItemAdd'],
			'attr' : ['attributes', 'pdmn'],
			'val' : ['ck']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly',
			'severity' :SEVERITY_LOW,
			'desc' :'Item added to KeyChain with weak accessibility options (kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)',
			'clazz_list' :['C'],
			'method_list' :['SecItemAdd'],
			'attr' : ['attributes', 'pdmn'],
			'val' : ['cku']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleWhenUnlockedThisDeviceOnly',
			'severity' :SEVERITY_INF,
			'desc' :'Item added to KeyChain with accessibility options (kSecAttrAccessibleWhenUnlockedThisDeviceOnly)',
			'clazz_list' :['C'],
			'method_list' :['SecItemAdd'],
			'attr' : ['attributes', 'pdmn'],
			'val' : ['aku']})

# FileSystem signatures
signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionNone',
			'severity' :SEVERITY_HIGH,
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionNone)',
			'clazz_list' :['NSData'],
			'method_list' :['writeToFile:options:error:', 'writeToURL:options:error:'],
			'attr' : ['mask'],
			'val' : [268435456]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionCompleteUnlessOpen',
			'severity' :SEVERITY_MEDIUM,
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionCompleteUnlessOpen)',
			'clazz_list' :['NSData'],
			'method_list' :['writeToFile:options:error:', 'writeToURL:options:error:'],
			'attr' : ['mask'],
			'val' : [805306368]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication',
			'severity' :SEVERITY_MEDIUM,
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication)',
			'clazz_list' :['NSData'],
			'method_list' :['writeToFile:options:error:', 'writeToURL:options:error:'],
			'attr' : ['mask'],
			'val' : [1073741824]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionComplete',
			'severity' :SEVERITY_INF,
			'desc' :'File written with strong data protection options (NSDataWritingFileProtectionComplete)',
			'clazz_list' :['NSData'],
			'method_list' :['writeToFile:options:error:', 'writeToURL:options:error:'],
			'attr' : ['mask'],
			'val' : [536870912]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataNoWritingOptionsAtomically',
			'severity' :SEVERITY_HIGH,
			'desc' :'File written without any data protection options',
			'clazz_list' :['NSData'],
			'method_list' :['writeToFile:atomically:', 'writeToURL:atomically:'],
			'attr' : None,
			'val' : None})


# URL scheme signatures
signature_list.append({'sig_class' :'Schemes',
			'key' :'URLschemes',
			'severity' :SEVERITY_INF,
			'desc' :'Specific URL schemes implemented by the application',
			'clazz_list' :'CFBundleURLTypes',
			'method_list' :'CFBundleURLSchemes',
			'attr' : None,
			'val' : None})

# HTTP signatures
signature_list.append({'sig_class' :'HTTP',
			'key' :'CachePolicy',
			'severity' :SEVERITY_HIGH,
			'desc' :'Data received over HTTPS is being cached on disk',
			'clazz_list' :'NSURLConnectionDelegate',
			'method_list' :'connection:willCacheResponse:',
			'attr' : [['returnValue','response','URL','scheme'],['returnValue','storagePolicy']],
			'val' : ['https',0]})

# Pasteboard signatures
signature_list.append({'sig_class' :'Pasteboard',
			'key' :'generalPasteboard',
			'severity' :SEVERITY_INF,
			'desc' :'Application instantiates the shared generalPasteboard',
			'clazz_list' :'UIPasteboard',
			'method_list' :'generalPasteboard',
			'attr' : None,
			'val' : None})

