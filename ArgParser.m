#import "ArgParser.h"
#import "IntrospyPlistSerialization.h"

@implementation ArgParser : NSObject

@synthesize args;

- (BOOL) addArgFromString:(NSString *)str key:(NSString *)key {
	/* add a string argument to the plist of method arguments */
	[args setValue:str forKey:key];
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
