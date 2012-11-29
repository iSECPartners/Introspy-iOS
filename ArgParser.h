
@interface ArgParser : NSObject {
	NSMutableDictionary* args;
}

@property (retain) NSMutableDictionary *args;

- (BOOL) addArgFromString:(NSString *)str key:(NSString *)key;
- (id) serializeArgs;
@end
