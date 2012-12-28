#import "PlistObjectConverter.h"


@implementation PlistObjectConverter : NSObject


+ (NSDictionary *) convertURL:(NSURL *)aURL {
	NSDictionary *url_dict = nil;

	if (aURL != nil) {

		if ([[aURL scheme] isEqualToString:@"file"]) {
		  url_dict = [NSDictionary dictionaryWithObjects:
				   [NSArray arrayWithObjects: [aURL absoluteString],
							      nil]
						     forKeys: [NSArray arrayWithObjects:
						    	      @"absoluteString",
							      nil]];
		} else if ([[aURL scheme] isEqualToString:@"http"]) {
		  url_dict = [NSDictionary dictionaryWithObjects:
				   [NSArray arrayWithObjects: [aURL absoluteString],
				 			      [aURL scheme],
							      [aURL host],
							      [aURL port],
							      [aURL path],
							      [aURL parameterString],
							      [aURL query], nil]
						     forKeys: [NSArray arrayWithObjects:
						    	      @"absoluteString",
						    	      @"scheme",
							      @"host",
							      @"port",
							      @"path",
							      @"parameterString",
							      @"query", nil]];
		} 
	}
	return url_dict;
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
