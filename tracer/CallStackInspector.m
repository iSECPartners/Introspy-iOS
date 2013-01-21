#import "CallStackInspector.h"


@implementation CallStackInspector : NSObject





+ (BOOL) wasDirectlyCalledByApp {
    //NSLog(@"%@",[NSThread callStackSymbols]);

    NSString *appProcessName = [[NSProcessInfo processInfo] processName];
    NSArray *callStack = [NSThread callStackSymbols];

    // Not ideal: Check if the app's process name is close enough in the call stack
    NSRange caller2 = [[callStack objectAtIndex:2] rangeOfString: appProcessName];
    NSRange caller3 = [[callStack objectAtIndex:3] rangeOfString: appProcessName];
   
    if ((caller2.location == NSNotFound) && (caller3.location == NSNotFound)) {
        return false;
    }
    return true;
}



/*
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
*/

@end
