#import "PasteboardTester.h"

@implementation PasteboardTester : NSObject

+ (void)runAllTests {
	[self testUIPasteboardClassMethods];
}

+ (void) testUIPasteboardClassMethods {
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	NSString *testString = @"testing general pasteboard hooks";
	[pb setValue:testString forPasteboardType:@"public.text"];
	[pb release];

	UIPasteboard *pb_named = [UIPasteboard pasteboardWithName:@"introspy_pb" create:YES];
	NSString *testString2 = @"testing named pasteboard hooks";
	[pb_named setValue:testString2 forPasteboardType:@"public.text"];
	[pb_named release];

	UIPasteboard *pb_unique = [UIPasteboard pasteboardWithUniqueName];
	NSString *testString3 = @"testing unique pasteboard hooks";
	[pb_unique setValue:testString3 forPasteboardType:@"public.text"];
	[pb_unique release];
}
@end
