/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/

%hook UIPasteboard

+ (UIPasteboard *)generalPasteboard {
	UIPasteboard *origResult = %orig;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"generalPasteboard"];
	// TODO: what should we store for the return value here? currently just
	// stuffing the pb contents into the plist"
	[tracer addReturnValueFromPlistObject:origResult.strings];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create {
	UIPasteboard *origResult = %orig;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"pasteboardWithName:create:"];
	[tracer addArgFromPlistObject:pasteboardName withKey:@"pasteboardName"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool:create] withKey:@"create"];
	[tracer addReturnValueFromPlistObject:origResult.strings];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (UIPasteboard *)pasteboardWithUniqueName {
	UIPasteboard *origResult = %orig;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"pasteboardWithUniqueName"];
	[tracer addArgFromPlistObject:origResult.name withKey:@"uniqueName"];
	[tracer addReturnValueFromPlistObject:origResult.strings];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

%end

/* vim: set filetype=objc : */
