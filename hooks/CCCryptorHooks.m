
#include <substrate.h>
#include <CommonCrypto/CommonCryptor.h>

#import "CCCryptorHooks.h"
#import "../IntrospySQLiteStorage.h"
#import "../PlistObjectConverter.h"
#import "../CallStackInspector.h"

// Nice global
extern IntrospySQLiteStorage *traceStorage;

// TODO: CCCryptorCreate() calls CCCryptorCreateFromData()
// TOOO: TestApp

// Hook CCCryptorCreate()
static CCCryptorStatus (*original_CCCryptorCreate)(CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, size_t keyLength,
         const void *iv, CCCryptorRef *cryptorRef);


static CCCryptorStatus replaced_CCCryptorCreate(CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, size_t keyLength,
         const void *iv, CCCryptorRef *cryptorRef) {

    CCCryptorStatus origResult = original_CCCryptorCreate(op, alg, options, key, keyLength, iv, cryptorRef);

    // Only log what the application directly calls. For example we don't want to log internal SSL crypto calls
    if (![CallStackInspector wasCalledInternally]) {
        
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CCCryptorCreate"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) op] withKey:@"op"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) alg] withKey:@"alg"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) options] withKey:@"options"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertCBuffer: key withLength: keyLength] withKey:@"key"];
        // TODO: IV. Not sure how to get the IV size. Probably using alg but that's not convenient
        [tracer addArgFromPlistObject:@"Introspy - Not implemented" withKey:@"iv"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) cryptorRef] withKey:@"cryptorRef"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}

      
// Hook CCCryptorUpdate()
static CCCryptorStatus (*original_CCCryptorUpdate)(CCCryptorRef cryptorRef, const void *dataIn, size_t dataInLength, void *dataOut,
         size_t dataOutAvailable, size_t *dataOutMoved);


static CCCryptorStatus replaced_CCCryptorUpdate(CCCryptorRef cryptorRef, const void *dataIn, size_t dataInLength, void *dataOut,
         size_t dataOutAvailable, size_t *dataOutMoved) {
    // TODO
    return original_CCCryptorUpdate(cryptorRef, dataIn, dataInLength, dataOut, dataOutAvailable, dataOutMoved);

}

@implementation CCCryptorHooks : NSObject 

+ (void)enableHooks {
     MSHookFunction((void *) CCCryptorCreate,(void *)  replaced_CCCryptorCreate, (void **) &original_CCCryptorCreate);
     MSHookFunction((void *) CCCryptorUpdate,(void *)  replaced_CCCryptorUpdate, (void **) &original_CCCryptorUpdate);
}

@end
