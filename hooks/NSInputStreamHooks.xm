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
	id origResult = %orig(path);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"inputStreamWithFileAtPath:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	// Just store the pointer value for the return value
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (id)inputStreamWithURL:(NSURL *)url {
	id origResult = %orig(url);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"inputStreamWithURL:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (id)initWithFileAtPath:(NSString *)path {
	id origResult = %orig(path);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"initWithFileAtPath:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (id)initWithURL:(NSURL *)url {
	id origResult = %orig(url);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"initWithURL:"];
	[tracer addArgFromURL:url withKey:@"url"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}


%end
