#import "KeyChainTester.h"
#include <Security/Security.h>

@implementation KeyChainTester : NSObject 


// Testing settings
static NSString *keyChainTestKey = @"IntrospyPassword";
static NSString *keyChainTestValue1 = @"s3cr3t";
static NSString *keyChainTestValue2 = @"p@ssw0rd";



+ (void)runAllTests {

    [self testKeyChain];
    [self testSecPKCS12Import];
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
    CFTypeRef *result=NULL;
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


+ (void)testSecPKCS12Import {
    
    // Open the PKCS12 file
    NSString *clientCertPath = [[NSString alloc] initWithFormat:@"%@/introspy.p12", [[NSBundle mainBundle] bundlePath]];
    NSData *clientCertData = [[NSData alloc] initWithContentsOfFile:clientCertPath];

    if ([clientCertData length] == 0) {
        NSLog(@"CLIENT CERT NOT FOUND, PATH:%@", clientCertPath);
    }
    else {
        const void *keys[] =   { kSecImportExportPassphrase };
        const void *values[] = { (CFStringRef) @"test" };
        CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
        CFArrayRef items = NULL;
        
        // Load the client cert and private key
        if (SecPKCS12Import((CFDataRef) clientCertData, optionsDictionary, &items) == 0) {

            SecIdentityRef clientIdentity;
            CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
            clientIdentity = (SecIdentityRef) CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        
            // Print the cert's summary
            SecCertificateRef clientCertRef;
            SecIdentityCopyCertificate(clientIdentity, &clientCertRef);
            NSString *clientCertSummary = (NSString*) SecCertificateCopySubjectSummary(clientCertRef);
            NSLog(@"LOADED CERT: %@", clientCertSummary);
            CFRelease(clientCertRef);
            [clientCertSummary release];

            // Store the cert and private key (twice) in the keychain with kSecAttrAccessibleAlways
            NSMutableDictionary *certAddDict = [self newKeyChainSearchDict];
            [certAddDict setObject:(id)kSecClassIdentity forKey:(id)kSecClass];
            [certAddDict setObject:(id)clientIdentity forKey:(id)kSecValueRef];
            [certAddDict setObject:(id)kSecAttrAccessibleAlways forKey:(id)kSecAttrAccessible];
            SecItemAdd((CFDictionaryRef)certAddDict, NULL);

            NSMutableDictionary *certAddDict2 = [self newKeyChainSearchDict];
            [certAddDict2 setObject:(id)kSecClassIdentity forKey:(id)kSecClass];
            [certAddDict2 setObject:(id)kSecAttrAccessibleAlways forKey:(id)kSecAttrAccessible];
            [certAddDict2 setObject:(id)clientIdentity forKey:(id)kSecValuePersistentRef];
            SecItemAdd((CFDictionaryRef)certAddDict, NULL);

            // Update the cert and private key - code will not work but we're only testing the hook
            SecItemUpdate((CFDictionaryRef) [self newKeyChainSearchDict], (CFDictionaryRef) certAddDict);


            [certAddDict release];
        }

        if (optionsDictionary)
            CFRelease(optionsDictionary);

        if (items)
            CFRelease(items);
    }

    [clientCertData release];
    [clientCertPath release];
}

@end
