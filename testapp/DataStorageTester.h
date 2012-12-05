@interface DataStorageTester : NSObject {



}

- (DataStorageTester *)init;
- (void)runTests;

- (void)testKeyChain;
- (void)testNSFileManager;
- (void)testNSData;

@end

