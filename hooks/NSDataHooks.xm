/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/



%hook NSData

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:atomically:"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromBOOL:flag withKey:@"flag"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, flag);
}

- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:options:error:"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInteger:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

- (BOOL)writeToURL:(NSURL *)aURL atomically:(BOOL)flag {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL:"];
	[tracer addArgFromURL:aURL withKey:@"aURL"];
	[tracer addArgFromBOOL:flag withKey:@"flag"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL, flag);
}

- (BOOL)writeToURL:(NSURL *)aURL options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL:options:error:"];
	[tracer addArgFromURL:aURL withKey:@"aURL"];
	[tracer addArgFromInteger:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL, mask, errorPtr);
}

+ (id)dataWithContentsOfFile:(NSString *)path {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile:"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

+ (id)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile:options:error:"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInteger:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL:"];
	[tracer addArgFromURL:aURL withKey:@"aURL"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL);
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL:options:error:"];
	[tracer addArgFromURL:aURL withKey:@"aURL"];
	[tracer addArgFromInteger:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL, mask, errorPtr);
}

- (id)initWithContentsOfFile:(NSString *)path {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile:"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

- (id)initWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile:options:error:"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInteger:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

- (id)initWithContentsOfURL:(NSURL *)aURL {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL:"];
	[tracer addArgFromURL:aURL withKey:@"aURL"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL);
}

- (id)initWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL:options:error:"];
	[tracer addArgFromURL:aURL withKey:@"aURL"];
	[tracer addArgFromInteger:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL, mask, errorPtr);
}


%end
