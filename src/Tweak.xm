// Utility functions
#import "SQLiteStorage.h"
#import "PlistObjectConverter.h"
#import "CallStackInspector.h"

// Delegate hooks => We proxy the delegate objects
#import "hooks/DelegateProxies.h"

// Hooks for C functions directly use MobileSubstrate
#import "hooks/SecurityHooks.h"
#import "hooks/KeychainHooks.h"
#import "hooks/CommonCryptorHooks.h"
#import "hooks/CommonHMACHooks.h"
#import "hooks/CommonKeyDerivationHooks.h"
#import "hooks/CommonDigestHooks.h"
#import "hooks/LibCHooks.h"

// Hooks for ObjC methods rely on the Logos pre-processor
// H4ck to split Logos hooking code into separate files: we're including actual code, not headers
SQLiteStorage *traceStorage;
NSString *objectTypeNotSupported = @"Introspy - Not supported";
static NSString *preferenceFilePath = @"/private/var/mobile/Library/Preferences/com.isecpartners.introspy.plist";

// Utility function to parse the preference file
static BOOL getBoolFromPreferences(NSMutableDictionary *preferences, NSString *preferenceValue) {
    id value = [preferences objectForKey:preferenceValue];
    if (value == nil) {
        return YES; // default to YES
    }
    return [value boolValue];
}

// Log all custom URL schemes registered
// TODO: should we refactor this out of the main Tweak?
static void traceURISchemes() {
    NSArray *url_schemes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    for (id schemeBundle in url_schemes) {
        NSString *name = [schemeBundle objectForKey:@"CFBundleURLName"];
        NSNumber *isPrivate = [schemeBundle objectForKey:@"CFBundleURLIsPrivate"];
        for (id scheme in [schemeBundle objectForKey:@"CFBundleURLSchemes"]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"CFBundleURLTypes" andMethod:@"CFBundleURLSchemes"];
        [tracer addArgFromPlistObject:name withKey:@"CFBundleURLName"];
        [tracer addArgFromPlistObject:isPrivate withKey:@"CFBundleURLIsPrivate"];
        [tracer addArgFromPlistObject:scheme withKey:@"CFBundleURLScheme"];
        [traceStorage saveTracedCall:tracer];
        [tracer release];
        }
    }
}

// Regular hooks
%group URLSchemes
//#include "hooks/UIApplicationHooks.xm"
%hook UIApplication

- (void)setDelegate: (id)delegate {
	// Proxy the delegate so we can hook it
	UIApplicationDelegateProx *delegateProxy = [[UIApplicationDelegateProx alloc] initWithOriginalDelegate:delegate];
	%orig(delegateProxy);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIApplication" andMethod:@"setDelegate:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertDelegate:delegate followingProtocol:@"UIApplicationDelegate"] withKey:@"delegate"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return;
}
%end
%end


