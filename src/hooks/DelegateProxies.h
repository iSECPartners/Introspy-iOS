#import <UIKit/UIApplication.h>

@interface GenericDelegateProx : NSObject {
    id originalDelegate;        // The delegate object we're going to proxy
}

@property (retain) id originalDelegate; // Need retain or the delegate gets freed before we're done using it.


- (id) initWithOriginalDelegate:(id)origDeleg;

// Mirror the original delegate's list of implemented methods
- (BOOL)respondsToSelector:(SEL)aSelector;
- (id)forwardingTargetForSelector:(SEL)sel;
- (void)dealloc;

@end


@interface UIApplicationDelegateProx : GenericDelegateProx <UIApplicationDelegate>

// What we actually hook within UIApplicationDelegate
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end


@interface NSURLConnectionDelegateProx : GenericDelegateProx <NSURLConnectionDelegate>

// What we actually hook within NSURLConnectionDelegate
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;

@end

