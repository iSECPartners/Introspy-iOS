
#include <substrate.h>
#include <Security/Security.h>

#import "KeyChainHooks.h"
#import "../IntrospySQLiteStorage.h"


// Nice global
extern IntrospySQLiteStorage *traceStorage;


// Hook SecItemAdd()
// Will crash with a certificate
static OSStatus (*original_SecItemAdd)(CFDictionaryRef attributes, CFTypeRef *result);

static OSStatus replaced_SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result){
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemAdd"];
    [tracer addArgFromDictionary:(NSDictionary*)attributes withKey:@"attributes"];
    //[traceStorage saveTracedCall: tracer];
    [tracer release];
    return original_SecItemAdd(attributes, result);
    // TODO: Log result as well ?
}


// Hook SecItemCopyMatching()
static OSStatus (*original_SecItemCopyMatching)(CFDictionaryRef query, CFTypeRef *result);

static OSStatus replaced_SecItemCopyMatching(CFDictionaryRef query, CFTypeRef *result){
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemCopyMatching"];
    [tracer addArgFromDictionary:(NSDictionary*)query withKey:@"query"];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
    return original_SecItemCopyMatching(query, result);
}


// Hook SecItemDelete()
static OSStatus (*original_SecItemDelete)(CFDictionaryRef query);

static OSStatus replaced_SecItemDelete(CFDictionaryRef query){
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemDelete"];
    [tracer addArgFromDictionary:(NSDictionary*)query withKey:@"query"];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
    return original_SecItemDelete(query);
}


// Hook SecItemUpdate()
static OSStatus (*original_SecItemUpdate)(CFDictionaryRef query, CFDictionaryRef attributesToUpdate);

static OSStatus replaced_SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate){
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemUpdate"];
    [tracer addArgFromDictionary:(NSDictionary*)query withKey:@"query"];
    [tracer addArgFromDictionary:(NSDictionary*)attributesToUpdate withKey:@"attributesToUpdate"];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
    return original_SecItemUpdate(query, attributesToUpdate);
}


// Hook SecPKCS12Import() - TBD
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