%group FileSystemHooks
//#include "hooks/NSDataHooks.xm"
//#include "hooks/NSFileHandleHooks.xm"
//#include "hooks/NSFileManagerHooks.xm"
//#include "hooks/NSInputStreamHooks.xm"
//#include "hooks/NSOutputStreamHooks.xm"
%hook NSData

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag {
	BOOL origResult = %orig(path, flag);
	// NSData methods are called a lot by other iOS APIs and we don't want to log that so we use the CallStackInspector
    if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:atomically:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addArgFromPlistObject:[NSNumber numberWithBool: flag] withKey:@"flag"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithBool: origResult]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	BOOL origResult = %orig(path, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToFile:options:error:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger: mask] withKey:@"mask"];
		// For now let's just store the pointer value of the errorPtr parameter
		[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithBool: origResult]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (BOOL)writeToURL:(NSURL *)aURL atomically:(BOOL)flag {
	BOOL origResult = %orig(aURL, flag);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL:atomically:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addArgFromPlistObject:[NSNumber numberWithBool: flag] withKey:@"flag"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithBool: origResult]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (BOOL)writeToURL:(NSURL *)aURL options:(NSDataWritingOptions)mask error:(NSError **)errorPtr {
	BOOL origResult = %orig(aURL, mask, errorPtr);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"writeToURL:options:error:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithBool: origResult]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

+ (id)dataWithContentsOfFile:(NSString *)path {
	id origResult = %orig(path);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		// origResult should be NSData* ?
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

+ (id)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	id origResult = %orig(path, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile:options:error:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL {
	id origResult = %orig(aURL);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

+ (id)dataWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	id origResult = %orig(aURL, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL:options:error:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (id)initWithContentsOfFile:(NSString *)path {
	id origResult = %orig(path);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (id)initWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	id origResult = %orig(path, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile:options:error:"];
		[tracer addArgFromPlistObject:path withKey:@"path"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (id)initWithContentsOfURL:(NSURL *)aURL {
	id origResult = %orig(aURL);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}

- (id)initWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr {
	id origResult = %orig(aURL, mask, errorPtr);
	if ([CallStackInspector wasDirectlyCalledByApp]) {
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL:options:error:"];
		[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: aURL] withKey:@"aURL"];
		[tracer addArgFromPlistObject:[NSNumber numberWithInteger:mask] withKey:@"mask"];
		[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"errorPtr"];
		[tracer addReturnValueFromPlistObject: origResult];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
	}
	return origResult;
}
%end


%hook NSFileHandle

+ (id)fileHandleForReadingAtPath:(NSString *)path {
	id origResult = %orig(path);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForReadingAtPath:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	// Only store the value of the pointer for now. TODO: Convert NSFilehandle to Plist object
	// TODO: what do you want to parse what out of it? i.e., do you want to
	// actually make instance calls to the filehandle? to e.g., get the
	// data? [NSFileHandle readDataToEndOfFile]?
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (id)fileHandleForReadingFromURL:(NSURL *)url error:(NSError **)error {
	id origResult = %orig(url, error);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForReadingFromURL:error:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"error"];
	[tracer addReturnValueFromPlistObject:objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (id)fileHandleForUpdatingAtPath:(NSString *)path {
	id origResult = %orig(path);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForUpdatingAtPath:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (id)fileHandleForUpdatingURL:(NSURL *)url error:(NSError **)error {
	id origResult = %orig(url, error);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForUpdatingURL:error:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"error"];
	[tracer addReturnValueFromPlistObject:objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (id)fileHandleForWritingAtPath:(NSString *)path {
	id origResult = %orig(path);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingAtPath:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (id)fileHandleForWritingToURL:(NSURL *)url error:(NSError **)error {
	id origResult = %orig(url, error);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingToURL:error:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"error"];
	[tracer addReturnValueFromPlistObject:objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}
%end


// NSFileManager ends up calling NSData methods that we hook as well. Is it useful to hook NSFileManager then ?
%hook NSFileManager

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)contents attributes:(NSDictionary *) attributes {
	BOOL origResult = %orig(path, contents, attributes);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"createFileAtPath:contents:attributes:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addArgFromPlistObject:contents withKey:@"contents"];
	[tracer addArgFromPlistObject:attributes withKey:@"attributes"];
	[tracer addReturnValueFromPlistObject: [NSNumber numberWithBool:origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (NSData *)contentsAtPath:(NSString *)path {
	id origResult = %orig(path);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"contentsAtPath:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addReturnValueFromPlistObject: origResult];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (id <NSObject, NSCopying, NSCoding>)ubiquityIdentityToken {
	id origResult = %orig;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileManager" andMethod:@"ubiquityIdentityToken"];
	// Not sure about the return value, let's just store the pointer for now
	[tracer addReturnValueFromPlistObject:objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}
%end


// NSInputStream ends up calling NSData methods that we hook as well. Is it useful to hook NSInputStream then ?
%hook NSInputStream

+ (id)inputStreamWithFileAtPath:(NSString *)path {
	id origResult = %orig(path);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"inputStreamWithFileAtPath:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	// Just store the pointer value for the return value
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (id)inputStreamWithURL:(NSURL *)url {
	id origResult = %orig(url);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"inputStreamWithURL:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (id)initWithFileAtPath:(NSString *)path {
	id origResult = %orig(path);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"initWithFileAtPath:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (id)initWithURL:(NSURL *)url {
	id origResult = %orig(url);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSInputStream" andMethod:@"initWithURL:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}
%end


%hook NSOutputStream

+ (id)outputStreamToFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
	id origResult = %orig(path, shouldAppend);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"outputStreamToFileAtPath:append:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: shouldAppend] withKey:@"shouldAppend"];
	// Just store the pointer value for the return value
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (id)outputStreamWithURL:(NSURL *)url append:(BOOL)shouldAppend {
	id origResult = %orig(url, shouldAppend);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"outputStreamWithURL:append:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: shouldAppend] withKey:@"shouldAppend"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (id)initToFileAtPath:(NSString *)path append:(BOOL)shouldAppend {
	id origResult = %orig(path, shouldAppend);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"initToFileAtPath:append:"];
	[tracer addArgFromPlistObject:path withKey:@"path"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: shouldAppend] withKey:@"shouldAppend"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

- (id)initWithURL:(NSURL *)url append:(BOOL)shouldAppend {
	id origResult = %orig(url, shouldAppend);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSOutputStream" andMethod:@"initWithURL:append:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL: url] withKey:@"url"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool: shouldAppend] withKey:@"shouldAppend"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}
%end
%end


%group HTTPHooks
//#include "hooks/NSURLConnectionHooks.xm"
//#include "hooks/NSHTTPCookieHooks.xm"
//#include "hooks/NSURLCredentialHooks.xm"
%hook NSURLConnection

// Not hooking these methods:
// + connectionWithRequest:delegate: ends up calling initWithRequest:delegate:
// + sendAsynchronousRequest:queue:completionHandler: ends up calling sendSynchronousRequest:returningResponse:error:

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
	NSData *origResult = %orig(request, response, error);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"sendSynchronousRequest:returningResponse:error:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"response"];
	[tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"error"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {

	// Proxy the delegate so we can hook it
	NSURLConnectionDelegateProx *delegateProxy = [[NSURLConnectionDelegateProx alloc] initWithOriginalDelegate:delegate];
	id origResult = %orig(request, delegateProxy);

	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"initWithRequest:delegate:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertDelegate:delegate followingProtocol:@"NSURLConnectionDelegate"] withKey:@"delegate"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately {

	// Proxy the delegate so we can hook it
	NSURLConnectionDelegateProx *delegateProxy = [[NSURLConnectionDelegateProx alloc] initWithOriginalDelegate:delegate];
	id origResult = %orig(request, delegateProxy, startImmediately);

	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"initWithRequest:delegate:startImmediately:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertDelegate:delegate followingProtocol:@"NSURLConnectionDelegate"] withKey:@"delegate"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool:startImmediately] withKey:@"startImmediately"];
	[tracer addReturnValueFromPlistObject: objectTypeNotSupported];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}

// The following methods are not explicitely part of NSURLConnection.
// However, when implementing custom cert validation using the NSURLConnectionDelegate protocol,
// the application sends the result of the validation (server cert was OK/bad) to [challenge sender].
// The class of [challenge sender] is NSURLConnection because it implements the NSURLAuthenticationChallengeSender
// protocol. So we're hooking this in order to find when the validation might have been disabled.

// The usual way of disabling SSL cert validation
- (void)continueWithoutCredentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	%orig(challenge);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"continueWithoutCredentialForAuthenticationChallenge:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLAuthenticationChallenge: challenge] withKey:@"challenge"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
}

// Might indicate client certificates or cert pinning. TODO: Investigate
- (void)useCredential:(NSURLCredential *)credential forAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	%orig(credential, challenge);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnection" andMethod:@"useCredential:forAuthenticationChallenge:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLCredential:credential] withKey:@"credential"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLAuthenticationChallenge: challenge] withKey:@"challenge"];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
}
%end


%hook NSHTTPCookie

// No need to hook +cookieWithProperties: because it just calls –initWithProperties: 


// This might be unnecessary. We should see the cookies getting created as we hook the constructor.
// TODO: Double check
#if 0
+ (NSArray *)cookiesWithResponseHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)theURL {
	NSArray *origResult = %orig(headerFields, theURL);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSHTTPCookie" andMethod:@"cookiesWithResponseHeaderFields:forURL:"];
	[tracer addArgFromPlistObject:headerFields withKey:@"headerFields"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertURL:theURL] withKey:@"theURL"];
	[tracer addReturnValueFromPlistObject:origResult];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}
#endif 


- (id)initWithProperties:(NSDictionary *)properties {
	id origResult = %orig(properties);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSHTTPCookie" andMethod:@"initWithProperties:"];
	[tracer addArgFromPlistObject:properties withKey:@"properties"];
	[tracer addReturnValueFromPlistObject:[PlistObjectConverter convertNSHTTPCookie:origResult]];
	[traceStorage saveTracedCall:tracer];
	[tracer release];
	return origResult;
}
%end


%hook NSURLCredential

//credentialWithXXX() all call initWithXXX() so we don't hook them

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

- (id)initWithTrust:(SecTrustRef)trust {
	id origResult = %orig(trust);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLCredential" andMethod:@"initWithTrust:"];
	[tracer addArgFromPlistObject:[PlistObjectConverter convertSecTrustRef: trust] withKey:@"trust"];
	[tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSURLCredential:origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

// We probably don't need this as we can already see client cert stuff by hooking NSURLConnection
#if 0
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
%end


%group UserPreferencesHooks
//#include "hooks/NSUserDefaultsHooks.xm"
%hook NSUserDefaults

// setObject:forKey: is called by every other setXXX functions. Let's not hook it
// object:forKey: is called by every other functions. Let's not hook it

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
%end


%group PasteboardHooks
//#include "hooks/UIPasteboardHooks.xm"
%hook UIPasteboard

+ (UIPasteboard *)generalPasteboard {
	UIPasteboard *origResult = %orig;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"generalPasteboard"];
	[tracer addReturnValueFromPlistObject:[PlistObjectConverter convertUIPasteboard: origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create {
	UIPasteboard *origResult = %orig;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"pasteboardWithName:create:"];
	[tracer addArgFromPlistObject:pasteboardName withKey:@"pasteboardName"];
	[tracer addArgFromPlistObject:[NSNumber numberWithBool:create] withKey:@"create"];
	[tracer addReturnValueFromPlistObject:[PlistObjectConverter convertUIPasteboard: origResult]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	return origResult;
}

+ (UIPasteboard *)pasteboardWithUniqueName {
	UIPasteboard *origResult = %orig;
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"UIPasteboard" andMethod:@"pasteboardWithUniqueName"];
	[tracer addArgFromPlistObject:origResult.name withKey:@"uniqueName"];
	[tracer addReturnValueFromPlistObject:[PlistObjectConverter convertUIPasteboard: origResult]];
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
%end


%group XMLHooks
//#include "hooks/NSXMLParserHooks.xm"
%hook NSXMLParser

- (id)initWithContentsOfURL:(NSURL *)url {
    id origResult = %orig(url);
    // NSXMLParser methods are called a lot by other iOS APIs (for example to parse HTML responses) and we don't want to log that so we use the CallStackInspector
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSXMLParser" andMethod:@"initWithContentsOfURL:"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertURL:url] withKey:@"url"];
        [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
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
        [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }
    return origResult;
}


- (id)initWithStream:(NSInputStream *)stream {
    id origResult = %orig(stream);
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSXMLParser" andMethod:@"initWithStream:"];
        [tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"stream"];
        [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
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
%end



// Tweak starts here
%ctor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Only hook Apps the user has selected in Introspy's settings panel
    NSString *appId = [[NSBundle mainBundle] bundleIdentifier];
    // Load Introspy preferences
    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:preferenceFilePath];
    id shouldHook = [preferences objectForKey:appId];
    if ( (shouldHook == nil) || (! [shouldHook boolValue]) ) {
        NSLog(@"Introspy - Profiling disabled for %@", appId);
    	[preferences release];
        [pool drain];
	    return;
    }

	// Initialize DB storage
    NSLog(@"Introspy - Profiling enabled for %@", appId);
    BOOL shouldLog = getBoolFromPreferences(preferences, @"LogToTheConsole");
	traceStorage = [[SQLiteStorage alloc] initWithDefaultDBFilePathAndLogToConsole: shouldLog];
	if (traceStorage != nil) {
	    // Initialize hooks
        // Data Storage hooks
        if (getBoolFromPreferences(preferences, @"FileSystemHooks")) {
            %init(FileSystemHooks);
        }
        if (getBoolFromPreferences(preferences, @"UserPreferencesHooks")) {
            %init(UserPreferencesHooks);
        }
        if (getBoolFromPreferences(preferences, @"KeyChainHooks")) {
            [KeychainHooks enableHooks];
        }
        // Crypto hooks
        if (getBoolFromPreferences(preferences, @"CommonCryptoHooks")) {
            [LibCHooks enableHooks]; // Not really part of CommonCrypto
            [CommonCryptorHooks enableHooks];
            [CommonHMACHooks enableHooks];
            [CommonKeyDerivationHooks enableHooks];
            [CommonDigestHooks enableHooks];
        }
        if (getBoolFromPreferences(preferences, @"SecurityHooks")) {
            [SecurityHooks enableHooks];
        }
        // Network hooks
        if (getBoolFromPreferences(preferences, @"HTTPHooks")) {
            %init(HTTPHooks);
        }
        // IPC hooks
        if (getBoolFromPreferences(preferences, @"PasteboardHooks")) {
            %init(PasteboardHooks);
        }
        if (getBoolFromPreferences(preferences, @"URLSchemesHooks")) {
            traceURISchemes();
            %init(URLSchemes);
        }
        // Misc hooks
        if (getBoolFromPreferences(preferences, @"XMLHooks")) {
            %init(XMLHooks);
        }
	}
	else {
		NSLog(@"Introspy - DB Initialization error; disabling hooks.");
	}

    [preferences release];
    [pool drain];
}

/* vim: set filetype=objc : */
