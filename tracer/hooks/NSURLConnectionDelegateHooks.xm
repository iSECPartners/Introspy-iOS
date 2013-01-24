/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/



%hook NSURLConnectionDelegate


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	id origResult = %orig(connection, cachedResponse);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:willCacheResponse:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) connection] withKey:@"connection"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSCachedURLResponse: cachedResponse] withKey:@"cachedResponse"];
	[tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSCachedURLResponse:origResult]];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	id origResult = %orig(connection, request, redirectResponse);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:willSendRequest:redirectResponse:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) connection] withKey:@"connection"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLResponse:redirectResponse] withKey:@"redirectResponse"];
	[tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSURLRequest:origResult]];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

#if 0
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
#endif
%end

/* vim: set filetype=objc : */
