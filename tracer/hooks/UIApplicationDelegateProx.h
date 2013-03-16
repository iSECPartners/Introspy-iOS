
@interface UIApplicationDelegateProx : NSObject <UIApplicationDelegate> {
    id originalDelegate;        // The UIApplicationDelegate we're going to proxy
}

@property (retain) id originalDelegate; // Need retain or the delegate gets freed before we're done using it.


- (UIApplicationDelegateProx*) initWithOriginalDelegate:(id)origDeleg;

// Mirror the original delegate's list of implemented methods
- (BOOL)respondsToSelector:(SEL)aSelector;
- (id)forwardingTargetForSelector:(SEL)sel;
- (void)dealloc;

// What we actually hook
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end

