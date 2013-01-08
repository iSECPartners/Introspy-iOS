#import "PlistObjectConverter.h"


@implementation PlistObjectConverter : NSObject

// Convert an NSURL to an NSDictionary suitable for plist storage.
+ (NSDictionary *) convertURL:(NSURL *)aURL {
	NSDictionary *url_dict = nil;

	if (aURL != nil) {
		// store specific infoz if its an HTTP URL
		if ([[aURL scheme] isEqualToString:@"http"]) {

// TODO: implement code to check if values are nil before adding them. hooked
// apps kept crashing with nll values for port and parameterString so i just
// commented it out for the time being.
		  url_dict = [NSDictionary dictionaryWithObjects:
				   [NSArray arrayWithObjects: [aURL absoluteString],
				 			      [aURL scheme],
							      [aURL host],
//							      [aURL port],
							      [aURL path],
//							      [aURL parameterString],
							      [aURL query], nil]
					      	     forKeys:
							      [NSArray arrayWithObjects:
						    	      @"absoluteString",
	      						      @"scheme",
							      @"host",
//							      @"port",
							      @"path",
//							      @"parameterString",
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
							[request HTTPBody],
						     	[NSNumber numberWithInteger:[request cachePolicy]], nil]
						forKeys: [NSArray arrayWithObjects:
							@"URL",
							@"HTTPMethod",
							@"HTTPBody",
							@"cachePolicy", nil]];
	return url_req;
}

// Convert an NSURLAuthenticationChallenge to an NSDictionary suitable for plist storage
+ (NSDictionary *) convertNSURLAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSURLCredential *cred = [challenge proposedCredential];
	NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
	NSDictionary *authChallenge = nil;
	// determine if the credential is password or certificate based.
	// is this sufficient detection?? <- need negative test cases.
	if (authMethod == NSURLAuthenticationMethodClientCertificate) {
		authChallenge = [NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:
							[cred user],
							[cred certificates],
							authMethod,
							[NSNumber numberWithInteger:[cred persistence]], nil]
				      forKeys:
					    	[NSArray arrayWithObjects:
							@"user",
					    		@"certificates",
							@"authMethod",
							@"persistence", nil]];
	// password based
	} else {
		authChallenge = [NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:
							[cred user],
							[cred password],
							authMethod,
							[NSNumber numberWithInteger:[cred persistence]], nil]
				      forKeys:
					    	[NSArray arrayWithObjects:
							@"user",
					    		@"password",
							@"authMethod",
							@"persistence", nil]];
	}
	return authChallenge;
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
