#import "CallTracer.h"
#import "SQLiteStorage.h"


@implementation CallTracer

@synthesize args;
@synthesize className;
@synthesize methodName;
@synthesize returnValue;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth {
	/* initialize the call tracer with class and method names */
	self = [super init];
	args = [[NSMutableDictionary alloc] init];
	className = [[NSString alloc] initWithString:clazz];
	methodName = [[NSString alloc] initWithString:meth];
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


- (NSData *) serializeArgs {
	/* serialize the NSDictionary of arguments into a plist */
	NSError *error;
	NSData *plist = [NSPropertyListSerialization dataWithPropertyList:(id)args
   							     format:NSPropertyListXMLFormat_v1_0 // for testing
   							    options:0
   							      error:&error];
	return plist;
}

- (NSData *) serializeReturnValue {
	/* serialize the NSDictionary of return value into a plist */
	NSError *error;
	NSData *plist = [NSPropertyListSerialization dataWithPropertyList:(id)returnValue
   							     format:NSPropertyListXMLFormat_v1_0 // for testing
   							    options:0
   							      error:&error];
	return plist;
}

- (void)dealloc
{
	[args release];
	[returnValue release];
	[className release];
	[methodName release];
	[super dealloc];
}

@end
