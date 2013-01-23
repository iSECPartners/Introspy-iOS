
@interface PlistObjectConverter: NSObject {

}

// Plist objects are string, number, boolean, date, data, dictionary and array.
// We need to convert anything that's not a plist object to a dictionnary so we can store it.
+ (id) autoConvertNil: (id) pointer;
+ (NSDictionary*) convertURL:(NSURL *)aURL;
+ (NSDictionary *) convertNSURLRequest:(NSURLRequest *)request;
+ (NSDictionary *) convertNSURLAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
+ (NSDictionary *) convertNSURLCredential: (NSURLCredential*) credential;
+ (NSDictionary *) convertNSHTTPCookie: (NSHTTPCookie*) cookie;
+ (NSDictionary *) convertUIPasteboard: (UIPasteboard*) pasteboard;
+ (NSString *) convertCBuffer:(const void *) buffer withLength: (size_t) length;
@end
