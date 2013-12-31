/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


%hook UIApplication


- (void)setDelegate: (id)delegate {
	// Proxy the delegate so we can hook it
	UIApplicationDelegateProx *delegateProxy = [[UIApplicationDelegateProx alloc] initWithOriginalDelegate:delegate];
	%orig(delegateProxy);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIApplication" andMethod:@"setDelegate:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertDelegate:delegate followingProtocol:@"UIApplicationDelegate"] withKey:@"delegate"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}


%end

/* vim: set filetype=objc : */
