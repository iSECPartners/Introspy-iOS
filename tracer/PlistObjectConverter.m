#import <objc/runtime.h> // For convertDelegate()

#import "PlistObjectConverter.h"




@implementation PlistObjectConverter


// What we store in the plist if the object's pointer is nil
static NSString *serializedNilValue = @"nil";


+ (NSString *) getSerializedNilValue {
	return serializedNilValue;
}


// Utility function to automatically convert nil to an empty string
+ (id) autoConvertNil:(id) pointer {
	if (pointer == nil) {
		return serializedNilValue;
	}
	else {
		return pointer;
	}
}


+ (NSDictionary *) convertURL:(NSURL *)aURL {
	if (aURL == nil) {
		return [NSDictionary dictionary];
	}

	NSDictionary *url_dict = nil;
	NSString *scheme = [aURL scheme];
	if (aURL != nil) {
		// store specific infoz if its an HTTP URL
		if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
		  	url_dict = [NSDictionary dictionaryWithObjects:
				   		[NSArray arrayWithObjects: [aURL absoluteString],
		 			      	[aURL scheme],
					      	[aURL host],
					      	[PlistObjectConverter autoConvertNil: [aURL port]],
					      	[aURL path],
							[PlistObjectConverter autoConvertNil: [aURL parameterString]],
					      	[PlistObjectConverter autoConvertNil: [aURL query]], nil]
			      	   	forKeys:
					    [NSArray arrayWithObjects:
				    	    @"absoluteString",
  						    @"scheme",
					      	@"host",
							@"port",
					    	@"path",
							@"parameterString",
					      	@"query", nil]];
		// otherwise just store the whole string for now.
		} else {
		  url_dict = [NSDictionary dictionaryWithObjects:
					      [NSArray arrayWithObjects: 
					      		[aURL absoluteString], nil]
					   forKeys:
					      [NSArray arrayWithObjects:
					      		@"absoluteString", nil]]; 
		}
	}
	return url_dict;
}


// Convert an NSURLRequest to an NSDictionary suitable for plist storage.
+ (NSDictionary *) convertNSURLRequest:(NSURLRequest *)request {
	if (request == nil)
		return [NSDictionary dictionary];
	
	NSDictionary *url_req = [NSDictionary dictionaryWithObjects:
				[NSArray arrayWithObjects:
					 		[PlistObjectConverter convertURL:[request URL]],
							[request HTTPMethod],
							[PlistObjectConverter autoConvertNil: [request HTTPBody]],
					     	[NSNumber numberWithUnsignedInt:[request cachePolicy]], 
					     	nil]
						forKeys: [NSArray arrayWithObjects:
							@"URL",
							@"HTTPMethod",
							@"HTTPBody",
							@"cachePolicy",
							nil]];
	return url_req;
}


+ (NSDictionary *) convertNSURLResponse:(NSURLResponse *)response {
	if (response == nil)
		return [NSDictionary dictionary];

	NSDictionary *responseDict = [NSDictionary dictionaryWithObjects:
		[NSArray arrayWithObjects:
			 		[PlistObjectConverter convertURL:[response URL]],
					[PlistObjectConverter autoConvertNil: [response MIMEType]],
					[response suggestedFilename],
					[PlistObjectConverter autoConvertNil: [response textEncodingName]],
			     	nil]
				forKeys: [NSArray arrayWithObjects:
					@"URL",
					@"MIMEType",
					@"suggestedFilename",
					@"textEncodingName",
					nil]];
	return responseDict;
}


+ (NSDictionary *) convertNSCachedURLResponse:(NSCachedURLResponse *)response {
	if (response == nil)
		return [NSDictionary dictionary];

	// Do we want to store the actual data ?
	NSDictionary *responseDict = [NSDictionary dictionaryWithObjects:
		[NSArray arrayWithObjects:
			 		[PlistObjectConverter convertNSURLResponse:[response response]],
					[NSNumber numberWithUnsignedInt:[response storagePolicy]],
					[PlistObjectConverter autoConvertNil:[response userInfo]],
			     	nil]
				forKeys: [NSArray arrayWithObjects:
					@"response",
					@"storagePolicy",
					@"userInfo",
					nil]];
	return responseDict;
}


