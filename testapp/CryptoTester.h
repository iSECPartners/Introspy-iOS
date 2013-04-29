@interface CryptoTester : NSObject {
    
}

+ (void)runAllTests;

+ (void) testCCHmac;
+ (void) testCC_MD5;
+ (void) testCCCryptor;
+ (void) testCCKeyDerivationPBKDF;

@end

