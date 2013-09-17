/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/



%hook NSXMLParser


- (id)initWithContentsOfURL:(NSURL *)url {
    id origResult = %orig(url);
    // NSXMLParser methods are called a lot by other iOS APIs (for example to parse HTML responses) and we don't want to log that so we use the CallStackInspector
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSXMLParser" andMethod:@"initWithContentsOfURL:"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertURL:url] withKey:@"url"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


- (id)initWithData:(NSData *)data {
    id origResult = %orig(data);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSXMLParser" andMethod:@"initWithData:"];
        [tracer addArgFromPlistObject:data withKey:@"data"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;    
}


- (id)initWithStream:(NSInputStream *)stream {
    id origResult = %orig(stream);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSXMLParser" andMethod:@"initWithStream:"];
        [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt:(unsigned int)stream] withKey:@"stream"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithUnsignedInt:(unsigned int)origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;  
}


- (void)setShouldResolveExternalEntities:(BOOL)shouldResolveExternalEntities {
    %orig(shouldResolveExternalEntities);
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSXMLParser" andMethod:@"setShouldResolveExternalEntities:"];
    [tracer addArgFromPlistObject:[NSNumber numberWithBool:shouldResolveExternalEntities] withKey:@"shouldResolveExternalEntities"];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
}

%end
