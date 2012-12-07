/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


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
