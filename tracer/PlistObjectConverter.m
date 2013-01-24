#import "PlistObjectConverter.h"


@implementation PlistObjectConverter


// What we store in the plist if the object's pointer is nil
static NSString *serializedNilValue = @"nil";


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


+ (NSDictionary *) convertNSURLCredential: (NSURLCredential*) credential {
	if (credential == nil)
		return [NSDictionary dictionary];

	NSDictionary *credentialDict = nil;
	// TODO: store [cred identity] to extract the cert and private key for client auth
	credentialDict = [NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:
						[PlistObjectConverter autoConvertNil: [credential user]],
						[PlistObjectConverter autoConvertNil: [credential password]],
						[NSNumber numberWithUnsignedInt: (unsigned int)[credential certificates]], //TODO: Store the certs
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


// Convert a C buffer to a string of hex numbers
+ (NSString *) convertCBuffer:(const void *) buffer withLength: (size_t) length {

	if (buffer == nil)
		return [NSDictionary dictionary];
	// TODO: Base64 encode it for consistency with NSData ?
	NSMutableString *hexStream = [NSMutableString stringWithCapacity: length*2];
	for(int i=0;i<length;i++) {
		[hexStream appendFormat:@"%02x", ((unsigned char*) buffer)[i]];
	}
	return hexStream;
}

@end
