#import "CallTracer.h"

@interface IntrospySQLiteStorage : NSObject {

}

- (IntrospySQLiteStorage *)initWithDefaultDBFilePathAndLogToConsole: (BOOL) shouldLog;
- (IntrospySQLiteStorage *)initWithDBFilePath:(NSString *) DBFilePath andLogToConsole: (BOOL) shouldLog;
- (BOOL)saveTracedCall: (CallTracer*) tracedCall;


@end

