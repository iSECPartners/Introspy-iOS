
#include <substrate.h>
#include <Security/Security.h>

#import "SecurityHooks.h"
#import "../SQLiteStorage.h"
#import "../PlistObjectConverter.h"
#import "../CallStackInspector.h"


// Nice global
extern SQLiteStorage *traceStorage;



// Public Crypto Hook
// Hook SecPKCS12Import() - If the app uses a client cert

static OSStatus (*original_SecPKCS12Import)(CFDataRef pkcs12_data, CFDictionaryRef options, CFArrayRef *items);

static OSStatus replaced_SecPKCS12Import(CFDataRef pkcs12_data, CFDictionaryRef options, CFArrayRef *items) {
    OSStatus origResult = original_SecPKCS12Import(pkcs12_data, options, items);
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecPKCS12Import"];
    [tracer addArgFromPlistObject:(NSData*)pkcs12_data withKey:@"pkcs12_data"];
    [tracer addArgFromPlistObject:(NSDictionary*)options withKey:@"options"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
    [traceStorage saveTracedCall: tracer];
    [tracer release];  
    return original_SecPKCS12Import(pkcs12_data, options, items);

}


// Keychain Hookss
// Hook SecItemAdd()
static OSStatus (*original_SecItemAdd)(CFDictionaryRef attributes, CFTypeRef *result);

static OSStatus replaced_SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result){
    
    OSStatus origResult = original_SecItemAdd(attributes, result);

    // Need the call stack inspector or we get into a weird infinite loop of SecItemAdd() calls
    // because SecIdentityCopyCertificate() seems to call SecItemAdd(), or something...
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemAdd"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertSecItemAttributesDict:attributes] withKey:@"attributes"];
        [tracer addArgFromPlistObject: [NSNumber numberWithUnsignedInt: (unsigned int)result] withKey:@"result"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }

    return origResult;
}


// Hook SecItemCopyMatching()
static OSStatus (*original_SecItemCopyMatching)(CFDictionaryRef query, CFTypeRef *result);

static OSStatus replaced_SecItemCopyMatching(CFDictionaryRef query, CFTypeRef *result){
    OSStatus origResult = original_SecItemCopyMatching(query, result);
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemCopyMatching"];
    [tracer addArgFromPlistObject:(NSDictionary*)query withKey:@"query"];
    [tracer addArgFromPlistObject: [NSNumber numberWithUnsignedInt: (unsigned int)result] withKey:@"result"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
    return origResult;
}


// Hook SecItemDelete()
static OSStatus (*original_SecItemDelete)(CFDictionaryRef query);

static OSStatus replaced_SecItemDelete(CFDictionaryRef query){
    OSStatus origResult = original_SecItemDelete(query);
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemDelete"];
    [tracer addArgFromPlistObject:(NSDictionary*)query withKey:@"query"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
    return origResult;
}


// Hook SecItemUpdate()
static OSStatus (*original_SecItemUpdate)(CFDictionaryRef query, CFDictionaryRef attributesToUpdate);

static OSStatus replaced_SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate){
    OSStatus origResult = original_SecItemUpdate(query, attributesToUpdate);
    
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemUpdate"];
        [tracer addArgFromPlistObject:(NSDictionary*)query withKey:@"query"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertSecItemAttributesDict:attributesToUpdate] withKey:@"attributesToUpdate"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
}
    return origResult;
}


@implementation SecurityHooks 

+ (void)enableHooks {
    MSHookFunction(SecItemAdd, replaced_SecItemAdd, (void **) &original_SecItemAdd);
    MSHookFunction(SecItemCopyMatching, replaced_SecItemCopyMatching, (void **) &original_SecItemCopyMatching);
    MSHookFunction(SecItemDelete, replaced_SecItemDelete, (void **) &original_SecItemDelete);
    MSHookFunction(SecItemUpdate, replaced_SecItemUpdate, (void **) &original_SecItemUpdate);
    MSHookFunction((void *) SecPKCS12Import,(void *)  replaced_SecPKCS12Import, (void **) &original_SecPKCS12Import);
}

@end
