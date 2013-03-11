#import "CallTracer.h"
#import "SQLiteStorage.h"


@implementation CallTracer

@synthesize args;
@synthesize className;
@synthesize methodName;
@synthesize argsAndReturnValue;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth {
	/* initialize the call tracer with class and method names */
	self = [super init];
	args = [[NSMutableDictionary alloc] init];
	className = [[NSString alloc] initWithString:clazz];
	methodName = [[NSString alloc] initWithString:meth];
	argsAndReturnValue = [[NSMutableDictionary alloc] init];
	[argsAndReturnValue setValue:args forKey:@"arguments"];

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
		[argsAndReturnValue setValue:result forKey:@"returnValue"];
		return true;
	}
	return false;
}


- (NSData *) serializeArgsAndReturnValue {
	NSError *error;
	NSData *plist = [NSPropertyListSerialization dataWithPropertyList:(id)argsAndReturnValue
   							     format:NSPropertyListXMLFormat_v1_0 
   							    options:0
   							      error:&error];
	return plist;
}


- (void)dealloc
{
	[args release];
	[argsAndReturnValue release];
	[className release];
	[methodName release];
	[super dealloc];
}

@end
