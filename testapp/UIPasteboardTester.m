#import "UIPasteboardTester.h"

@implementation UIPasteboardTester : NSObject

+ (void)runAllTests {
	[self testUIPasteboardClassMethods];
}

+ (void) testUIPasteboardClassMethods {
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	[pb release];

	UIPasteboard *pb_named = [UIPasteboard pasteboardWithName:@"introspy_pb" create:YES];
	[pb_named release];

	UIPasteboard *pb_unique = [UIPasteboard pasteboardWithUniqueName];
	[pb_unique release];
}
@end
