@interface CryptoTester : NSObject {
    
}

+ (void)runAllTests;

+ (void) testCommonHmac;
+ (void) testRand;
+ (void) testCommonDigest;
+ (void) testCommonCryptor;
+ (void) testCommonKeyDerivation;

@end

