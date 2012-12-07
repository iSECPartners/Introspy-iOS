/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/

%group DataStorageHooks


%hook NSUserDefaults


- (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setBool:forKey:"];
	[tracer addArgFromBOOL:value withKey:@"value"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(value, defaultName);
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setFloat:forKey:"];
	[tracer addArgFromFloat:value withKey:@"value"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(value, defaultName);
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setInteger:forKey:"];
	[tracer addArgFromInteger:value withKey:@"value"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(value, defaultName);
}

/* setObject:forKey: is called by every other setXXX functions. Not sure we want to hook it.
- (void)setObject:(id)value forKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setObject:forKey:"];
	//[tracer addArgFromFloat:value withKey:@"value"]; TODO: What do we do with this
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(value, defaultName);
}
*/

- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setObject:forKey:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(url, defaultName);
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setDouble:forKey:"];
	[tracer addArgFromDouble:value withKey:@"value"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(value, defaultName);
}


- (NSArray *)arrayForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"arrayForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

- (BOOL)boolForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"boolForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

- (NSData *)dataForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"dataForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

- (NSDictionary *)dictionaryForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"dictionaryForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

- (float)floatForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"floatForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

- (double)doubleForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"doubleForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

- (NSInteger)integerForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"integerForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

/* object:forKey: is called by every other functions. Not sure we want to hook it.
- (id)objectForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"objectForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}
*/

- (NSArray *)stringArrayForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"stringArrayForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

- (NSString *)stringForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"stringForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}

- (NSURL *)URLForKey:(NSString *)defaultName {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"URLForKey:"];
	[tracer addArgFromString:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(defaultName);
}


- (NSDictionary *)dictionaryRepresentation {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"dictionaryRepresentation"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig();
}

%end




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

%end
