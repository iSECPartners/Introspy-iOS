#import "IntrospySQLiteStorage.h"

@implementation IntrospySQLiteStorage : NSObject 


// Database settings
static NSString *defaultDBFileFormat = @"~/introspy-%@.db"; // Becomes ~/introspy-<processName>.db
static const char createTableStmtStr[] = "CREATE TABLE tracedCalls (class TEXT, method TEXT, arguments TEXT)";
static const char saveTracedCallStmtStr[] = "INSERT INTO tracedCalls VALUES (?1, ?2, ?3)";


// Internal stuff
static sqlite3_stmt *saveTracedCallStmt;
static sqlite3 *dbConnection;


- (IntrospySQLiteStorage *)initWithDefaultDBFilePath {
	// Put process name in the DB's filename to avoid confusion
	NSString *processName = [[NSProcessInfo processInfo] processName];
	NSString *DBFilePath = [NSString stringWithFormat:defaultDBFileFormat, processName];
	NSLog(@"DB PATH = %@", [DBFilePath stringByExpandingTildeInPath]);
	return [self initWithDBFilePath: [DBFilePath stringByExpandingTildeInPath]];
}


- (IntrospySQLiteStorage *)initWithDBFilePath:(NSString *) DBFilePath {
    self = [super init];
    sqlite3 *dbConn;

    // Open the DB file if it's already there
    if (sqlite3_open_v2([DBFilePath UTF8String], &dbConn, SQLITE_OPEN_READWRITE, NULL) != SQLITE_OK) {

		// If not, create the DB file
		if (sqlite3_open_v2([DBFilePath UTF8String], &dbConn, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL) != SQLITE_OK) {
        	NSLog(@"IntrospySQLiteStorage - Unable to open database!");
        	return nil;			
    	}
    	else {
    		// Create the tables in the DB we just created
    		if (sqlite3_exec(dbConn, createTableStmtStr, NULL, NULL, NULL) != SQLITE_OK) {
        		NSLog(@"IntrospySQLiteStorage - Unable to create tables!");
        		return nil;
    		}
    	}
	}

	// Prepare the INSERT statement we'll use to store everything
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(dbConn, saveTracedCallStmtStr, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"IntrospySQLiteStorage - Unable to prepare statement!");
        return nil;
    }
    
    saveTracedCallStmt = statement;
    dbConnection = dbConn;
    return self;
}


- (BOOL)saveTracedCall: (CallTracer*) tracedCall {

	sqlite3_reset(saveTracedCallStmt);
	sqlite3_bind_text(saveTracedCallStmt, 1, [ [tracedCall className] UTF8String], -1, nil);
	sqlite3_bind_text(saveTracedCallStmt, 2, [ [tracedCall methodName] UTF8String], -1, nil);

	// Store arguments in plist format as a blob
	NSData *plist = [tracedCall serializeArgs];
	if (plist == nil) {
		NSLog(@"IntrospySQLiteStorage::saveTraceCall: can't print plist");
		return NO;
	}

	NSString *sPlist = [[NSString alloc] initWithData:plist encoding:NSUTF8StringEncoding];
	NSLog(@"*****************************************************");	
	NSLog(@"%@", sPlist);
	NSLog(@"*****************************************************");	
	sqlite3_bind_text(saveTracedCallStmt, 3, [sPlist UTF8String], -1, nil);
	
	// Do the query
    if (sqlite3_step(saveTracedCallStmt) != SQLITE_DONE) {
        NSLog(@"IntrospySQLiteStorage - Commit Failed!");
    	return NO;
    }
    return YES;
}


- (void)dealloc
{
    sqlite3_finalize(saveTracedCallStmt);
    sqlite3_close(dbConnection);
    [super dealloc];
}







@end


