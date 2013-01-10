/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/

%hook NSURLConnection

+ (NSURLConnection *)connectionWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {
	NSURLConnection *origResult = %orig(request, delegate);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"connectionWithRequst:delegate"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	//  we'll hook NSURLConnectionDelegate seperately so no need to extract the info here.
	//  TODO: but do we want anything out of the NSURLConnection returned?
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {
	%orig(request, queue, handler);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"sendAsynchronousRequest:queue:completionHandler:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:[queue name] withKey:@"queue"];
	// TODO: do we want to extract any infoz about the handler?
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
	NSData *origResult = %orig(request, response, error);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"sendAsynchronousRequest:returningResponse:error:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {
	id origResult = %orig(request, delegate);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"initWithRequest:delegate:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	// doesn't like CFType in the plist -- we can parse it if we need to tho
//	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately {
	id origResult = %orig(request, delegate, startImmediately);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"initWithRequest:delegate:startImmediately:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool:startImmediately] withKey:@"startImmediately"];
	// doesn't like CFType in the plist -- we can parse it if we need to tho
//	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

%end

/* vim: set filetype=objc : */
