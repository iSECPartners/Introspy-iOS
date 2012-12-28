#import "CCCryptorTester.h"
#include <CommonCrypto/CommonCryptor.h>


@implementation CCCryptorTester : NSObject 


static char testKey[16] = "Key 123";
static char testIv[16] = "IVIVIVIV";
static char testData[16] = "s3cret 123";


+ (void)runAllTests {

    [self testCCCrypt];
}


+ (void) testCCCrypt {
    char dataOut[16];
    size_t dataOutMoved;
     
    // CCCrypt() will call Create(), Update() and Final() in one shot
    CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, testKey, 16, testIv, testData, 16, dataOut, 16, &dataOutMoved);

}

@end
