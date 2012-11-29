#import "CallTracer.h"

%group DataStorage

%hook NSFileManager

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)contents attributes:(NSDictionary *) attributes {
	%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"createFileAtPath:contents:attributes"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromData:contents withKey:@"contents"];
	[tracer addArgFromDictionary:attributes withKey:@"attributes"];
	[tracer release];
	return %orig(path, contents, attributes);
}

- (NSData *)contentsAtPath:(NSString *)path {
	%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"contentsAtPath"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer release];
	return %orig(path);
}

- (id <NSObject, NSCopying, NSCoding>)ubiquityIdentityToken {
	%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"ubiquityIdentityToken"];
	[tracer release];
	return %orig;
}

%end

%hook NSData

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag {
	%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:atomically"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromBool:flag withKey:@"flag"];
	[tracer release];
	return %orig(path, flag);
}

- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:options:error"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

- (BOOL)writeToURL:(NSURL *)aURL atomically:(BOOL)flag {
	%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL"];
	[tracer addArgFromUrl:aURL withKey:@"aURL"];
	[tracer addArgFromBool:flag withKey:@"flag"];
	[tracer release];
	return %orig(aURL, flag);
}

- (BOOL)writeToURL:(NSURL *)aURL options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL:options:error"];
	[tracer addArgFromUrl:aURL withKey:@"aURL"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[tracer release];
	return %orig(aURL, mask, errorPtr);
}

+ (id)dataWithContentsOfFile:(NSString *)path {
	%log
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer release];
	return %orig(path);
}

+ (id)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	%Log
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile:options:error"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL {
	%log
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL"];
	[tracer addArgFromUrl:path withKey:@"aURL"];
	[tracer release];
	return %orig(path);
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	%Log
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL:options:error"];
	[tracer addArgFromURL:path withKey:@"aURL"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

- (id)initWithContentsOfFile:(NSString *)path {
	%log
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer release];
	return %orig(path);
}

- (id)initWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	%Log
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile:options:error"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

- (id)initWithContentsOfURL:(NSURL *)aURL {
	%log
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL"];
	[tracer addArgFromUrl:path withKey:@"aURL"];
	[tracer release];
	return %orig(path);
}

- (id)initWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	%Log
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL:options:error"];
	[tracer addArgFromURL:path withKey:@"aURL"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

%end

%end

%ctor {
    %init(DataStorage);
}
