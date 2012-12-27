/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


%hook NSUserDefaults


- (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
	%orig(value, defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setBool:forKey:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: value] withKey:@"value"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return;
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName {
	%orig(value, defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setFloat:forKey:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithFloat: value] withKey:@"value"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return;
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
	%orig(value, defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setInteger:forKey:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithInteger: value] withKey:@"value"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return;
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
	%orig(url, defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setURL:forKey:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return;
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName {
	%orig(value, defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"setDouble:forKey:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithDouble: value] withKey:@"value"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return;
}


- (NSArray *)arrayForKey:(NSString *)defaultName {
	NSArray *origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"arrayForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	// Dangerous: will crash if the array contains non-plist objects
	[tracer addReturnValueFromPlistObject: origResult];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (BOOL)boolForKey:(NSString *)defaultName {
	BOOL origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"boolForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithBool: origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (NSData *)dataForKey:(NSString *)defaultName {
	NSData *origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"dataForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[tracer addReturnValueFromPlistObject: origResult];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (NSDictionary *)dictionaryForKey:(NSString *)defaultName {
	NSDictionary *origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"dictionaryForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	// Dangerous: will crash if the dict contains non-plist objects
	[tracer addReturnValueFromPlistObject: origResult];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (float)floatForKey:(NSString *)defaultName {
	float origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"floatForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithFloat: origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (double)doubleForKey:(NSString *)defaultName {
	double origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"doubleForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithDouble: origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (NSInteger)integerForKey:(NSString *)defaultName {
	double origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"integerForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithInteger: origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
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
	NSArray *origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"stringArrayForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[tracer addReturnValueFromPlistObject: origResult];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (NSString *)stringForKey:(NSString *)defaultName {
	NSString *origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"stringForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[tracer addReturnValueFromPlistObject: origResult];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (NSURL *)URLForKey:(NSString *)defaultName {
	NSURL *origResult = %orig(defaultName);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"URLForKey:"];
	[tracer addArgFromPlistObject:defaultName withKey:@"defaultName"];
	[tracer addReturnValueFromPlistObject: [PlistObjectConverter convertURL: origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}


- (NSDictionary *)dictionaryRepresentation {
	NSDictionary *origResult = %orig();
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSUserDefaults" andMethod:@"dictionaryRepresentation"];
	[tracer addReturnValueFromPlistObject: origResult];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

%end
