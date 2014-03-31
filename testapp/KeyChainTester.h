@interface KeyChainTester : NSObject {
    
}
// TODO: Rename this class to SecurityTester as it tests the whole Security framework
+ (void)runAllTests;
+ (NSMutableDictionary *)newKeyChainSearchDict;
+ (void)testKeyChain;
+ (void)testSecPKCS12Import;


@end

