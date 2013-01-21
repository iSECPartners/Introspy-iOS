#import "CryptoTester.h"
#include <CommonCrypto/CommonCryptor.h>
#include <CommonCrypto/CommonHmac.h>


@implementation CryptoTester 


static char testKey[16] = "Key 123";
static char testIv[16] = "IVIVIVIV";
static char testData[16] = "s3cret 123";


+ (void)runAllTests {

    [self testCCHmac];
    [self testCCCryptor];
}


+ (void) testCCHmac {
    char dataOut[16];
    CCHmacContext ctx;

    CCHmacInit(&ctx, kCCHmacAlgSHA1, testKey, 16);
    CCHmacUpdate(&ctx, testData, 16);
    CCHmacFinal(&ctx, dataOut);

    CCHmac(kCCHmacAlgSHA1, testKey, 16, testData, 16, dataOut);
}


+ (void) testCCCryptor {
    CCCryptorRef cryptorRef;
    char dataOut[16];
    size_t dataOutMoved;

    CCCryptorCreateFromData(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, 
        testKey, 16, testIv, testData, 16, &cryptorRef, &dataOutMoved);

    CCCryptorCreate(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, 
        testKey, 16, testIv, &cryptorRef);
    CCCryptorUpdate(cryptorRef,  testData, 16, dataOut, 0, &dataOutMoved);
    CCCryptorFinal(cryptorRef, dataOut, 16, &dataOutMoved);


    CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, testKey, 16, 
        testIv, testData, 16, dataOut, 16, &dataOutMoved);
}

@end
