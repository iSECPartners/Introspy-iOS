#import "HTTPTester.h"

@implementation HTTPTester : NSObject

+ (void)runAllTests {
    [self testNSURLConnectionInstanceMethods];
	[self testNSURLConnectionClassMethods];
    [self testNSHTTPCookie];
    [self testNSURLCredential];
}


+ (void)testNSURLCredential {

    [[NSURLCredential alloc] initWithUser:@"User" password:@"S3cr3t" persistence:NSURLCredentialPersistencePermanent];
    [NSURLCredential credentialWithUser:@"User" password:@"S3cr3t" persistence:NSURLCredentialPersistencePermanent];

} 


+ (void)testNSURLConnectionClassMethods {
    [NSURLConnection connectionWithRequest: [NSURLRequest requestWithURL:
		  [NSURL URLWithString:@"https://www.google.com/?method=connectionWithRequest"]]
	   delegate:nil];

	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL:
			[NSURL URLWithString:@"https://www.google.com/?method=sendAsynchronousRequest"]]
		queue:queue
		completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) { }];

	NSError *error = nil;
	NSURLResponse *response = nil;
	[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:
			[NSURL URLWithString:@"https://www.google.com/?method=sendSynchronousRequest"]]
		returningResponse:&response
		error:&error];
}


+ (void)testNSURLConnectionInstanceMethods {
	NSURLConnectionDelegateTester1* deleg1 = [[NSURLConnectionDelegateTester1 alloc] init];
    // Connect over HTTP to trigger a redirection
	NSURLConnection *conn = [[NSURLConnection alloc] 
        initWithRequest:[NSURLRequest requestWithURL:
			[NSURL URLWithString:@"http://www.isecpartners.com/?method=initWithRequest:delegate:"]]
        delegate:deleg1];
    [deleg1 release]; // Give ownership to the connection
	[conn start];

	NSURLConnectionDelegateTester2* deleg2 = [[NSURLConnectionDelegateTester2 alloc] init];
	NSURLConnection *conn2 = [[NSURLConnection alloc]
	    initWithRequest:[NSURLRequest requestWithURL:
			[NSURL URLWithString:@"https://www.isecpartners.com/?method=initWithRequest:delegate:startImmediately:"]]
        delegate:deleg2
        startImmediately:NO];
    [conn2 start];
    [deleg2 release]; // Give ownership to the connection
}


+ (void)testNSHTTPCookie {

    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"www.isecpartners.com", NSHTTPCookieDomain,
                                    @"\test", NSHTTPCookiePath,
                                    @"testCookies", NSHTTPCookieName,
                                    @"1", NSHTTPCookieValue,
                                    nil];
    [NSHTTPCookie cookieWithProperties:properties];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    [cookie release];
}

@end



// Helpers classes for NSURLConnection and NSURLConnectionDelegate testing
@implementation NSURLConnectionDelegateTester
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    return request;
}
@end


@implementation NSURLConnectionDelegateTester1
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // Disable cert validation #1
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
}
@end


@implementation NSURLConnectionDelegateTester2
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // Disable cert validation #2
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // Accept the certificate
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
        }
}
@end
