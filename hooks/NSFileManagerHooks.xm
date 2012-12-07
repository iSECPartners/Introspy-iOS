/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


// NSFileManager ends up calling NSData methods that we hook as well. Is it useful to hook NSFileManager then ?


%hook NSFileManager

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)contents attributes:(NSDictionary *) attributes {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"createFileAtPath:contents:attributes:"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromData:contents withKey:@"contents"];
	[tracer addArgFromDictionary:attributes withKey:@"attributes"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, contents, attributes);
}

- (NSData *)contentsAtPath:(NSString *)path {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"contentsAtPath:"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

- (id <NSObject, NSCopying, NSCoding>)ubiquityIdentityToken {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"ubiquityIdentityToken"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig;
}

%end
