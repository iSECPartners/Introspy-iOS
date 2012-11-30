#import "IntrospySQLiteStorage.h"

@implementation IntrospySQLiteStorage : NSObject 


// Database settings
//static int ARGS_BLOB_MAX_SIZE = 256;
static NSString *defaultDBFilePath = @"introspy.db";
static const char createTableStmtStr[] = "CREATE TABLE tracedCalls (class TEXT, method TEXT, arguments BLOB)";
static const char saveTracedCallStmtStr[] = "INSERT INTO tracedCalls VALUES (?1, ?2, ?3)";


// Internal stuff
static sqlite3_stmt *saveTracedCallStmt;


- (IntrospySQLiteStorage *)initWithDefaultDBFilePath {
	return [self initWithDBFilePath: defaultDBFilePath];
}


- (IntrospySQLiteStorage *)initWithDBFilePath:(NSString *) DBFilePath {
    self = [super init];
    sqlite3 *dbConn;

    if (sqlite3_open([DBFilePath UTF8String], &dbConn) != SQLITE_OK) {
        NSLog(@"IntrospySQLiteStorage - Unable to open database!");
        return nil;
    }

    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(dbConn, saveTracedCallStmtStr, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"IntrospySQLiteStorage - Unable to prepare statement!");
    }

    saveTracedCallStmt = statement;
    dbConnection = dbConn;
    return self;
}


- (void)saveTracedCall: (CallTracer*) tracedCall {

	sqlite3_reset(saveTracedCallStmt);
	sqlite3_bind_text(saveTracedCallStmt, 1, [ [tracedCall className] UTF8String], -1, nil);
	sqlite3_bind_text(saveTracedCallStmt, 2, [ [tracedCall methodName] UTF8String], -1, nil);

	// Store arguments as a blob
	//(NSData *) plistArgs = [dataWithPropertyList:[tracedCall args] format:(NSPropertyListFormat)format options:0 error:nil];

	//uint8_t argsBuffer[ARGS_BLOB_MAX_SIZE];
	//NSPropertyListSerialization
	//[NSOutputStream outputStreamToBuffer:argsBuffer capacity:ARGS_BLOB_MAX_SIZE];


	//sqlite3_bind_blob(saveTracedCallStmt, 3, 
	

    if (sqlite3_step(saveTracedCallStmt) != SQLITE_DONE) {
        printf("IntrospySQLiteStorage - Commit Failed!");
    }

}





@end


