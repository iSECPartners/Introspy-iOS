@interface CryptoTester : NSObject {
    
}

+ (void)runAllTests;

+ (void) testCCHmac;
+ (void) testCCCryptor;
+ (void) testCCKeyDerivationPBKDF;

@end