+ (NSDictionary *) convertNSURLProtectionSpace:(NSURLProtectionSpace *)pSpace {
	if (pSpace == nil) {
		return [NSDictionary dictionary];
	}

	NSDictionary *pSpaceDict = [NSDictionary dictionaryWithObjects:
									[NSArray arrayWithObjects:
										[pSpace authenticationMethod],
										[PlistObjectConverter autoConvertNil: [pSpace distinguishedNames]],
										[pSpace host],
										[NSNumber numberWithBool: [pSpace isProxy]],
										[NSNumber numberWithUnsignedInt: [pSpace port]],
										[PlistObjectConverter autoConvertNil: [pSpace protocol]],
										[PlistObjectConverter autoConvertNil: [pSpace proxyType]],
										[PlistObjectConverter autoConvertNil: [pSpace realm]],
										[NSNumber numberWithBool: [pSpace receivesCredentialSecurely]],
										[PlistObjectConverter convertSecTrustRef: [pSpace serverTrust]],
										nil]
									forKeys:
										[NSArray arrayWithObjects:
											@"authenticationMethod",
											@"distinguishedNames",
											@"host",
											@"isProxy",
											@"port",
											@"protocol",
											@"proxyType",
											@"realm",
											@"receivesCredentialSecurely",
											@"serverTrust",
											nil]];
	return pSpaceDict;
}


// Convert an NSURLAuthenticationChallenge to an NSDictionary suitable for plist storage
+ (NSDictionary *) convertNSURLAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

	if (challenge == nil) {
		return [NSDictionary dictionary];
	}

	// Parse the protection space
	NSURLProtectionSpace *pSpace = [challenge protectionSpace];
	NSDictionary *pSpaceDict = [PlistObjectConverter convertNSURLProtectionSpace:pSpace];


	// Parse the proposed credential
	NSURLCredential *cred = [challenge proposedCredential];
	NSDictionary *credentialDict = [PlistObjectConverter convertNSURLCredential:cred];

	// All done
	NSDictionary *challengeDict = [NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:
						pSpaceDict,
						credentialDict, nil]
					forKeys:
						[NSArray arrayWithObjects:
						@"protectionSpace",
						@"proposedCredential", nil]];

	return challengeDict;
}


+ (NSDictionary *) convertSecCertificateRef: (SecCertificateRef) certificate {
	if (certificate == nil)
		return [NSDictionary dictionary];

	// Just store the summary of the certificate
	NSString *certSummary = (NSString *)SecCertificateCopySubjectSummary(certificate);
	NSDictionary *credentialDict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:
			certSummary,
			nil]
	  	forKeys:
	    	[NSArray arrayWithObjects:
			@"subjectSummary",
			nil]];

	return credentialDict;
}


// attributes dictionnary when calling SecItemAdd() and SecItemUpdate()
+ (NSDictionary *) convertSecItemAttributesDict: (CFDictionaryRef) attributes {

    // Need to make the content of attributes serializable
    NSMutableDictionary *attributesPlist = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*) attributes];

    CFTypeRef secClass = CFDictionaryGetValue(attributes, kSecClass);
    if ((secClass == kSecClassGenericPassword) || (secClass == kSecClassGenericPassword)) {
        // Nothing to do for passwords
    }
    else if (secClass == kSecClassCertificate) {
        if (CFDictionaryContainsKey(attributes, kSecValueRef)) {
            [attributesPlist setObject:[PlistObjectConverter convertSecCertificateRef:(SecCertificateRef)CFDictionaryGetValue(attributes, kSecValueRef)] 
                                forKey:(id)kSecValueRef];
        }
        else if (CFDictionaryContainsKey(attributes, kSecValuePersistentRef)) {
            [attributesPlist setObject:[PlistObjectConverter convertSecCertificateRef:(SecCertificateRef)CFDictionaryGetValue(attributes, kSecValuePersistentRef)] 
                                forKey:(id)kSecValuePersistentRef];
        }
    }
    else if (secClass == kSecClassIdentity) {
        if (CFDictionaryContainsKey(attributes, kSecValueRef)) {
            SecIdentityRef identity;
            identity = (SecIdentityRef)CFDictionaryGetValue(attributes, kSecValueRef);
            [attributesPlist setObject:[PlistObjectConverter convertSecIdentityRef:(SecIdentityRef)CFDictionaryGetValue(attributes, kSecValueRef)] 
                                forKey:(id)kSecValueRef];
        }
        else if (CFDictionaryContainsKey(attributes, kSecValuePersistentRef)) {
            [attributesPlist setObject:[PlistObjectConverter convertSecIdentityRef:(SecIdentityRef)CFDictionaryGetValue(attributes, kSecValuePersistentRef)] 
                                forKey:(id)kSecValuePersistentRef];
        }
    }
    else if (secClass == kSecClassKey) {
        if (CFDictionaryContainsKey(attributes, kSecValueRef)) {
            [attributesPlist setObject:[PlistObjectConverter convertSecKeyRef:(SecKeyRef)CFDictionaryGetValue(attributes, kSecValueRef)] 
                                forKey:(id)kSecValueRef];
        }
        else if (CFDictionaryContainsKey(attributes, kSecValuePersistentRef)) {
            [attributesPlist setObject:[PlistObjectConverter convertSecKeyRef:(SecKeyRef)CFDictionaryGetValue(attributes, kSecValuePersistentRef)] 
                                forKey:(id)kSecValuePersistentRef];
        }
    }

    return attributesPlist;
}


