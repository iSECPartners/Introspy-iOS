/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


%hook NSOutputStream


+ (id)outputStreamToFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
	id origResult = %orig(path, shouldAppend);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"outputStreamToFileAtPath:append:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: shouldAppend] withKey:@"shouldAppend"];
	// Just store the pointer value for the return value
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}	

+ (id)outputStreamWithURL:(NSURL *)url append:(BOOL)shouldAppend {
	id origResult = %orig(url, shouldAppend);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"outputStreamWithURL:append:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: shouldAppend] withKey:@"shouldAppend"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}	

- (id)initToFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
	id origResult = %orig(path, shouldAppend);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"initToFileAtPath:append:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: shouldAppend] withKey:@"shouldAppend"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}	

- (id)initWithURL:(NSURL *)url append:(BOOL)shouldAppend {
	id origResult = %orig(url, shouldAppend);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"initWithURL:append:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: shouldAppend] withKey:@"shouldAppend"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}	


%end
