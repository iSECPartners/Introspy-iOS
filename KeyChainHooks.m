
#include <substrate.h>
#include <Security/Security.h>

#import "KeyChainHooks.h"
#import "IntrospySQLiteStorage.h"


// Nice global
extern IntrospySQLiteStorage *traceStorage;


// Hook SecItemAdd()
static OSStatus (*original_SecItemAdd)(CFDictionaryRef attributes, CFTypeRef *result);

static OSStatus replaced_SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result){
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemAdd"];
    [tracer addArgFromDictionary:(NSDictionary*)attributes withKey:@"attributes"];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
	return original_SecItemAdd(attributes, result);
}


@implementation KeyChainHooks : NSObject 


+ (void)enableHooks {
	MSHookFunction(SecItemAdd, replaced_SecItemAdd, (void **) &original_SecItemAdd);
    // TODO: Other keychain calls
}

@end
