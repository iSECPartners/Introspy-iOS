
#import "NSURLConnectionDelegateProx.h"
#import "../SQLiteStorage.h"
#import "../PlistObjectConverter.h"


// Nice global
extern SQLiteStorage *traceStorage;


@implementation NSURLConnectionDelegateProx


@synthesize originalDelegate;


- (NSURLConnectionDelegateProx*) initWithOriginalDelegate:(id)origDeleg {
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


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    id origResult = [originalDelegate connection:connection willCacheResponse:cachedResponse];
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:willCacheResponse:"];
    [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) connection] withKey:@"connection"];
    [tracer addArgFromPlistObject:[PlistObjectConverter convertNSCachedURLResponse: cachedResponse] withKey:@"cachedResponse"];
    [tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSCachedURLResponse:origResult]];
    [traceStorage saveTracedCall:tracer];
    [tracer release];
    return origResult;
}


- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    id origResult = [originalDelegate connection:connection willSendRequest:request redirectResponse:redirectResponse];
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:willSendRequest:redirectResponse:"];
    [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) connection] withKey:@"connection"];
    [tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
    [tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLResponse:redirectResponse] withKey:@"redirectResponse"];
    [tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSURLRequest:origResult]];
    [traceStorage saveTracedCall:tracer];
    [tracer release];
    return origResult;
}

@end
