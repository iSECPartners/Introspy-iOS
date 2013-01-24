/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/

%hook NSURLConnection

// Not hooking these methods:
// + connectionWithRequest:delegate: ends up calling initWithRequest:delegate:
// + sendAsynchronousRequest:queue:completionHandler: ends up calling sendSynchronousRequest:returningResponse:error:

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
	NSData *origResult = %orig(request, response, error);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"sendSynchronousRequest:returningResponse:error:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt:(unsigned int)response] withKey:@"response"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt:(unsigned int)error] withKey:@"error"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {
	// Initialize Delegate hooks when the connection starts	
	Class delegateClass = [delegate class] ?: [self class];
	%init(NSURLConnectionDelegateHooks1, NSURLConnectionDelegate = delegateClass);

	id origResult = %orig(request, delegate);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"initWithRequest:delegate:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt:(unsigned int)delegate] withKey:@"delegate"];
	// doesn't like CFType in the plist -- we can parse it if we need to tho
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately {
	// Initialize Delegate hooks when the connection starts	
	Class delegateClass = [delegate class] ?: [self class];
	%init(NSURLConnectionDelegateHooks2, NSURLConnectionDelegate = delegateClass);

	id origResult = %orig(request, delegate, startImmediately);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"initWithRequest:delegate:startImmediately:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt:(unsigned int)delegate] withKey:@"delegate"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool:startImmediately] withKey:@"startImmediately"];
	// doesn't like CFType in the plist -- we can parse it if we need to tho
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}


// The following methods are not explicitely part of NSURLConnection.
// However, when implementing custom cert validation using the NSURLConnectionDelegate protocol,
// the application sends the result of the validation (server cert was OK/bad) to [challenge sender].
// The class of [challenge sender] is NSURLConnection because it implements the NSURLAuthenticationChallengeSender
// protocol. So we're hooking this in order to find when the validation might have been disabled.

// The usual way of disabling SSL cert validation
- (void)continueWithoutCredentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	%orig(challenge);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"continueWithoutCredentialForAuthenticationChallenge:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLAuthenticationChallenge: challenge] withKey:@"challenge"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
}

// Might indicate client certificates or cert pinning. TODO: Investigate
- (void)useCredential:(NSURLCredential *)credential forAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	%orig(credential, challenge);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"useCredential:forAuthenticationChallenge:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt:(unsigned int)credential] withKey:@"credential"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLAuthenticationChallenge: challenge] withKey:@"challenge"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
}

%end

/* vim: set filetype=objc : */
