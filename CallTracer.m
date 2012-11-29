#import "CallTracer.h"
#import "IntrospyPlistSerialization.h"

@implementation CallTracer : NSObject

@synthesize args;
@synthesize className;
@synthesize methodName;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth {
	/* initialize the call tracer with class and method names */
	[super init];
	className = clazz;
	methodName = meth;
	return self;
}

- (BOOL) addArgFromString:(NSString *)str withKey:(NSString *)key {
	/* add a string argument to the plist of method arguments */
	[args setValue:str forKey:key];
	return true;
}

- (BOOL) addArgFromData:(NSData *)data withKey:(NSString *)key {
	/* add an NSData argument to the plist of method arguments */
	[args setValue:data forKey:key];
	return true;
}

- (BOOL) addArgFromDictionary:(NSDictionary *)dict withKey:(NSString *)key {
	/* add an NSDictionary argument to the plist of method arguments */
	[args setValue:dict forKey:key];
	return true;
}

- (BOOL) addArgFromBool:(BOOL)boolean withKey:(NSString *)key {
	/* add a BOOL argument to the plist of method arguments */
	[args setValue:[NSNumber numberWithBool:boolean] forKey:key];
	return true;
}

- (BOOL) addArgFromInt:(NSUInteger)val withKey:(NSString *)key {
	/* add a BOOL argument to the plist of method arguments */
	[args setValue:[NSNumber numberWithInt:val] forKey:key];
	return true;
}

- (id) serializeArgs {
    /* serialize the NSMutableDictionary of arguments into a plist */
    NSError *error;
    NSUInteger *format;
    id plist = [IntrospyPlistSerialization propertyListWithData:(id)args
	    						 options:NSPropertyListMutableContainersAndLeaves
							  format:format
							   error:&error];
    return plist;
}

@end
