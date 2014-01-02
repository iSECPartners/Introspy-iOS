#import "UserPreferencesTester.h"

@implementation UserPreferencesTester : NSObject 


+ (void)runAllTests {

    [self testNSUserDefaults];
}


+ (void)testNSUserDefaults {

    NSMutableString *testKey = [NSMutableString stringWithCapacity:15];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData* testContent = [@"testContent" dataUsingEncoding: [NSString defaultCStringEncoding]];
    NSURL * testURL = [NSURL fileURLWithPath:@"~/introspytest.file"];
    
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

@end
