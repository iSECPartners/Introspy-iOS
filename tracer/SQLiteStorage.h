#import "CallTracer.h"

@interface SQLiteStorage : NSObject {

}

- (SQLiteStorage *)initWithDefaultDBFilePathAndLogToConsole: (BOOL) shouldLog;
- (SQLiteStorage *)initWithDBFilePath:(NSString *) DBFilePath andLogToConsole: (BOOL) shouldLog;
- (BOOL)saveTracedCall: (CallTracer*) tracedCall;


@end

