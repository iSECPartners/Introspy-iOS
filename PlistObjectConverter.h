
@interface PlistObjectConverter: NSObject {

}

// Plist objects are string, number, boolean, date, data, dictionary and array.
// We need to convert anything that's not a plist object to a dictionnary so we can store it.

+ (NSDictionary*) convertURL:(NSURL *)aURL;


@end
