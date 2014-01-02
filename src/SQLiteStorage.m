#import "SQLiteStorage.h"
#include <sqlite3.h>

@implementation SQLiteStorage


// Database settings
static BOOL logToConsole = TRUE;
static NSString *appstoreDBFileFormat = @"~/Library/introspy-%@.db"; // Becomes ~/Library/introspy-<appName>.db
static NSString *systemDBFileFormat = @"~/Library/Preferences/introspy-%@.db";
static const char createTableStmtStr[] = "CREATE TABLE tracedCalls (className TEXT, methodName TEXT, argumentsAndReturnValueDict TEXT)";
static const char saveTracedCallStmtStr[] = "INSERT INTO tracedCalls VALUES (?1, ?2, ?3)";


// Internal stuff
static sqlite3_stmt *saveTracedCallStmt;
static sqlite3 *dbConnection;


- (SQLiteStorage *)initWithDefaultDBFilePathAndLogToConsole: (BOOL) shouldLog {
    NSString *DBFilePath = nil;
    // Put application name in the DB's filename to avoid confusion
    NSString *appId = [[NSBundle mainBundle] bundleIdentifier];

    // Are we monitoring a System app or an App Store app ?
    NSString *appRoot = [@"~/" stringByExpandingTildeInPath];
    NSLog(@" LOLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO %@ ", appRoot);
    if ([appRoot isEqualToString: @"/var/mobile"]) {
        DBFilePath = [NSString stringWithFormat:systemDBFileFormat, appId];
    }
    else {
        DBFilePath = [NSString stringWithFormat:appstoreDBFileFormat, appId];
    }

    return [self initWithDBFilePath: [DBFilePath stringByExpandingTildeInPath] andLogToConsole: shouldLog];
}


- (SQLiteStorage *)initWithDBFilePath:(NSString *) DBFilePath andLogToConsole: (BOOL) shouldLog {
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
    logToConsole = shouldLog;
    return self;
}


- (BOOL)saveTracedCall: (CallTracer*) tracedCall {
    int queryResult = SQLITE_ERROR;

    // Serialize arguments and return value to an XML plist
    NSData *argsAndReturnValueData = [tracedCall serializeArgsAndReturnValue];
    if (argsAndReturnValueData == nil) {
        NSLog(@"IntrospySQLiteStorage::saveTraceCall: can't serialize args or return value");
        return NO;
    }
    NSString *argsAndReturnValueStr = [[NSString alloc] initWithData:argsAndReturnValueData encoding:NSUTF8StringEncoding];

    // Do the query; has to be atomic or we get random SQLITE_PROTOCOL errors
    // TODO: this is probably super slow
    @synchronized(appstoreDBFileFormat) {
    	sqlite3_reset(saveTracedCallStmt);
    	sqlite3_bind_text(saveTracedCallStmt, 1, [ [tracedCall className] UTF8String], -1, nil);
    	sqlite3_bind_text(saveTracedCallStmt, 2, [ [tracedCall methodName] UTF8String], -1, nil);
    	sqlite3_bind_text(saveTracedCallStmt, 3, [argsAndReturnValueStr UTF8String], -1, nil);
        queryResult = sqlite3_step(saveTracedCallStmt);
    }

    if (logToConsole) {
        NSLog(@"\n-----INTROSPY-----\nCALLED %@ %@\nWITH:\n%@\n---------------", [tracedCall className], [tracedCall methodName], [tracedCall argsAndReturnValue]);
    }

    [argsAndReturnValueStr release];

    if (queryResult != SQLITE_DONE) {
        NSLog(@"IntrospySQLiteStorage - Commit Failed: %x!", queryResult);
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


