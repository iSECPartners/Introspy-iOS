@interface HTTPTester: NSObject {

}

+ (void)runAllTests;
+ (void)testNSURLConnectionClassMethods;
+ (void)testNSURLConnectionInstanceMethods;
+ (void) testNSHTTPCookie;
+ (void)testNSURLCredential;

@end


@interface NSURLConnectionDelegateTester: NSObject {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;
@end

@interface NSURLConnectionDelegateTester1: NSURLConnectionDelegateTester {
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end


@interface NSURLConnectionDelegateTester2: NSURLConnectionDelegateTester {
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end