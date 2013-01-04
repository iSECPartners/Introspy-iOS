
#include <substrate.h>
#include <Security/Security.h>

#import "KeyChainHooks.h"
#import "../IntrospySQLiteStorage.h"


// Nice global
extern IntrospySQLiteStorage *traceStorage;


// Hook SecItemAdd()
// Will crash with a certificate. TODO: Sanitize the dictionnary before logging it
static OSStatus (*original_SecItemAdd)(CFDictionaryRef attributes, CFTypeRef *result);

static OSStatus replaced_SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result){
    OSStatus origResult = original_SecItemAdd(attributes, result);
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemAdd"];
    [tracer addArgFromPlistObject:(NSDictionary*)attributes withKey:@"attributes"];
    // Store the pointer value of result for now
    // TODO: if we have the attributes, why do we need to parse the result?
    [tracer addArgFromPlistObject: [NSNumber numberWithUnsignedInt: (unsigned int)result] withKey:@"result"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
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
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemUpdate"];
    [tracer addArgFromPlistObject:(NSDictionary*)query withKey:@"query"];
    [tracer addArgFromPlistObject:(NSDictionary*)attributesToUpdate withKey:@"attributesToUpdate"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
    return origResult;
}


// Hook SecPKCS12Import() - TODO: Useful for secure containers that use client certs to connect to the server
// TODO: SecKeyEncrypt for PKI
/*
static OSStatus (*original_SecPKCS12Import)(CFDataRef pkcs12_data, CFDictionaryRef options, CFArrayRef *items);

static OSStatus replaced_SecPKCS12Import(CFDataRef pkcs12_data, CFDictionaryRef options, CFArrayRef *items) {
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecPKCS12Import"];
    [tracer addArgFromDictionary:(NSDictionary*)options withKey:@"options"];
    [traceStorage saveTracedCall: tracer];
    [tracer release];  
    return original_SecPKCS12Import(pkcs12_data, options, items);

}
*/

@implementation KeyChainHooks : NSObject 

+ (void)enableHooks {
    MSHookFunction(SecItemAdd, replaced_SecItemAdd, (void **) &original_SecItemAdd);
    MSHookFunction(SecItemCopyMatching, replaced_SecItemCopyMatching, (void **) &original_SecItemCopyMatching);
    MSHookFunction(SecItemDelete, replaced_SecItemDelete, (void **) &original_SecItemDelete);
    MSHookFunction(SecItemUpdate, replaced_SecItemUpdate, (void **) &original_SecItemUpdate);
    //MSHookFunction((void *) SecPKCS12Import,(void *)  replaced_SecPKCS12Import, (void **) &original_SecPKCS12Import);

    // TODO: Hook the rest of the keychain API ?
}

@end
