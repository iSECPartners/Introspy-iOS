@interface SchemeTester: NSObject {
}

+ (void)runAllTests;
+ (void)testUIApplicationDelegateInstanceMethods;

@end

@interface UIApplicationDelegateTester: NSObject {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

@interface UIApplicationDelegateTester1: UIApplicationDelegateTester {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end

@interface UIApplicationDelegateTester2: UIApplicationDelegateTester {
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

@end

