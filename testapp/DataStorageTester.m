#import "DataStorageTester.h"


@implementation DataStorageTester : NSObject 


// Testing settings
static NSString *testFilePath = @"introspytest.file";
static NSString *testContentStr = @"introspy testing 12345";


// Internal stuff
static NSURL *testURL;
static NSData *testContent;


- (DataStorageTester *)init {
    self = [super init];
    testURL = [NSURL fileURLWithPath:testFilePath];
    testContent = [testContentStr dataUsingEncoding: [NSString defaultCStringEncoding]];
    return self;
}


- (void)runTests {
    
    NSLog(@"**************Test**************");
    [self testNSFileManager];
    [self testNSData];
}


- (void)testNSFileManager {

    NSFileManager * fileManager = [NSFileManager defaultManager];

    // Test createFileAtPath:contents:attributes:
    //NSDictionary attributes;
    [fileManager createFileAtPath:testFilePath contents:testContent attributes:nil];
    
    // Test ubiquityIdentityToken - iOS 6 only
    if([fileManager respondsToSelector:@selector(ubiquityIdentityToken)]) {
        [fileManager ubiquityIdentityToken];
    }

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
