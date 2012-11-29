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

%end

%end

%ctor {
    %init(DataStorage);
}
