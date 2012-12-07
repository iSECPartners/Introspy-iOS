/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


// NSInputStream ends up calling NSData methods that we hook as well. Is it useful to hook NSInputStream then ?



%hook NSInputStream


+ (id)inputStreamWithFileAtPath:(NSString *)path {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"inputStreamWithFileAtPath:"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

+ (id)inputStreamWithURL:(NSURL *)url {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"inputStreamWithURL:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(url);
}

- (id)initWithFileAtPath:(NSString *)path {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"initWithFileAtPath:"];
	[tracer addArgFromString:path withKey:@"path"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(path);
}

- (id)initWithURL:(NSURL *)url {
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"initWithURL:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return %orig(url);
}


%end
