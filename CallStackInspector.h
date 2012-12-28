
@interface CallStackInspector: NSObject {

}

// Some of the functions we hook can be called by both an application and the iOS API
// For example, CCCryptor is used internally by the SSL stack to handle the crypto
// We don't want to hook internal calls, only what the App is directly calling.
// So we use this to figure out who called the function we're hooking.
+ (BOOL) wasCalledInternally;

+ (BOOL) wasCalledBy:(NSString *) name;

@end
