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

- (NSData *)dataForPasteboardType:(NSString *)pasteboardType {
	NSData *origResult = %orig(pasteboardType);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"dataForPasteboardType:"];
	[tracer addArgFromPlistObject:pasteboardType withKey:@"pasteboardType"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (NSArray *)dataForPasteboardType:(NSString *)pasteboardType inItemSet:(NSIndexSet *)itemSet {
	NSArray *origResult = %orig(pasteboardType, itemSet);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"dataForPasteboardType:inItemSet:"];
	[tracer addArgFromPlistObject:pasteboardType withKey:@"pasteboardType"];
	//TODO: need to figure out how to store this properly if we want it
	[tracer addArgFromPlistObject:@"introspy - not implemented" withKey:@"itemSet"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (void)setData:(NSData *)data forPasteboardType:(NSString *)pasteboardType {
	%orig(data, pasteboardType);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"setData:forPasteboardType:"];
	[tracer addArgFromPlistObject:data withKey:@"data"];
	[tracer addArgFromPlistObject:pasteboardType withKey:@"pasteboardType"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}

- (void)setValue:(id)value forPasteboardType:(NSString *)pasteboardType {
	%orig(value, pasteboardType);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"setValue:forPasteboardType:"];
	[tracer addArgFromPlistObject:value withKey:@"value"];
	[tracer addArgFromPlistObject:pasteboardType withKey:@"pasteboardType"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}

- (void)addItems:(NSArray *)items {
	%orig(items);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"addItems:"];
	[tracer addArgFromPlistObject:items withKey:@"items"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}

- (id)valueForPasteboardType:(NSString *)pasteboardType {
	id origResult = %orig(pasteboardType);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"valueForPasteboardType:"];
	[tracer addArgFromPlistObject:pasteboardType withKey:@"pasteboardType"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (NSArray *)valuesForPasteboardType:(NSString *)pasteboardType inItemSet:(NSIndexSet *)itemSet {
	NSArray *origResult = %orig(pasteboardType, itemSet);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"valuesForPasteboardType:itemSet:"];
	[tracer addArgFromPlistObject:pasteboardType withKey:@"pasteboardType"];
	[tracer addArgFromPlistObject:@"introspy - not implemented" withKey:@"itemSet"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

%end

/* vim: set filetype=objc : */
