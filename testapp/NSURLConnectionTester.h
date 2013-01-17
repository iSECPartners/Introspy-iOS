@interface NSURLConnectionTester: NSObject {

}

+ (void)runAllTests;
+ (void)testNSURLConnectionClassMethods;
+ (void)testNSURLConnectionInstanceMethods;

@end


@interface NSURLConnectionDelegate1: NSObject {
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end


@interface NSURLConnectionDelegate2: NSObject {
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end