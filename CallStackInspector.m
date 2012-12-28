#import "CallStackInspector.h"


@implementation CallStackInspector : NSObject


+ (BOOL) wasCalledInternally{
	// TODO Add all the internal APIs
	NSString *internalAPI = @"Security"; // Security framework: SSL, etc...
	return [self wasCalledBy:internalAPI];
}


+ (BOOL) wasCalledBy:(NSString *) name {

	// Check if the name is in the call stack string
    NSString *caller = [[NSThread callStackSymbols] objectAtIndex:3];
	NSMutableString* nameToCheck = [NSMutableString stringWithString: @"   "];
	[nameToCheck appendString: name];
	[nameToCheck appendString: @" "];
	NSRange result = [caller rangeOfString: nameToCheck];
	
	//NSLog(@"%@",[NSThread callStackSymbols]);
    //NSLog(@"LOL %i", result.location);
    
    if (result.location == NSNotFound)
    	return false;
    else
    	return true;
}


@end
