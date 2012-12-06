@interface DataStorageTester : NSObject {
    
}

- (DataStorageTester *)init;
- (void)runTests;

- (NSMutableDictionary *)newKeyChainSearchDict;
- (void)testKeyChain;
- (void)testNSUserDefaults;
- (void)testNSFileManager;
- (void)testNSData;

@end

