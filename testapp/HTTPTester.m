#import "HTTPTester.h"

@implementation HTTPTester : NSObject

+ (void)runAllTests {
	[self testNSURLConnectionClassMethods];
	[self testNSURLConnectionInstanceMethods];
}

+ (void)testNSURLConnectionClassMethods {
	NSURLConnection *conn = [NSURLConnection connectionWithRequest:
					  [NSURLRequest requestWithURL:
						  [NSURL URLWithString:@"https://www.isecpartners.com/?method=connectionWithRequest"]]
					 		      delegate:self];
	[conn release];

	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL:
						 	  [NSURL URLWithString:@"https://www.isecpartners.com/?method=sendAsynchronousRequest"]]
				 	   queue:queue
			       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) { }];
	[queue release];

	NSError *error = nil;
	NSURLResponse *response = nil;
	[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:
						  	[NSURL URLWithString:@"https://www.isecpartners.com/?method=sendSynchronousRequest"]]
							   returningResponse:&response
								       error:&error];
	[response release];
	[error release];
}

+ (void)testNSURLConnectionInstanceMethods {
	NSURLConnectionDelegate1* deleg1 = [[NSURLConnectionDelegate1 alloc] init];
	NSURLConnection *conn = [[NSURLConnection alloc] init];
	[conn initWithRequest:[NSURLRequest requestWithURL:
				      [NSURL URLWithString:@"https://www.isecpartners.com/?method=initWithRequest:delegate:"]]
		     delegate:deleg1];
	[conn start];
	[conn release];
	[deleg1 release];

	NSURLConnectionDelegate2* deleg2 = [[NSURLConnectionDelegate2 alloc] init];
	NSURLConnection *conn2 = [[NSURLConnection alloc] init];
	[conn initWithRequest:[NSURLRequest requestWithURL:
				      [NSURL URLWithString:@"https://www.isecpartners.com/?method=initWithRequest:delegate:startImmediately:"]]
		     delegate:deleg2
	     startImmediately:YES];
	[conn2 release];
	[deleg2 release];
}

@end


// Helpers classes for NSURLConnection testing
@implementation NSURLConnectionDelegate1 : NSObject
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    // Disable cert validation #1
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
}
@end

@implementation NSURLConnectionDelegate2 : NSObject
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

    // Disable cert validation #2
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // Now accept the certificate and send the response to the real challenge.sender
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
        }
}
@end
