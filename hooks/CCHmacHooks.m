
#include <substrate.h>
#include <CommonCrypto/CommonHMAC.h>

#import "CCHmacHooks.h"
#import "../IntrospySQLiteStorage.h"
#import "../PlistObjectConverter.h"
#import "../CallStackInspector.h"

// Nice global
extern IntrospySQLiteStorage *traceStorage;



static size_t getHmacLength(CCHmacAlgorithm algorithm) {

    switch(algorithm) {
        case kCCHmacAlgSHA1:
            return CC_SHA1_DIGEST_LENGTH;
        case kCCHmacAlgMD5:
            return CC_MD5_DIGEST_LENGTH;
        case kCCHmacAlgSHA256:
            return CC_SHA256_DIGEST_LENGTH;
        case kCCHmacAlgSHA384:
            return CC_SHA384_DIGEST_LENGTH;
        case kCCHmacAlgSHA512:
            return CC_SHA512_DIGEST_LENGTH;
        case kCCHmacAlgSHA224:
            return CC_SHA224_DIGEST_LENGTH;
        default:
            return 0;
    }    
}
    

// Hook CCHmacInit()
static void (*original_CCHmacInit)(CCHmacContext *ctx, CCHmacAlgorithm algorithm, const void *key, size_t keyLength);

static void replaced_CCHmacInit(CCHmacContext *ctx, CCHmacAlgorithm algorithm, const void *key, size_t keyLength) {
    
    original_CCHmacInit(ctx, algorithm, key, keyLength);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CCHmacInit"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) ctx] withKey:@"ctx"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) algorithm] withKey:@"algorithm"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: key withLength: keyLength] withKey:@"key"];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return;
}


// Hook CCHmacUpdate()
static void (*original_CCHmacUpdate)(CCHmacContext *ctx, const void *data, size_t dataLength);

static void replaced_CCHmacUpdate(CCHmacContext *ctx, const void *data, size_t dataLength){
    
    original_CCHmacUpdate(ctx, data, dataLength);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CCHmacUpdate"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) ctx] withKey:@"ctx"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: dataLength] withKey:@"data"];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return;
}


// Hook CCHmacFinal() 
// TODO: Figure out how to get the size of macout
static void (*original_CCHmacFinal)(CCHmacContext *ctx, void *macOut);

static void replaced_CCHmacFinal(CCHmacContext *ctx, void *macOut) {
    
    original_CCHmacFinal(ctx, macOut);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CCHmacFinal"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) ctx] withKey:@"ctx"];
        [tracer addArgFromPlistObject:@"Introspy - not implemented" withKey:@"macOut"];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return;
}


// Hook CCHmac()
static void (*original_CCHmac)(CCHmacAlgorithm algorithm, const void *key, size_t keyLength, const void *data, size_t dataLength, void *macOut);

static void replaced_CCHmac(CCHmacAlgorithm algorithm, const void *key, size_t keyLength, const void *data, size_t dataLength, void *macOut) {
    
    original_CCHmac(algorithm, key, keyLength, data, dataLength, macOut);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CCHmac"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) algorithm] withKey:@"algorithm"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: key withLength: keyLength] withKey:@"key"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: dataLength] withKey:@"data"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: macOut withLength: getHmacLength(algorithm)] withKey:@"macOut"];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return;
}

@implementation CCHmacHooks : NSObject 

+ (void)enableHooks {
    MSHookFunction(CCHmacInit, replaced_CCHmacInit, (void **) &original_CCHmacInit);
    MSHookFunction(CCHmacUpdate, replaced_CCHmacUpdate, (void **) &original_CCHmacUpdate);
    MSHookFunction(CCHmacFinal, replaced_CCHmacFinal, (void **) &original_CCHmacFinal);
    MSHookFunction(CCHmac, replaced_CCHmac, (void **) &original_CCHmac);
}

@end