+ (NSDictionary *) convertSecIdentityRef: (SecIdentityRef) identity {
	if (identity == nil)
		return [NSDictionary dictionary];

	// TODO: Dump the client cert and private key
    SecCertificateRef certRef;
	SecIdentityCopyCertificate(identity, &certRef);
   	SecKeyRef privateKeyRef;
	SecIdentityCopyPrivateKey(identity, &privateKeyRef);

	NSDictionary *identityDict = [NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:
						[PlistObjectConverter convertSecCertificateRef:certRef],
						[PlistObjectConverter convertSecKeyRef:privateKeyRef], 
						nil]
			      	forKeys:
				    	[NSArray arrayWithObjects:
						@"certificate",
				    	@"privateKey",
						nil]];

	if (certRef)
		CFRelease(certRef);
	return identityDict;
}


+ (NSDictionary *) convertSecKeyRef:(SecKeyRef) key {
	if (key == nil)
		return [NSDictionary dictionary];

	// TODO: Dump private keys
	NSDictionary *keyDict = [NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:
						[NSNumber numberWithUnsignedInt: (unsigned int)key], 
						nil]
			      	forKeys:
				    	[NSArray arrayWithObjects:
				    	@"key",
						nil]];
	return keyDict;
}


+ (NSDictionary *) convertSecTrustRef:(SecTrustRef) trust {
	if (trust == nil)
		return [NSDictionary dictionary];

	// This is getting complicated...
	// Just store the summary of the each certificate for now
	unsigned int certNB = SecTrustGetCertificateCount(trust);
	NSMutableDictionary *trustDict = [NSMutableDictionary dictionaryWithCapacity:certNB];
	for(int i=0; i<certNB; i++) {
		SecCertificateRef certificate = SecTrustGetCertificateAtIndex(trust, i);
		[trustDict setValue:[PlistObjectConverter convertSecCertificateRef: certificate] forKey:[NSString stringWithFormat:@"cert %d", i]];
	}
	return trustDict;
}


+ (NSDictionary *) convertNSURLCredential: (NSURLCredential*) credential {
	if (credential == nil)
		return [NSDictionary dictionary];

	// Parse the array of certificates
	NSArray *certificates = [credential certificates];
	NSMutableArray *certsSummary = [NSMutableArray array]; // array of NSString
	if (certificates != nil) {

		for(id cert in certificates)
			{
				[certsSummary addObject:[PlistObjectConverter convertSecCertificateRef:(SecCertificateRef)cert]];
			}
	}

	NSDictionary *credentialDict = nil;
	// TODO: store [cred identity] to extract the cert and private key for client auth
	credentialDict = [NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:
						[PlistObjectConverter autoConvertNil: [credential user]],
						[PlistObjectConverter autoConvertNil: [credential password]],
						certsSummary,
						[NSNumber numberWithUnsignedInt: (unsigned int)[credential identity]],
						[NSNumber numberWithUnsignedInt: [credential persistence]], 
						nil]
			      	forKeys:
				    	[NSArray arrayWithObjects:
						@"user",
				    	@"password",
				    	@"certificates",
				    	@"identity",
						@"persistence", 
						nil]];
	return credentialDict;
}


