@interface CryptoTester : NSObject {
    
}

+ (void)runAllTests;

+ (void) testCommonHmac;
+ (void) testCommonDigest;
+ (void) testCommonCryptor;
+ (void) testCommonKeyDerivation;

@end

