#import "NSURLConnectionTester.h"

@implementation NSURLConnectionTester : NSObject

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
	NSURLConnection *conn = [[NSURLConnection alloc] init];
	[conn initWithRequest:[NSURLRequest requestWithURL:
				      [NSURL URLWithString:@"https://www.isecpartners.com/?method=initWithRequest:delegate:"]]
		     delegate:self];
	[conn release];

	NSURLConnection *conn2 = [[NSURLConnection alloc] init];
	[conn initWithRequest:[NSURLRequest requestWithURL:
				      [NSURL URLWithString:@"https://www.isecpartners.com/?method=initWithRequest:delegate:startImmediately:"]]
		     delegate:self
	     startImmediately:YES];
	[conn2 release];
}
@end
