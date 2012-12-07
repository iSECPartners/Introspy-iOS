@interface DataStorageTester : NSObject {
    
}

- (DataStorageTester *)init;
- (void)runAllTests;

- (NSMutableDictionary *)newKeyChainSearchDict;
- (void)testNSFileHandle;
- (void)testKeyChain;
- (void)testNSUserDefaults;
- (void)testNSFileManager;
- (void)testNSData;

@end

