#import "PlistObjectConverter.h"



// TODO: This is going to be a huge file. We should split it in some way
@implementation PlistObjectConverter : NSObject


// Utility function to automatically convert nil to an empty string
+ (id) autoConvertNil:(id) pointer {
	if (pointer == nil) {
		return @"";
	}
	else {
		return pointer;
	}
}


// Convert an NSURL to an NSDictionary suitable for plist storage.
+ (NSDictionary *) convertURL:(NSURL *)aURL {
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
	NSDictionary *url_req = [NSDictionary dictionaryWithObjects:
				[NSArray arrayWithObjects:
					 		[self convertURL:[request URL]],
							[request HTTPMethod],
							[PlistObjectConverter autoConvertNil: [request HTTPBody]],
					     	[NSNumber numberWithInteger:[request cachePolicy]], 
					     	nil]
						forKeys: [NSArray arrayWithObjects:
							@"URL",
							@"HTTPMethod",
							@"HTTPBody",
							@"cachePolicy",
							nil]];
	return url_req;
}


// Convert an NSURLAuthenticationChallenge to an NSDictionary suitable for plist storage
+ (NSDictionary *) convertNSURLAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

	// Parse the protection space
	NSURLProtectionSpace *pSpace = [challenge protectionSpace];
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


	// Parse the proposed credential
	NSURLCredential *cred = [challenge proposedCredential];
	NSDictionary *credentialDict = nil;
	// TODO: store [cred identity] to extract the cert and private key for client auth
	credentialDict = [NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:
						[PlistObjectConverter autoConvertNil: [cred user]],
						[PlistObjectConverter autoConvertNil: [cred password]],
						[PlistObjectConverter autoConvertNil: [cred certificates]],
						[NSNumber numberWithUnsignedInt: [cred persistence]], 
						nil]
			      	forKeys:
				    	[NSArray arrayWithObjects:
						@"user",
				    	@"password",
				    	@"certificate",
						@"persistence", 
						nil]];

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


+ (NSDictionary *) convertNSHTTPCookie: (NSHTTPCookie*) cookie {
	if (cookie == nil) {
		return nil;
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
		return nil;

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
		return nil;

	NSMutableString *hexStream = [NSMutableString stringWithCapacity: length*2];
	for(int i=0;i<length;i++) {
		[hexStream appendFormat:@"%02x", ((unsigned char*) buffer)[i]];
	}
	return hexStream;
}

@end
