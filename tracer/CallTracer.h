
@interface CallTracer: NSObject {
	NSMutableDictionary* args;
	NSString* className;
	NSString* methodName;
}

@property (retain) NSDictionary *args;
@property (retain) NSString *className;
@property (retain) NSString *methodName;
@property (retain) NSDictionary *returnValue;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth;

// Plist objects are string, number, boolean, date, data, dictionary and array.
- (BOOL) addArgFromPlistObject:(id) arg withKey:(NSString *)key;
- (BOOL) addReturnValueFromPlistObject:(id) result;

- (NSData *) serializeArgs;
- (NSData *) serializeReturnValue;


@end
