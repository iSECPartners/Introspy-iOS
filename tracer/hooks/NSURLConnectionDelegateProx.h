
@interface NSURLConnectionDelegateProx : NSObject <NSURLConnectionDelegate> {
    id originalDelegate;        // The NSURLConnectionDelegate we're going to proxy
}

@property (retain) id originalDelegate; // Need retain or the delegate gets freed before we're done using it.


- (NSURLConnectionDelegateProx*) initWithOriginalDelegate:(id)origDeleg;

// Mirror the original delegate's list of implemented methods
- (BOOL)respondsToSelector:(SEL)aSelector;
- (id)forwardingTargetForSelector:(SEL)sel;
- (void)dealloc;

// What we actually hook
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;

@end

