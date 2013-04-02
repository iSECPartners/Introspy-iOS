#import "RootViewController.h"

@interface IntrospyTestAppApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
}
@property (nonatomic, retain) UIWindow *window;
@end

@implementation IntrospyTestAppApplication
@synthesize window = _window;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_viewController = [[RootViewController alloc] init];
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];
	return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return YES;
}

//- (void)applicationDidFinishLaunching:(UIApplication *)application {
//	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//	_viewController = [[RootViewController alloc] init];
//	[_window addSubview:_viewController.view];
//	[_window makeKeyAndVisible];
//}

- (void)dealloc {
	[_viewController release];
	[_window release];
	[super dealloc];
}
@end

// vim:ft=objc
