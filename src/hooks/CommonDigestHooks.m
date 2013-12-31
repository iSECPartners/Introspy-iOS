
#include <substrate.h>
#include <CommonCrypto/CommonDigest.h>

#import "CommonDigestHooks.h"
#import "../SQLiteStorage.h"
#import "../PlistObjectConverter.h"
#import "../CallStackInspector.h"

// Nice global
extern SQLiteStorage *traceStorage;


// No need to hook the CC_MDX_Init() functions as they don't do anything interesting


// Generic function to log CC_XXX_Update() calls
static int log_CC_XXX_Update(void *c, const void *data, CC_LONG len, NSString *functionName, int (*functionPointer)(void *, const void *, CC_LONG) ) {

    int origResult = functionPointer(c, data, len);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    // Index = 3 because this function is called by Introspy first. TODO: Check that
    if ([CallStackInspector wasCalledByAppAtIndex:3]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:functionName];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD2_Update()
static int (*original_CC_MD2_Update)(CC_MD2_CTX *c, const void *data, CC_LONG len);
static int replaced_CC_MD2_Update(CC_MD2_CTX *c, const void *data, CC_LONG len) {
    // We're casting original_CC_MD2_Update() from (int)(CC_MD2_CTX *, const void *, CC_LONG) 
    // to (int)(void *, const void *, CC_LONG). Specifically, the first argument needs to be 
    // (void *) instead of (CC_MD2_CTX *) because we want log_CC_XXX_Update() to be generic.
    // It compiles but will it work !??
    return log_CC_XXX_Update(c, data, len, @"CC_MD2_Update", (int (*)(void *, const void *, CC_LONG)) original_CC_MD2_Update);
}


// Hook CC_MD4_Update()
static int (*original_CC_MD4_Update)(CC_MD4_CTX *c, const void *data, CC_LONG len);
static int replaced_CC_MD4_Update(CC_MD4_CTX *c, const void *data, CC_LONG len) {
    return log_CC_XXX_Update(c, data, len, @"CC_MD4_Update", (int (*)(void *, const void *, CC_LONG)) original_CC_MD4_Update);
}


// Hook CC_MD5_Update()
static int (*original_CC_MD5_Update)(CC_MD5_CTX *c, const void *data, CC_LONG len);
static int replaced_CC_MD5_Update(CC_MD5_CTX *c, const void *data, CC_LONG len) {
    return log_CC_XXX_Update(c, data, len, @"CC_MD5_Update", (int (*)(void *, const void *, CC_LONG)) original_CC_MD5_Update);
}



// Hook CC_SHA1_Update()
static int (*original_CC_SHA1_Update)(CC_SHA1_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_SHA1_Update(CC_SHA1_CTX *c, const void *data, CC_LONG len) {
    return log_CC_XXX_Update(c, data, len, @"CC_SHA1_Update", (int (*)(void *, const void *, CC_LONG)) original_CC_SHA1_Update);
}


// Hook CC_SHA512_Update()
static int (*original_CC_SHA512_Update)(CC_SHA512_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_SHA512_Update(CC_SHA512_CTX *c, const void *data, CC_LONG len) {
    return log_CC_XXX_Update(c, data, len, @"CC_SHA512_Update", (int (*)(void *, const void *, CC_LONG)) original_CC_SHA512_Update);
}



// Hook CC_SHA256_Update()
static int (*original_CC_SHA256_Update)(CC_SHA256_CTX *c, const void *data, CC_LONG len);

static int replaced_CC_SHA256_Update(CC_SHA256_CTX *c, const void *data, CC_LONG len) {
    return log_CC_XXX_Update(c, data, len, @"CC_SHA256_Update", (int (*)(void *, const void *, CC_LONG)) original_CC_SHA256_Update);
}




// Generic function to log CC_XXX_Final() calls
static int log_CC_XXX_Final(unsigned char *md, void *c, NSString *functionName, int (*functionPointer)(unsigned char *, void *), int digestLen) {

    int origResult = functionPointer(md, c);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasCalledByAppAtIndex:3]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:functionName];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: digestLen] withKey:@"md"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) c] withKey:@"c"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD2_Final()
static int (*original_CC_MD2_Final)(unsigned char *md, CC_MD2_CTX *c);

static int replaced_CC_MD2_Final(unsigned char *md, CC_MD2_CTX *c) {
    return log_CC_XXX_Final(md, c, @"CC_MD2_Final", (int (*)(unsigned char *, void *)) original_CC_MD2_Final, CC_MD2_DIGEST_LENGTH);
}


// Hook CC_MD4_Final()
static int (*original_CC_MD4_Final)(unsigned char *md, CC_MD4_CTX *c);

static int replaced_CC_MD4_Final(unsigned char *md, CC_MD4_CTX *c) {
    return log_CC_XXX_Final(md, c, @"CC_MD2_Final", (int (*)(unsigned char *, void *)) original_CC_MD4_Final, CC_MD4_DIGEST_LENGTH);
}


// Hook CC_MD5_Final()
static int (*original_CC_MD5_Final)(unsigned char *md, CC_MD5_CTX *c);

static int replaced_CC_MD5_Final(unsigned char *md, CC_MD5_CTX *c) {
    return log_CC_XXX_Final(md, c, @"CC_MD5_Final", (int (*)(unsigned char *, void *)) original_CC_MD5_Final, CC_MD5_DIGEST_LENGTH);
}



// Hook CC_SHA1_Final()
static int (*original_CC_SHA1_Final)(unsigned char *md, CC_SHA1_CTX *c);

static int replaced_CC_SHA1_Final(unsigned char *md, CC_SHA1_CTX *c) {
    return log_CC_XXX_Final(md, c, @"CC_SHA1_Final", (int (*)(unsigned char *, void *)) original_CC_SHA1_Final, CC_SHA1_DIGEST_LENGTH);
}


