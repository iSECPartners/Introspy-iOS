#import "DataStorageTester.h"
#include <Security/Security.h>

@implementation DataStorageTester : NSObject 


// Testing settings
static NSString *testFilePath = @"~/introspytest.file";
static NSString *testContentStr = @"introspy testing 12345";
static NSString *keyChainTestKey = @"IntrospyPassword";
static NSString *keyChainTestValue1 = @"s3cr3t";
static NSString *keyChainTestValue2 = @"p@ssw0rd";


// Internal stuff
static NSURL *testURL;
static NSData *testContent;


- (DataStorageTester *)init {
    self = [super init];
    testFilePath = [testFilePath stringByExpandingTildeInPath];
    NSLog(@"TEST PATH = %@", [testFilePath stringByExpandingTildeInPath]);
    testURL = [NSURL fileURLWithPath:testFilePath];
    testContent = [testContentStr dataUsingEncoding: [NSString defaultCStringEncoding]];
    return self;
}


- (void)runAllTests {

    [self testKeyChain];
    [self testNSFileManager];
    [self testNSData];
    [self testNSUserDefaults];
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


// Utility function for the keyChain tests
- (NSMutableDictionary *)newKeyChainSearchDict {

    NSString *appId = [[NSBundle mainBundle] bundleIdentifier];
    NSData *testKey = [keyChainTestKey dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];

    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [searchDictionary setObject:testKey forKey:(id)kSecAttrGeneric];
    [searchDictionary setObject:testKey forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:appId forKey:(id)kSecAttrService];

  return searchDictionary;
}


- (void)testKeyChain {
    
    NSData *testValue1 = [keyChainTestValue1 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *testValue2 = [keyChainTestValue2 dataUsingEncoding:NSUTF8StringEncoding];

    // Test SecItemAdd()
    NSMutableDictionary *itemAddDict = [self newKeyChainSearchDict];
    [itemAddDict setObject:testValue1 forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)itemAddDict, NULL);
    [itemAddDict release];

    // Test SecItemCopyMatching()
    NSMutableDictionary *itemMatchDict = [self newKeyChainSearchDict];
    CFTypeRef *result;
    [itemMatchDict setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [itemMatchDict setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    SecItemCopyMatching((CFDictionaryRef)itemMatchDict, result);
    [itemMatchDict release];

    // Test SecItemUpdate()
    NSMutableDictionary *itemSearchDict = [self newKeyChainSearchDict];
    NSMutableDictionary *itemUpdateDict = [[NSMutableDictionary alloc] init];
    [itemUpdateDict setObject:testValue2 forKey:(id)kSecValueData];
    SecItemUpdate((CFDictionaryRef) itemSearchDict, (CFDictionaryRef) itemUpdateDict);
    [itemUpdateDict release];

    // Test SecItemDelete()
    SecItemDelete((CFDictionaryRef) itemSearchDict);
    [itemSearchDict release];
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

- (void)testNSUserDefaults {

    NSMutableString *testKey = [NSMutableString stringWithCapacity:15];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [testKey setString:@"testBool"];
    [defaults setBool:YES forKey:testKey];
    [defaults boolForKey:testKey];

    [testKey setString:@"testFloat"];
    [defaults setFloat:5.5 forKey:testKey];
    [defaults floatForKey:testKey];

    [testKey setString:@"testInt"];
    [defaults setInteger:1 forKey:testKey];
    [defaults integerForKey:testKey];

    [testKey setString:@"testDouble"];
    [defaults setDouble:1 forKey:testKey];
    [defaults doubleForKey:testKey];

    [testKey setString:@"testObject"];
    [defaults setObject:@"testString" forKey:testKey];
    [defaults objectForKey:testKey];
    [defaults stringForKey:testKey];

    NSArray *testArray;
    [testKey setString:@"testArray"];
    testArray = [NSArray arrayWithObjects:@"test1", @"test2", nil];
    [defaults setObject:testArray forKey:testKey];
    [defaults stringArrayForKey:testKey];
    [defaults arrayForKey:testKey];
    [defaults dictionaryForKey:testKey];
    
    [testKey setString:@"testData"];
    [defaults setObject:testContent forKey:testKey];
    [defaults dataForKey:testKey];

    [testKey setString:@"testURL"];
    [defaults setURL:testURL forKey:testKey];
    [defaults URLForKey:testKey];    
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
