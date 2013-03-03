
# Global list of signatures
signature_list = []

class Signature(object):
	""" Abstract Signature class for inheritence"""

	def __init__(self, sig_dict):
		self.sclass = sig_dict['sig_class']
		self.key = sig_dict['key']
		self.severity = sig_dict['severity']
		self.desc = sig_dict['desc']
		self.clazz = sig_dict['clazz']
		self.method = sig_dict['method']
		self.attr = sig_dict['attr']
		self.val = sig_dict['val']

	def check_signature(self, trace):
		vulnerable_calls = []
		for call in trace:
			if call.clazz == self.clazz and \
			   call.method == self.method:
				if (self.signature_match(call)):
					call.sig_match = self
					vulnerable_calls.append(call)
		return (self.key, vulnerable_calls)

	def siganture_match(self, call):
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


# Security Framework signatures
signature_list.append({'sig_class' :'Security',
			'key' :'Client certificate',
			'severity' :'Informational',
			'desc' :'The application imported a private key and a certificate from a PKCS12 file.',
			'clazz' :'C',
			'method' :'SecPKCS12Import',
			'attr' : None,
			'val' : None})

# KeyChain signatures
signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleWhenUnlocked',
			'severity' :'Informational',
			'desc' :'Item added to KeyChain with accessibility options (kSecAttrAccessibleWhenUnlocked)',
			'clazz' :'C',
			'method' :'SecItemAdd',
			'attr' : ['attributes', 'pdmn'],
			'val' : ['ak']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleAlways',
			'severity' :'Medium',
			'desc' :'Item added to KeyChain with weak accessibility options (kSecAttrAccessibleAlways)',
			'clazz' :'C',
			'method' :'SecItemAdd',
			'attr' : ['attributes', 'pdmn'],
			'val' : ['dk']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleAlwaysThisDeviceOnly',
			'severity' :'Medium',
			'desc' :'Item added to KeyChain with weak accessibility options (kSecAttrAccessibleAlwaysThisDeviceOnly)',
			'clazz' :'C',
			'method' :'SecItemAdd',
			'attr' : ['attributes', 'pdmn'],
			'val' : ['dku']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleAfterFirstUnlock',
			'severity' :'Low',
			'desc' :'Item added to KeyChain with weak accessibility options (kSecAttrAccessibleAfterFirstUnlock)',
			'clazz' :'C',
			'method' :'SecItemAdd',
			'attr' : ['attributes', 'pdmn'],
			'val' : ['ck']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly',
			'severity' :'Low',
			'desc' :'Item added to KeyChain with weak accessibility options (kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)',
			'clazz' :'C',
			'method' :'SecItemAdd',
			'attr' : ['attributes', 'pdmn'],
			'val' : ['cku']})

signature_list.append({'sig_class' :'KeyChain',
			'key' :'kSecAttrAccessibleWhenUnlockedThisDeviceOnly',
			'severity' :'Informational',
			'desc' :'Item added to KeyChain with accessibility options (kSecAttrAccessibleWhenUnlockedThisDeviceOnly)',
			'clazz' :'C',
			'method' :'SecItemAdd',
			'attr' : ['attributes', 'pdmn'],
			'val' : ['aku']})

# FileSystem signatures
signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionNone',
			'severity' :'High',
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionNone)',
			'clazz' :'NSData',
			'method' :'writeToFile:options:error:',
			'attr' : ['mask'],
			'val' : [268435456]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionCompleteUnlessOpen',
			'severity' :'Medium',
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionCompleteUnlessOpen)',
			'clazz' :'NSData',
			'method' :'writeToFile:options:error:',
			'attr' : ['mask'],
			'val' : [805306368]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication',
			'severity' :'Medium',
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication)',
			'clazz' :'NSData',
			'method' :'writeToFile:options:error:',
			'attr' : ['mask'],
			'val' : [1073741824]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionComplete',
			'severity' :'Informational',
			'desc' :'File written with strong data protection options (NSDataWritingFileProtectionComplete)',
			'clazz' :'NSData',
			'method' :'writeToFile:options:error:',
			'attr' : ['mask'],
			'val' : [536870912]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataNoWritingOptionsAtomically',
			'severity' :'High',
			'desc' :'File written without any data protection options',
			'clazz' :'NSData',
			'method' :'writeToFile:atomically:',
			'attr' : None,
			'val' : None})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataNoWritingOptionsAtomically',
			'severity' :'High',
			'desc' :'File written without any data protection options',
			'clazz' :'NSData',
			'method' :'writeToURL:atomically:',
			'attr' : None,
			'val' : None})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionNone',
			'severity' :'High',
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionNone)',
			'clazz' :'NSData',
			'method' :'writeToURL:options:error:',
			'attr' : ['mask'],
			'val' : [268435456]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionCompleteUnlessOpen',
			'severity' :'Medium',
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionCompleteUnlessOpen)',
			'clazz' :'NSData',
			'method' :'writeToURL:options:error:',
			'attr' : ['mask'],
			'val' : [805306368]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication',
			'severity' :'Medium',
			'desc' :'File written with insufficient data protection options (NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication)',
			'clazz' :'NSData',
			'method' :'writeToURL:options:error:',
			'attr' : ['mask'],
			'val' : [1073741824]})

signature_list.append({'sig_class' :'FileSystem',
			'key' :'NSDataWritingFileProtectionComplete',
			'severity' :'Informational',
			'desc' :'File written with strong data protection options (NSDataWritingFileProtectionComplete)',
			'clazz' :'NSData',
			'method' :'writeToURL:options:error:',
			'attr' : ['mask'],
			'val' : [536870912]})

# URL scheme signatures
signature_list.append({'sig_class' :'Schemes',
			'key' :'URLschemes',
			'severity' :'Informational',
			'desc' :'Specific URL schemes implemented by the application',
			'clazz' :'CFBundleURLTypes',
			'method' :'CFBundleURLSchemes',
			'attr' : None,
			'val' : None})

# HTTP signatures
signature_list.append({'sig_class' :'HTTP',
			'key' :'CachePolicy',
			'severity' :'High',
			'desc' :'Data received over HTTPS is being cached on disk',
			'clazz' :'NSURLConnectionDelegate',
			'method' :'connection:willCacheResponse:',
			'attr' : [['returnValue','response','URL','scheme'],['returnValue','storagePolicy']],
			'val' : ['https',0]})
# Pasteboard signatures
signature_list.append({'sig_class' :'Pasteboard',
			'key' :'generalPasteboard',
			'severity' :'Informational',
			'desc' :'Application instantiates the shared generalPasteboard',
			'clazz' :'UIPasteboard',
			'method' :'generalPasteboard',
			'attr' : None,
			'val' : None})

