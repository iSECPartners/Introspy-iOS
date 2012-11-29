@interface DataStorageTester : NSObject {



}

- (DataStorageTester *)init;
- (void)runTests;

- (void)testNSFileManager;
- (void)testNSData;

@end

