#import "XMLTester.h"

@implementation XMLTester {
    
}

+ (void)runAllTests {
    [self testNSXMLParser];
}

+ (void) testNSXMLParser {
    NSURL *testURL = [NSURL URLWithString:@"http://www.isecpartners.com"];
    NSXMLParser *testParser = [[NSXMLParser alloc] initWithContentsOfURL: testURL];
    [testParser setShouldResolveExternalEntities: YES];
    [testParser release];

    NSInputStream *testStream = [NSInputStream inputStreamWithURL:testURL];
    testParser = [[NSXMLParser alloc] initWithStream: testStream];
    [testParser release];

    NSData *testData = [NSData dataWithContentsOfURL:testURL];
    testParser = [[NSXMLParser alloc] initWithData: testData];
}

@end

