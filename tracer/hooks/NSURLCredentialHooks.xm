/*
We're directly including this file into Tweak.xmi at build time. 
Tweak.xmi includes/defines the following things:

#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"
IntrospySQLiteStorage *traceStorage;
*/


%hook NSURLCredential

//credentialWithXXX all call initWithXXX so we don't hook them

- (id)initWithUser:(NSString *)user password:(NSString *)password persistence:(NSURLCredentialPersistence)persistence {
	id origResult = %orig(user, password, persistence);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLCredential" andMethod:@"initWithUser:password:persistence:"];
	[tracer addArgFromPlistObject:user withKey:@"user"];
	[tracer addArgFromPlistObject:password withKey:@"password"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) persistence] withKey:@"persistence"];
	[tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSURLCredential:origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

// TODO: Hook server and client cert stuff
#if 0
- (id)initWithTrust:(SecTrustRef)trust {
	id origResult = %orig(trust);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLCredential" andMethod:@"initWithTrust:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) trust] withKey:@"trust"];
	[tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSURLCredential:origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (id)initWithIdentity:(SecIdentityRef)identity certificates:(NSArray *)certArray persistence:(NSURLCredentialPersistence)persistence {
	id origResult = %orig(identity, certArray, persistence);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLCredential" andMethod:@"initWithIdentity:certificates:persistence:"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) identity] withKey:@"identity"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) certArray] withKey:@"certArray"];
	[tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) persistence] withKey:@"persistence"];
	[tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSURLCredential:origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}
#endif

%end

/* vim: set filetype=objc : */
