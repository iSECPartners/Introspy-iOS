#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"


@implementation CallTracer : NSObject

@synthesize args;
@synthesize className;
@synthesize methodName;
@synthesize returnValue;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth {
	/* initialize the call tracer with class and method names */
	[super init];
	args = [[NSMutableDictionary alloc] init];
	className = clazz;
	methodName = meth;
	returnValue = [[NSMutableDictionary alloc] init];
	return self;
}

- (BOOL) addArgFromPlistObject:(id) arg withKey:(NSString *)key {
	if(arg != nil) {
		[args setValue:arg forKey:key];
		return true;
	}
	return false;
}

- (BOOL) addReturnValueFromPlistObject:(id) result {
	if(result != nil) {
		[returnValue setValue:result forKey:@"returnValue"];
		return true;
	}
	return false;
}


- (BOOL) addArgFromURL:(NSURL *)aURL withKey:(NSString *)key {
	/* creates a dictionary of the NSURL attributes and adds it to the plist */
	if (aURL != nil) {
		NSDictionary *url_dict;
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
		} else {
		  return false;
		}
		[self addArgFromPlistObject:url_dict withKey:key];
		return true;
	}
	return false;
}


- (NSData *) serializeArgs {
	/* serialize the NSDictionary of arguments into a plist */
	NSError *error;
	NSData *plist = [NSPropertyListSerialization dataWithPropertyList:(id)args
   							     format:NSPropertyListXMLFormat_v1_0 // for testing
   							    options:0
   							      error:&error];
//	if (error != nil) {
//		NSLog(@"CallTracer::serializeArgs: %@", error);
//		return nil;
//	}
	return plist;
}

- (NSData *) serializeReturnValue {
	/* serialize the NSDictionary of return value into a plist */
	NSError *error;
	NSData *plist = [NSPropertyListSerialization dataWithPropertyList:(id)returnValue
   							     format:NSPropertyListXMLFormat_v1_0 // for testing
   							    options:0
   							      error:&error];
//	if (error != nil) {
//		NSLog(@"CallTracer::serializeArgs: %@", error);
//		return nil;
//	}
	return plist;	
}

- (void)dealloc
{
    [args release];
    [returnValue release];
    [super dealloc];
}

@end
