#import "SchemeTester.h"

@implementation SchemeTester: NSObject

+ (void)runAllTests {
	[self testUIApplicationDelegateInstanceMethods];
}

+ (void)testUIApplicationDelegateInstanceMethods {
	// test the current (>= iOS 4.2) workflow
	UIApplicationDelegateTester1* deleg1 = [[UIApplicationDelegateTester1 alloc] init];
	NSURLConnection *conn1 = [[NSURLConnection alloc]
		initWithRequest:[NSURLRequest requestWithURL:
	   [NSURL URLWithString:@"scheme1://public/url/scheme?method=application:openURL:sourceApplication:annotation:"]]
		       delegate:deleg1];
	[deleg1 release];
	[conn1 start];

	// test the deprecated (<= iOS 4.1) workflow
	UIApplicationDelegateTester2* deleg2 = [[UIApplicationDelegateTester1 alloc] init];
	NSURLConnection *conn2 = [[NSURLConnection alloc]
		initWithRequest:[NSURLRequest requestWithURL:
	   [NSURL URLWithString:@"scheme1://public/url/scheme?method=application:handleOpenURL:"]]
		       delegate:deleg2];
	[deleg2 release];
	[conn2 start];
}

@end

@implementation UIApplicationDelegateTester

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	return YES;
}

@end

@implementation UIApplicationDelegateTester1

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return YES;
}

@end

@implementation UIApplicationDelegateTester2

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return YES;
}

@end
