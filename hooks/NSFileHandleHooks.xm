/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


%hook NSFileHandle

+ (id)fileHandleForReadingAtPath:(NSString *)path {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForReadingAtPath:"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);	
}

+ (id)fileHandleForReadingFromURL:(NSURL *)url error:(NSError **)error {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForReadingFromURL:error:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(url, error);
}

+ (id)fileHandleForUpdatingAtPath:(NSString *)path {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForUpdatingAtPath:"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

+ (id)fileHandleForUpdatingURL:(NSURL *)url error:(NSError **)error {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForUpdatingURL:error:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(url, error);
}

+ (id)fileHandleForWritingAtPath:(NSString *)path {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingAtPath:"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

+ (id)fileHandleForWritingToURL:(NSURL *)url error:(NSError **)error {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingToURL:error:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(url, error);
}

%end
