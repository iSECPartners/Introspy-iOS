
@interface CallTracer: NSObject {
	NSMutableDictionary* args;
	NSString* className;
	NSString* methodName;
}

@property (retain) NSDictionary *args;
@property (retain) NSString *className;
@property (retain) NSString *methodName;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth;
- (BOOL) addArgFromString:(NSString *)str withKey:(NSString *)key;
- (BOOL) addArgFromData:(NSData *)str withKey:(NSString *)key;
- (BOOL) addArgFromDictionary:(NSDictionary *)dict withKey:(NSString *)key;
- (BOOL) addArgFromBOOL:(BOOL)boolean withKey:(NSString *)key;
- (BOOL) addArgFromInteger:(NSUInteger)val withKey:(NSString *)key;
- (BOOL) addArgFromFloat:(float)val withKey:(NSString *)key;
- (BOOL) addArgFromDouble:(double)val withKey:(NSString *)key;
- (BOOL) addArgFromURL:(NSURL *)aURL withKey:(NSString *)key;
- (NSData *) serializeArgs;
@end
