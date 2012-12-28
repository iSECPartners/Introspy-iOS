/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/



%hook NSData

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag {
	BOOL origResult = %orig(path, flag);
	// NSData methods are called a lot by other iOS APIs and we don't want to log that
    if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:atomically:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addArgFromPlistObject:[NSNumber numberWithBool: flag] withKey:@"flag"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithBool: origResult]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	BOOL origResult = %orig(path, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:options:error:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger: mask] withKey:@"mask"];
		// For now let's just store the pointer value of the errorPtr parameter
		[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) errorPtr] withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithBool: origResult]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (BOOL)writeToURL:(NSURL *)aURL atomically:(BOOL)flag {
	BOOL origResult = %orig(aURL, flag);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL:atomically:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addArgFromPlistObject:[NSNumber numberWithBool: flag] withKey:@"flag"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithBool: origResult]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (BOOL)writeToURL:(NSURL *)aURL options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	BOOL origResult = %orig(aURL, mask, errorPtr);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL:options:error:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) errorPtr] withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithBool: origResult]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

+ (id)dataWithContentsOfFile:(NSString *)path {
	id origResult = %orig(path);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		// origResult should be NSData* ?
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

+ (id)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	id origResult = %orig(path, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile:options:error:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) errorPtr] withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL {
	id origResult = %orig(aURL);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	id origResult = %orig(aURL, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL:options:error:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) errorPtr] withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (id)initWithContentsOfFile:(NSString *)path {
	id origResult = %orig(path);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (id)initWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	id origResult = %orig(path, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile:options:error:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) errorPtr] withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (id)initWithContentsOfURL:(NSURL *)aURL {
	id origResult = %orig(aURL);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (id)initWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	id origResult = %orig(aURL, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL:options:error:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) errorPtr] withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}


%end
