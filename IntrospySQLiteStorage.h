#import "CallTracer.h"

@interface IntrospySQLiteStorage : NSObject {

}

- (IntrospySQLiteStorage *)initWithDefaultDBFilePath;
- (IntrospySQLiteStorage *)initWithDBFilePath: (NSString *) DBFilePath;
- (BOOL)saveTracedCall: (CallTracer*) tracedCall;


@end

