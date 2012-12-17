#import "FileSystemTester.h"
#include <Security/Security.h>

@implementation FileSystemTester : NSObject 


// Testing settings
static NSString *testFilePath = @"~/introspytest.file";
static NSString *testContentStr = @"introspy testing 12345";


// Internal stuff
static NSURL *testURL;
static NSData *testContent;


- (FileSystemTester *)init {
    self = [super init];
    testFilePath = [testFilePath stringByExpandingTildeInPath];
    testURL = [NSURL fileURLWithPath:testFilePath];
    testContent = [testContentStr dataUsingEncoding: [NSString defaultCStringEncoding]];
    return self;
}


- (void)runAllTests {

    [self testNSFileManager];
    [self testNSData];
    [self testNSFileHandle];
    [self testNSInputStream];
    [self testNSOutputStream];
}


- (void)testNSFileHandle {

    [NSFileHandle fileHandleForReadingAtPath:testFilePath];
    [NSFileHandle fileHandleForUpdatingAtPath:testFilePath];
    [NSFileHandle fileHandleForWritingAtPath:testFilePath];

    [NSFileHandle fileHandleForReadingFromURL:testURL error:nil];
    [NSFileHandle fileHandleForUpdatingURL:testURL error:nil];
    [NSFileHandle fileHandleForWritingToURL:testURL error:nil];
}


- (void)testNSOutputStream {
    NSOutputStream *testStream = [[NSOutputStream alloc] initToFileAtPath:testFilePath append:NO];
    [testStream release];

    NSOutputStream *testStream2 = [[NSOutputStream alloc] initWithURL:testURL append:NO];
    [testStream2 release];    

    [NSOutputStream outputStreamToFileAtPath:testFilePath append:NO];
    [NSOutputStream outputStreamWithURL:testURL append:NO];
}

- (void)testNSInputStream {
    NSInputStream *testStream = [[NSInputStream alloc] initWithFileAtPath:testFilePath];
    [testStream release];

    NSInputStream *testStream2 = [[NSInputStream alloc] initWithURL:testURL];
    [testStream2 release];    

    [NSInputStream inputStreamWithFileAtPath:testFilePath];
    [NSInputStream inputStreamWithURL:testURL];
}


- (void)testNSFileManager {

    NSFileManager * fileManager = [NSFileManager defaultManager];

    // Test createFileAtPath:contents:attributes:
    //NSDictionary attributes;
    [fileManager createFileAtPath:testFilePath contents:testContent attributes:nil];
    
    // Test ubiquityIdentityToken - iOS 6 only
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
    [fileManager ubiquityIdentityToken];
#endif

    // Test contentsAtPath:
    NSData* readContent = [fileManager contentsAtPath:testFilePath];
    [readContent length];
    
    // Cleanup
    [fileManager removeItemAtPath:testFilePath error:nil];
}


- (void)testNSData {

    // Test writeToFile:atomically:
    [testContent writeToFile:testFilePath atomically:YES];

    // Test writeToFile:options:error:
    [testContent writeToFile:testFilePath options:NSDataWritingFileProtectionNone error:nil];    

    // Test writeToURL:atomically:
    [testContent writeToURL:testURL atomically:YES];

    // Test writeToURL:options:error:
    [testContent writeToURL:testURL options:NSDataWritingFileProtectionNone error:nil]; 


    // Test dataWithContentsOfFile:
    NSData* readContent = [NSData dataWithContentsOfFile:testFilePath];

    // Test dataWithContentsOfFile:options:error:
    readContent = [NSData dataWithContentsOfFile: testFilePath options:NSDataReadingUncached error:nil];

    // Test dataWithContentsOfURL:
    readContent = [NSData dataWithContentsOfURL: testURL];

    // Test dataWithContentsOfURL:options:error:
    readContent = [NSData dataWithContentsOfURL:testURL options:NSDataReadingUncached error:nil];

    // Test initWithContentsOfFile:
    readContent = [[NSData alloc] initWithContentsOfFile:testFilePath];
    [readContent release];
   
   // Test initWithContentsOfFile:options:error:
    readContent = [[NSData alloc] initWithContentsOfFile:testFilePath options:NSDataReadingUncached error:nil];
    [readContent release];
   
   // Test initWithContentsOfURL:
    readContent = [[NSData alloc] initWithContentsOfURL:testURL];
    [readContent release];
   
   // Test initWithContentsOfURL:options:error:
    readContent = [[NSData alloc] initWithContentsOfURL:testURL options:NSDataReadingUncached error:nil];
    [readContent release];
   
    // Test dataWithContentsOfMappedFile
    readContent = [NSData dataWithContentsOfMappedFile:testFilePath];

   // Test initWithContentsOfMappedFile:
    readContent = [[NSData alloc] initWithContentsOfMappedFile:testFilePath];
    [readContent release];

    // Cleanup
    NSFileManager * fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:testFilePath error:nil];
}


@end