// Hook CC_SHA512_Final()
static int (*original_CC_SHA512_Final)(unsigned char *md, CC_SHA512_CTX *c);

static int replaced_CC_SHA512_Final(unsigned char *md, CC_SHA512_CTX *c) {
    return log_CC_XXX_Final(md, c, @"CC_SHA512_Final", (int (*)(unsigned char *, void *)) original_CC_SHA512_Final, CC_SHA512_DIGEST_LENGTH);
}


// Hook CC_SHA256_Final()
static int (*original_CC_SHA256_Final)(unsigned char *md, CC_SHA256_CTX *c);

static int replaced_CC_SHA256_Final(unsigned char *md, CC_SHA256_CTX *c) {
    return log_CC_XXX_Final(md, c, @"CC_SHA256_Final", (int (*)(unsigned char *, void *)) original_CC_SHA256_Final, CC_SHA256_DIGEST_LENGTH);
}



// Generic function to log CC_XXX() calls
static unsigned char * log_CC_XXX(const void *data, CC_LONG len, unsigned char *md,  NSString *functionName, unsigned char * (*functionPointer)(const void *, CC_LONG, unsigned char *), int digestLen) {

    unsigned char *origResult = functionPointer(data, len, md);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if ([CallStackInspector wasDirectlyCalledByApp]) {

        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:functionName];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: data withLength: len] withKey:@"data"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: md withLength: digestLen] withKey:@"md"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt: (int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


// Hook CC_MD2()
static unsigned char * (*original_CC_MD2)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_MD2(const void *data, CC_LONG len, unsigned char *md) {
    return log_CC_XXX(data, len, md, @"CC_MD2", original_CC_MD2, CC_MD2_DIGEST_LENGTH);
}


// Hook CC_MD4()
static unsigned char * (*original_CC_MD4)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_MD4(const void *data, CC_LONG len, unsigned char *md) {
    return log_CC_XXX(data, len, md, @"CC_MD4", original_CC_MD4, CC_MD4_DIGEST_LENGTH);
}


// Hook CC_MD5()
static unsigned char * (*original_CC_MD5)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_MD5(const void *data, CC_LONG len, unsigned char *md) {
    return log_CC_XXX(data, len, md, @"CC_MD5", original_CC_MD5, CC_MD5_DIGEST_LENGTH);
}



// Hook CC_SHA1()
static unsigned char * (*original_CC_SHA1)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_SHA1(const void *data, CC_LONG len, unsigned char *md) {
    return log_CC_XXX(data, len, md, @"CC_SHA1", original_CC_SHA1, CC_SHA1_DIGEST_LENGTH);
}


// Hook CC_SHA512()
static unsigned char * (*original_CC_SHA512)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_SHA512(const void *data, CC_LONG len, unsigned char *md) {
    return log_CC_XXX(data, len, md, @"CC_SHA512", original_CC_SHA512, CC_SHA512_DIGEST_LENGTH);
}


// Hook CC_SHA256()
static unsigned char * (*original_CC_SHA256)(const void *data, CC_LONG len, unsigned char *md);

static unsigned char * replaced_CC_SHA256(const void *data, CC_LONG len, unsigned char *md) {
    return log_CC_XXX(data, len, md, @"CC_SHA256", original_CC_SHA256, CC_SHA256_DIGEST_LENGTH);
}




@implementation CommonDigestHooks

+ (void)enableHooks {
    MSHookFunction(CC_MD2_Update, replaced_CC_MD2_Update, (void **) &original_CC_MD2_Update);
    MSHookFunction(CC_MD4_Update, replaced_CC_MD4_Update, (void **) &original_CC_MD4_Update);
    MSHookFunction(CC_MD5_Update, replaced_CC_MD5_Update, (void **) &original_CC_MD5_Update);
    MSHookFunction(CC_SHA1_Update, replaced_CC_SHA1_Update, (void **) &original_CC_SHA1_Update);
    MSHookFunction(CC_SHA512_Update, replaced_CC_SHA512_Update, (void **) &original_CC_SHA512_Update);
    MSHookFunction(CC_SHA256_Update, replaced_CC_SHA256_Update, (void **) &original_CC_SHA256_Update);

    MSHookFunction(CC_MD2_Final, replaced_CC_MD2_Final, (void **) &original_CC_MD2_Final);
    MSHookFunction(CC_MD4_Final, replaced_CC_MD4_Final, (void **) &original_CC_MD4_Final);
    MSHookFunction(CC_MD5_Final, replaced_CC_MD5_Final, (void **) &original_CC_MD5_Final);
    MSHookFunction(CC_SHA1_Final, replaced_CC_SHA1_Final, (void **) &original_CC_SHA1_Final);
    MSHookFunction(CC_SHA512_Final, replaced_CC_SHA512_Final, (void **) &original_CC_SHA512_Final);
    MSHookFunction(CC_SHA256_Final, replaced_CC_SHA256_Final, (void **) &original_CC_SHA256_Final);
    
    MSHookFunction(CC_MD2, replaced_CC_MD2, (void **) &original_CC_MD2);
    MSHookFunction(CC_MD4, replaced_CC_MD4, (void **) &original_CC_MD4);
    MSHookFunction(CC_MD5, replaced_CC_MD5, (void **) &original_CC_MD5);
    MSHookFunction(CC_SHA1, replaced_CC_SHA1, (void **) &original_CC_SHA1);
    MSHookFunction(CC_SHA512, replaced_CC_SHA512, (void **) &original_CC_SHA512);
    MSHookFunction(CC_SHA256, replaced_CC_SHA256, (void **) &original_CC_SHA256);
}

@end
