/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


%hook NSOutputStream


+ (id)outputStreamToFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"outputStreamToFileAtPath:append:"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromBOOL:shouldAppend withKey:@"shouldAppend"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, shouldAppend);
}	

+ (id)outputStreamWithURL:(NSURL *)url append:(BOOL)shouldAppend {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"outputStreamWithURL:append:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[tracer addArgFromBOOL:shouldAppend withKey:@"shouldAppend"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(url, shouldAppend);
}	

- (id)initToFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"initToFileAtPath:append:"];
	[tracer addArgFromString:path withKey:@"path"];
	[tracer addArgFromBOOL:shouldAppend withKey:@"shouldAppend"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path, shouldAppend);
}	

- (id)initWithURL:(NSURL *)url append:(BOOL)shouldAppend {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"initWithURL:append:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[tracer addArgFromBOOL:shouldAppend withKey:@"shouldAppend"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(url, shouldAppend);
}	


%end
