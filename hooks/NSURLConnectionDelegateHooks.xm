/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/

// TODO: NSURLConnectionDelegate is not a class but a protocol that any class can choose to implement.
// We need to figure out at runtime the class that's actually implementing this protocol.
// We could use that to detect basic auth and SSL client auth I think. Possibly dump the passwords/certs.

#if 0
%hook NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	%orig(connection, response);
	// TODO: do we actually want anything from this? the response data is in
	// connection:didReceiveData: ...
	return;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	%orig(connection, data);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:didReceiveData:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:[connection currentRequest]] withKey:@"connection"];
	[tracer addArgFromPlistObject:data withKey:@"data"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	%orig(connection, challenge);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:didReceiveAuthenticationChallenge:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:[connection currentRequest]] withKey:@"connection"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLAuthenticationChallenge:challenge] withKey:@"challenge"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	%orig(connection, challenge);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:willSendRequestForAuthenticationChallenge:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:[connection currentRequest]] withKey:@"connection"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLAuthenticationChallenge:challenge] withKey:@"challenge"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}

%end
#endif
/* vim: set filetype=objc : */
