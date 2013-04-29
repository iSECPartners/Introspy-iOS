
#include <substrate.h>

#import "LibCHooks.h"
#import "../SQLiteStorage.h"
#import "../PlistObjectConverter.h"
#import "../CallStackInspector.h"

// Nice global
extern SQLiteStorage *traceStorage;


// Hook rand()
static int (*original_rand)();

static int replaced_rand() {

    int origResult = original_rand();

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"rand"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook random()
static long (*original_random)();

static long replaced_random() {

    long origResult = original_random();

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"random"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedLong:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}



@implementation LibCHooks

+ (void)enableHooks {
    MSHookFunction(random, replaced_random, (void **) &original_random);
    MSHookFunction(rand, replaced_rand, (void **) &original_rand);
}

@end
