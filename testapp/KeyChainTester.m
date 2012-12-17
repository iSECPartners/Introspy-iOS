#import "KeyChainTester.h"
#include <Security/Security.h>

@implementation KeyChainTester : NSObject 


// Testing settings
static NSString *keyChainTestKey = @"IntrospyPassword";
static NSString *keyChainTestValue1 = @"s3cr3t";
static NSString *keyChainTestValue2 = @"p@ssw0rd";



+ (void)runAllTests {

    [self testKeyChain];
}


// Utility function for the keyChain tests
+ (NSMutableDictionary *)newKeyChainSearchDict {

    NSString *appId = [[NSBundle mainBundle] bundleIdentifier];
    NSData *testKey = [keyChainTestKey dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];

    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [searchDictionary setObject:testKey forKey:(id)kSecAttrGeneric];
    [searchDictionary setObject:testKey forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:appId forKey:(id)kSecAttrService];

  return searchDictionary;
}


+ (void)testKeyChain {
    
    NSData *testValue1 = [keyChainTestValue1 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *testValue2 = [keyChainTestValue2 dataUsingEncoding:NSUTF8StringEncoding];

    // Test SecItemAdd()
    NSMutableDictionary *itemAddDict = [self newKeyChainSearchDict];
    [itemAddDict setObject:testValue1 forKey:(id)kSecValueData];
    [itemAddDict setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];
    SecItemAdd((CFDictionaryRef)itemAddDict, NULL);
    [itemAddDict release];

    // Test SecItemAdd() with default kSecAttrAccessible
    NSMutableDictionary *itemAddDict2 = [self newKeyChainSearchDict];
    [itemAddDict2 setObject:testValue1 forKey:(id)kSecValueData];
    //[itemAddDict setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];
    SecItemAdd((CFDictionaryRef)itemAddDict2, NULL);
    [itemAddDict2 release];

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

@end
