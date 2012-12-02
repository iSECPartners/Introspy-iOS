#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"


static IntrospySQLiteStorage *traceStorage;

%group DataStorage

%hook NSFileManager

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)contents attributes:(NSDictionary *) attributes {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"createFileAtPath:contents:attributes"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromData:contents withKey:@"contents"];
	[tracer addArgFromDictionary:attributes withKey:@"attributes"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, contents, attributes);
}

- (NSData *)contentsAtPath:(NSString *)path {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"contentsAtPath"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

- (id <NSObject, NSCopying, NSCoding>)ubiquityIdentityToken {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"ubiquityIdentityToken"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig;
}

%end

%hook NSData

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:atomically"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromBool:flag withKey:@"flag"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, flag);
}

- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:options:error"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

- (BOOL)writeToURL:(NSURL *)aURL atomically:(BOOL)flag {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL"];
	[tracer addArgFromUrl:aURL withKey:@"aURL"];
	[tracer addArgFromBool:flag withKey:@"flag"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL, flag);
}

- (BOOL)writeToURL:(NSURL *)aURL options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL:options:error"];
	[tracer addArgFromUrl:aURL withKey:@"aURL"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL, mask, errorPtr);
}

+ (id)dataWithContentsOfFile:(NSString *)path {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

+ (id)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile:options:error"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL"];
	[tracer addArgFromUrl:aURL withKey:@"aURL"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL);
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL:options:error"];
	[tracer addArgFromUrl:aURL withKey:@"aURL"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL, mask, errorPtr);
}

- (id)initWithContentsOfFile:(NSString *)path {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

- (id)initWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile:options:error"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, mask, errorPtr);
}

- (id)initWithContentsOfURL:(NSURL *)aURL {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL"];
	[tracer addArgFromUrl:aURL withKey:@"aURL"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL);
}

- (id)initWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL:options:error"];
	[tracer addArgFromUrl:aURL withKey:@"aURL"];
	[tracer addArgFromInt:mask withKey:@"mask"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(aURL, mask, errorPtr);
}

%end

%hook NSFileHandle

- (void)writeData:(NSData *)data {
	//%log;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"writeData"];
	[tracer addArgFromData:data withKey:@"data"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(data);
}

%end

%end


%ctor {
	// Only hook the App we're interested in; this means the test App for now
	// TODO: Menu where the user can pick the App to profile
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
	if (appName == nil) {
		// Not a bundle ? Most likely something we don't want to hook like a system service

	}
	else {
		NSLog(@"APPNAME = %@", appName);

		//if ([appName isEqualToString: @"IntrospyTestApp"]) {
			
			// Initialize DB storage
			traceStorage = [[IntrospySQLiteStorage alloc] initWithDefaultDBFilePath];
			if (traceStorage != nil) {

		    // Initialize hooks
		    %init(DataStorage);
			}
			else {
				NSLog(@"Introspy - DB Initialization error; disabling hooks.");
			}
	    //}
		}
}