+ (NSDictionary *) convertNSHTTPCookie: (NSHTTPCookie*) cookie {
	if (cookie == nil) {
		return [NSDictionary dictionary];
	}

	NSDictionary *cookieDict;
	cookieDict = [NSDictionary dictionaryWithObjects:
					[NSArray arrayWithObjects:
						[PlistObjectConverter autoConvertNil: [cookie comment]],
						[PlistObjectConverter autoConvertNil: [PlistObjectConverter convertURL: [cookie commentURL]]],
						[cookie domain],
						[PlistObjectConverter autoConvertNil: [cookie expiresDate]],
						[NSNumber numberWithBool: [cookie isHTTPOnly]],
						[NSNumber numberWithBool: [cookie isSecure]],
						[NSNumber numberWithBool: [cookie isSessionOnly]],
						[cookie name],
						[cookie path],
						[PlistObjectConverter autoConvertNil: [cookie portList]],
						[cookie properties],
						[cookie value],
						[NSNumber numberWithUnsignedInt: [cookie version]],
						nil]
					forKeys:
					[NSArray arrayWithObjects:
						@"comment",
						@"commentURL",
						@"domain",
						@"expiresDate",
						@"isHTTPOnly",
						@"isSecure",
						@"isSessionOnly",
						@"name",
						@"path",
						@"portList",
						@"properties",
						@"value",
						@"version",
						nil]];

	return cookieDict;
}



+ (NSDictionary *) convertUIPasteboard: (UIPasteboard*) pasteboard {
	if (pasteboard == nil)
		return [NSDictionary dictionary];

	NSDictionary *pasteboardDict;
	pasteboardDict = [NSDictionary dictionaryWithObjects:
		[NSArray arrayWithObjects:
			[pasteboard name],
			[NSNumber numberWithUnsignedInt: [pasteboard numberOfItems]],
			[NSNumber numberWithBool: pasteboard.persistent],
			[PlistObjectConverter autoConvertNil: [pasteboard string]],
			[PlistObjectConverter autoConvertNil: [PlistObjectConverter convertURL: [pasteboard URL]]],
			[PlistObjectConverter autoConvertNil: UIImagePNGRepresentation([pasteboard image])],
			nil]
		forKeys:
		[NSArray arrayWithObjects:
			@"name",
			@"numberOfItems",
			@"persistent",
			@"string",
			@"URL",
			@"image",
			nil]];

	return pasteboardDict;
}


// We just store a list of implemented delegate methods based on the delegate protocol
+ (NSArray *) convertDelegate: (id)delegate followingProtocol: (NSString*)protocol {
	if (delegate == nil)
		return [NSArray array];

	// Check which methods of the protocol the delegate actually implements
	NSMutableArray *delegateMethodsArray = [NSMutableArray array];

	// Get a list of the delegate protocol's methods
	Protocol* p = objc_getProtocol([protocol cStringUsingEncoding:NSASCIIStringEncoding]);

	// Taken from http://parmanoir.com/8_ways_to_use_Blocks_in_Snow_Leopard:
	// Custom block, used only in this method
	void (^enumerate)(BOOL, BOOL) = ^(BOOL isRequired, BOOL isInstance) {
		unsigned int descriptionCount;
		struct objc_method_description* methodDescriptions = protocol_copyMethodDescriptionList(p, isRequired, isInstance, &descriptionCount);
		// Check each methods
		for (int i=0; i<descriptionCount; i++)
		{
			struct objc_method_description methodDesc = methodDescriptions[i];
			//NSLog(@"Protocol method %@ isRequired=%d isInstance=%d", NSStringFromSelector(methodDesc.name), isRequired, isInstance);
			if ([delegate respondsToSelector:methodDesc.name]) {
				// This method is implemented by the delegate
				[delegateMethodsArray addObject:NSStringFromSelector(methodDesc.name)];
			}
		}
		if (methodDescriptions)	free(methodDescriptions);
	};
	// Call our block multiple times with different arguments 
	// to enumerate all class, instance, required and non-required methods
	enumerate(YES, YES);
	enumerate(YES, NO);
	enumerate(NO, YES);
	enumerate(NO, NO);

	return delegateMethodsArray;
}


// Convert a C buffer to a string of hex numbers
+ (NSData *) convertCBuffer:(const void *) buffer withLength: (size_t) length {

	if (buffer == nil)
		return [NSDictionary dictionary];
	NSData *bufferData = [NSData dataWithBytes:buffer length:(NSUInteger)length];
	return bufferData;
}

@end
