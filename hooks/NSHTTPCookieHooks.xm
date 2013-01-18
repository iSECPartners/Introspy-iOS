/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/

%hook NSHTTPCookie

// No need to hook +cookieWithProperties: because it just calls –initWithProperties: 


// This might be unnecessary. We should see the cookies getting created as we hook the constructor.
// TODO: Double check
#if 0
+ (NSArray *)cookiesWithResponseHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)theURL {
	NSArray *origResult = %orig(headerFields, theURL);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSHTTPCookie" andMethod:@"cookiesWithResponseHeaderFields:forURL:"];
	[tracer addArgFromPlistObject:headerFields withKey:@"headerFields"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL:theURL] withKey:@"theURL"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}
#endif 


- (id)initWithProperties:(NSDictionary *)properties {
	id origResult = %orig(properties);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSHTTPCookie" andMethod:@"initWithProperties:"];
	[tracer addArgFromPlistObject:properties withKey:@"properties"];
	[tracer addReturnValueFromPlistObject:[PlistObjectConverter convertNSHTTPCookie:origResult]];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

%end

/* vim: set filetype=objc : */
