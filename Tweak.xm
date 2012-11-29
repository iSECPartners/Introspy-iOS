#import "ArgParser.h"

%group DataStorage

%hook NSFileManager

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)contents attributes:(NSDictionary *) attributes {
    %log;
    ArgParser *parser = [[ArgParser alloc] init];
    [parser addArgFromString:path key:@"path"];
//    id args = [parser serializeArgs];
    return %orig(path, contents, attributes);
}

%end
%end

%ctor {
    %init(DataStorage);
}
