
#import "UIApplicationDelegateProx.h"
#import "../SQLiteStorage.h"
#import "../PlistObjectConverter.h"


// Nice global
extern SQLiteStorage *traceStorage;


@implementation UIApplicationDelegateProx


@synthesize originalDelegate;


- (UIApplicationDelegateProx*) initWithOriginalDelegate:(id)origDeleg {
    self = [super init];

    if (self) { // Store original delegate
        [self setOriginalDelegate:(origDeleg)];
    }
    return self;
}


- (BOOL)respondsToSelector:(SEL)aSelector {
    return [originalDelegate respondsToSelector:aSelector];
}


- (id)forwardingTargetForSelector:(SEL)sel {
    return originalDelegate;
}


- (void)dealloc {
    [originalDelegate release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL origResult = [originalDelegate application:application handleOpenURL:url];
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIApplicationDelegate" andMethod:@"application:handleOpenURL:"];
    [tracer addArgFromPlistObject:@"Introspy - not implemented" withKey:@"application"];
    [tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithBool:origResult]];
    [traceStorage saveTracedCall:tracer];
    [tracer release];
    return origResult;
    }


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL origResult = [originalDelegate application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIApplicationDelegate" andMethod:@"application:openURL:sourceApplication:annotation:"];
    [tracer addArgFromPlistObject:@"Introspy - not implemented" withKey:@"application"];
    [tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
    [tracer addArgFromPlistObject:sourceApplication withKey:@"sourceApplication"];
    [tracer addArgFromPlistObject:annotation withKey:@"annotation"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithBool:origResult]];
    [traceStorage saveTracedCall:tracer];
    [tracer release];
    return origResult;
}

@end
