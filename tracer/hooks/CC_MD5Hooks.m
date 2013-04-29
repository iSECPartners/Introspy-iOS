
#include <substrate.h>
#include <CommonCrypto/CommonDigest.h>

#import "CC_MD5Hooks.h"
#import "../SQLiteStorage.h"
#import "../PlistObjectConverter.h"
#import "../CallStackInspector.h"

// Nice global
extern SQLiteStorage *traceStorage;


// No need to hook the CC_MDX_Init() functions as they don't do anything interesting

// Hook CC_MD2_Update()
static int (*original_CC_MD2_Update)(CC_MD2_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_MD2_Update(CC_MD2_CTX *c, const void *data, CC_LONG len) {

    int origResult = original_CC_MD2_Update(c, data, len);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD2_Update"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD4_Update()
static int (*original_CC_MD4_Update)(CC_MD4_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_MD4_Update(CC_MD4_CTX *c, const void *data, CC_LONG len) {

    int origResult = original_CC_MD4_Update(c, data, len);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD4_Update"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD5_Update()
static int (*original_CC_MD5_Update)(CC_MD5_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_MD5_Update(CC_MD5_CTX *c, const void *data, CC_LONG len) {

    int origResult = original_CC_MD5_Update(c, data, len);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD5_Update"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}



// Hook CC_MD2_Final()
static int (*original_CC_MD2_Final)(unsigned char *md, CC_MD2_CTX *c);

static int replaced_CC_MD2_Final(unsigned char *md, CC_MD2_CTX *c) {

    int origResult = original_CC_MD2_Final(md, c);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD2_Final"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_MD2_DIGEST_LENGTH] withKey:@"md"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD4_Final()
static int (*original_CC_MD4_Final)(unsigned char *md, CC_MD4_CTX *c);

static int replaced_CC_MD4_Final(unsigned char *md, CC_MD4_CTX *c) {

    int origResult = original_CC_MD4_Final(md, c);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD4_Final"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_MD4_DIGEST_LENGTH] withKey:@"md"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD5_Final()
static int (*original_CC_MD5_Final)(unsigned char *md, CC_MD5_CTX *c);

static int replaced_CC_MD5_Final(unsigned char *md, CC_MD5_CTX *c) {

    int origResult = original_CC_MD5_Final(md, c);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD5_Final"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_MD5_DIGEST_LENGTH] withKey:@"md"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD2()
static unsigned char * (*original_CC_MD2)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_MD2(const void *data, CC_LONG len, unsigned char *md) {

    unsigned char *origResult = original_CC_MD2(data, len, md);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD2"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_MD2_DIGEST_LENGTH] withKey:@"md"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt: (int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD4()
static unsigned char * (*original_CC_MD4)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_MD4(const void *data, CC_LONG len, unsigned char *md) {

    unsigned char *origResult = original_CC_MD4(data, len, md);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD4"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_MD4_DIGEST_LENGTH] withKey:@"md"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt: (int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD5()
static unsigned char * (*original_CC_MD5)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_MD5(const void *data, CC_LONG len, unsigned char *md) {

    unsigned char *origResult = original_CC_MD5(data, len, md);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CC_MD5"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: CC_MD5_DIGEST_LENGTH] withKey:@"md"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt: (int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


@implementation CC_MD5Hooks

+ (void)enableHooks {
    MSHookFunction(CC_MD2_Update, replaced_CC_MD2_Update, (void **) &original_CC_MD2_Update);
    MSHookFunction(CC_MD4_Update, replaced_CC_MD4_Update, (void **) &original_CC_MD4_Update);
    MSHookFunction(CC_MD5_Update, replaced_CC_MD5_Update, (void **) &original_CC_MD5_Update);
    MSHookFunction(CC_MD2_Final, replaced_CC_MD2_Final, (void **) &original_CC_MD2_Final);
    MSHookFunction(CC_MD4_Final, replaced_CC_MD4_Final, (void **) &original_CC_MD4_Final);
    MSHookFunction(CC_MD5_Final, replaced_CC_MD5_Final, (void **) &original_CC_MD5_Final);
    MSHookFunction(CC_MD2, replaced_CC_MD2, (void **) &original_CC_MD2);
    MSHookFunction(CC_MD4, replaced_CC_MD4, (void **) &original_CC_MD4);
    MSHookFunction(CC_MD5, replaced_CC_MD5, (void **) &original_CC_MD5);
}

@end
