@interface FileSystemTester : NSObject {
    
}

- (FileSystemTester *)init;
- (void)runAllTests;

- (void)testNSFileHandle;
- (void)testNSFileManager;
- (void)testNSData;
- (void)testNSInputStream;
- (void)testNSOutputStream;

@end

