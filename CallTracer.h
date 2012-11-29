
@interface CallTracer: NSObject {
	NSMutableDictionary* args;
	NSString* className;
	NSString* methodName;
}

@property (retain) NSMutableDictionary *args;
@property (retain) NSString *className;
@property (retain) NSString *methodName;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth;
- (BOOL) addArgFromString:(NSString *)str withKey:(NSString *)key;
- (BOOL) addArgFromData:(NSData *)str withKey:(NSString *)key;
- (BOOL) addArgFromDictionary:(NSDictionary *)dict withKey:(NSString *)key;
- (BOOL) addArgFromBool:(BOOL)boolean withKey:(NSString *)key;
- (BOOL) addArgFromInt:(NSUInteger)val withKey:(NSString *)key;
- (id) serializeArgs;
@end
