
#include <substrate.h>
#include <CommonCrypto/CommonHMAC.h>

#import "CCHmacHooks.h"
#import "../IntrospySQLiteStorage.h"
#import "../PlistObjectConverter.h"
#import "../CallStackInspector.h"

// Nice global
extern IntrospySQLiteStorage *traceStorage;

// from CommonDigest.h
#define HMAC_MAX_BLOCK_SIZE	CC_SHA512_BLOCK_BYTES
#define	HMAC_MAX_DIGEST_SIZE	CC_SHA512_DIGEST_LENGTH

// from Apple's CommonHMAC.c implementation
// This is what a CCHmacContext actually points to. 384 bytes to work with
// if iOS >= 6 (otherwise it's a _CCHmacContext)
//typedef struct {
//    struct ccdigest_info *di;
//} _NewHmacContext;
/* 
 * This is what a CCHmacContext actually points to.
 */
//typedef struct {
//	uint32_t		digestLen;
//	uint32_t		blockLen;
//	union {
//		CC_MD5_CTX	md5Ctx;
//		CC_SHA1_CTX	sha1Ctx;
//		CC_SHA256_CTX 	sha256Ctx;
//		CC_SHA512_CTX 	sha512Ctx;
//	} digest;
//	uint8_t			k_opad[HMAC_MAX_BLOCK_SIZE];	/* max block size */
//	ccDigestInit		digestInit;
//	ccDigestUpdate		digestUpdate;
//	ccDigestFinal		digestFinal;
//} _CCHmacContext;

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
	// TODO: cast the CCHmacContext to a _NewHmacContext(defined above) and
	// grab the output_size. based on apples implementation:
	// http://www.opensource.apple.com/source/CommonCrypto/CommonCrypto-60026/Source/API/CommonHMAC.c
	// note this changed in iOS 6 so wont work in previous versions. we cld
	// preprocessor for version and cast to _CCHmacContext if we wanted...
	//_NewHmacContext *hmacCtx = (_NewHmacContext *)ctx;
	//_CCHmacContext	*hmacCtx = (_CCHmacContext *)ctx;
	//uint32_t ui_len = hmacCtx->digestLen;
	//NSLog(@"HMAC has digest length: %i", ui_len);
	//[tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer:macOut withLength:ui_len] withKey:@"macOut"];
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
