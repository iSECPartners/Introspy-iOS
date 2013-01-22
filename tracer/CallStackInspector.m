#import "CallStackInspector.h"


@implementation CallStackInspector


+ (BOOL) wasDirectlyCalledByApp {
    //NSLog(@"%@",[NSThread callStackSymbols]);
    NSString *appProcessName = [[NSProcessInfo processInfo] processName];
    NSArray *callStack = [NSThread callStackSymbols];

    // Not ideal: Check if the app's process name is close enough in the call stack
    NSRange caller2 = [[callStack objectAtIndex:2] rangeOfString: appProcessName];
   
    if ((caller2.location == NSNotFound)) {
        return false;
    }
    return true;
}


@end
