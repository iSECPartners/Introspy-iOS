/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/

%hook NSHTTPCookie

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

+ (id)cookieWithProperties:(NSDictionary *)properties {
	id origResult = %orig(properties);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSHTTPCookie" andMethod:@"cookieWithProperties:"];
	[tracer addArgFromPlistObject:properties withKey:@"properties"];
	[tracer addReturnValueFromPlistObject:[origResult properties]];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (id)initWithProperties:(NSDictionary *)properties {
	id origResult = %orig(properties);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSHTTPCookie" andMethod:@"initWithProperties:"];
	[tracer addArgFromPlistObject:properties withKey:@"properties"];
	[tracer addReturnValueFromPlistObject:[origResult properties]];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

%end

/* vim: set filetype=objc : */
