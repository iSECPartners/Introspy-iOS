#import <sqlite3.h>
#import "CallTracer.h"

@interface IntrospySQLiteStorage : NSObject {
	
	sqlite3 *dbConnection;

}

- (IntrospySQLiteStorage *)initWithDefaultDBFilePath;
- (IntrospySQLiteStorage *)initWithDBFilePath:(NSString *) DBFilePath;
- (void)saveTracedCall: (CallTracer*) tracedCall;


@end

