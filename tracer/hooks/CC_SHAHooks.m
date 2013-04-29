
#include <substrate.h>
#include <CommonCrypto/CommonDigest.h>

#import "CC_SHAHooks.h"
#import "../SQLiteStorage.h"
#import "../PlistObjectConverter.h"
#import "../CallStackInspector.h"

// Nice global
extern SQLiteStorage *traceStorage;


// No need to hook the CC_MDX_Init() functions as they don't do anything interesting

// Hook CC_SHA1_Update()
static int (*original_CC_SHA1_Update)(CC_SHA1_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_SHA1_Update(CC_SHA1_CTX *c, const void *data, CC_LONG len) {

    int origResult = original_CC_SHA1_Update(c, data, len);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA1_Update"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_SHA512_Update()
static int (*original_CC_SHA512_Update)(CC_SHA512_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_SHA512_Update(CC_SHA512_CTX *c, const void *data, CC_LONG len) {

    int origResult = original_CC_SHA512_Update(c, data, len);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA512_Update"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_SHA256_Update()
static int (*original_CC_SHA256_Update)(CC_SHA256_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_SHA256_Update(CC_SHA256_CTX *c, const void *data, CC_LONG len) {

    int origResult = original_CC_SHA256_Update(c, data, len);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA256_Update"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}



// Hook CC_SHA1_Final()
static int (*original_CC_SHA1_Final)(unsigned char *md, CC_SHA1_CTX *c);

static int replaced_CC_SHA1_Final(unsigned char *md, CC_SHA1_CTX *c) {

    int origResult = original_CC_SHA1_Final(md, c);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA1_Final"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_SHA1_DIGEST_LENGTH] withKey:@"md"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_SHA512_Final()
static int (*original_CC_SHA512_Final)(unsigned char *md, CC_SHA512_CTX *c);

static int replaced_CC_SHA512_Final(unsigned char *md, CC_SHA512_CTX *c) {

    int origResult = original_CC_SHA512_Final(md, c);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA512_Final"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_SHA512_DIGEST_LENGTH] withKey:@"md"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_SHA256_Final()
static int (*original_CC_SHA256_Final)(unsigned char *md, CC_SHA256_CTX *c);

static int replaced_CC_SHA256_Final(unsigned char *md, CC_SHA256_CTX *c) {

    int origResult = original_CC_SHA256_Final(md, c);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA256_Final"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_SHA256_DIGEST_LENGTH] withKey:@"md"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_SHA1()
static unsigned char * (*original_CC_SHA1)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_SHA1(const void *data, CC_LONG len, unsigned char *md) {

    unsigned char *origResult = original_CC_SHA1(data, len, md);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA1"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_SHA1_DIGEST_LENGTH] withKey:@"md"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt: (int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_SHA512()
static unsigned char * (*original_CC_SHA512)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_SHA512(const void *data, CC_LONG len, unsigned char *md) {

    unsigned char *origResult = original_CC_SHA512(data, len, md);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA512"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_SHA512_DIGEST_LENGTH] withKey:@"md"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt: (int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_SHA256()
static unsigned char * (*original_CC_SHA256)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_SHA256(const void *data, CC_LONG len, unsigned char *md) {

    unsigned char *origResult = original_CC_SHA256(data, len, md);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_SHA256"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_SHA256_DIGEST_LENGTH] withKey:@"md"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt: (int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


@implementation CC_SHAHooks

+ (void)enableHooks {
    MSHookFunction(CC_SHA1_Update, replaced_CC_SHA1_Update, (void **) &original_CC_SHA1_Update);
    MSHookFunction(CC_SHA512_Update, replaced_CC_SHA512_Update, (void **) &original_CC_SHA512_Update);
    MSHookFunction(CC_SHA256_Update, replaced_CC_SHA256_Update, (void **) &original_CC_SHA256_Update);
    MSHookFunction(CC_SHA1_Final, replaced_CC_SHA1_Final, (void **) &original_CC_SHA1_Final);
    MSHookFunction(CC_SHA512_Final, replaced_CC_SHA512_Final, (void **) &original_CC_SHA512_Final);
    MSHookFunction(CC_SHA256_Final, replaced_CC_SHA256_Final, (void **) &original_CC_SHA256_Final);
    MSHookFunction(CC_SHA1, replaced_CC_SHA1, (void **) &original_CC_SHA1);
    MSHookFunction(CC_SHA512, replaced_CC_SHA512, (void **) &original_CC_SHA512);
    MSHookFunction(CC_SHA256, replaced_CC_SHA256, (void **) &original_CC_SHA256);
}

@end
