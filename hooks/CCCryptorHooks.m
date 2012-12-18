
#include <substrate.h>
#include <CommonCrypto/CommonCryptor.h>

#import "CCCryptorHooks.h"
#import "../IntrospySQLiteStorage.h"


// Nice global
extern IntrospySQLiteStorage *traceStorage;

//TODO: CCCryptorCreate() calls CCCryptorCreateFromData()

// Hook CCCryptorCreate()
// Noisy because it gets called for SSL crypto. TODO: Fix it
static CCCryptorStatus (*original_CCCryptorCreate)(CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, size_t keyLength,
         const void *iv, CCCryptorRef *cryptorRef);


static CCCryptorStatus replaced_CCCryptorCreate(CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, size_t keyLength,
         const void *iv, CCCryptorRef *cryptorRef) {
    // TBD
    /*
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"CCCryptorCreate"];
    [tracer addArgFromInteger:op withKey:@"op"];
    [tracer addArgFromInteger:alg withKey:@"alg"];
    [tracer addArgFromInteger:options withKey:@"options"];
    //[tracer addArgFromBuffer:key withSize:keyLength withKey:@"key"];
    //[tracer addArgFromBuffer:iv withSize:keyLength withKey:@"iv"];
    [traceStorage saveTracedCall: tracer];
    [tracer release];*/
    return original_CCCryptorCreate(op, alg, options, key, keyLength, iv, cryptorRef);
}


// Hook CCCryptorUpdate()
static CCCryptorStatus (*original_CCCryptorUpdate)(CCCryptorRef cryptorRef, const void *dataIn, size_t dataInLength, void *dataOut,
         size_t dataOutAvailable, size_t *dataOutMoved);


static CCCryptorStatus replaced_CCCryptorUpdate(CCCryptorRef cryptorRef, const void *dataIn, size_t dataInLength, void *dataOut,
         size_t dataOutAvailable, size_t *dataOutMoved) {
    // TBD
    return original_CCCryptorUpdate(cryptorRef, dataIn, dataInLength, dataOut, dataOutAvailable, dataOutMoved);

}

@implementation CCCryptorHooks : NSObject 

+ (void)enableHooks {
     MSHookFunction((void *) CCCryptorCreate,(void *)  replaced_CCCryptorCreate, (void **) &original_CCCryptorCreate);
     MSHookFunction((void *) CCCryptorUpdate,(void *)  replaced_CCCryptorUpdate, (void **) &original_CCCryptorUpdate);
}

@end
