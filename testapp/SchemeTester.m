#import "SchemeTester.h"

@implementation SchemeTester: NSObject

+ (void)runAllTests {
	[self testUIApplicationDelegateInstanceMethods];
}

+ (void)testUIApplicationDelegateInstanceMethods {
	// test the current (>= iOS 4.2) workflow
	UIApplication *introspy_test = [UIApplication sharedApplication];
	NSURL *scheme_path = [NSURL URLWithString:@"scheme1://public/url/scheme?method=application:openURL:sourceApplication:annotation:"];
	[introspy_test openURL:scheme_path];
}

@end
