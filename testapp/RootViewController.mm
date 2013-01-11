#import "RootViewController.h"

#import "FileSystemTester.h"
#import "UIPasteboardTester.h"
#import "UserPreferencesTester.h"
#import "NSURLConnectionTester.h"
#import "KeyChainTester.h"
#import "CryptoTester.h"


@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor redColor];



    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Introspy Test App"
                             message: @"Introspy Test App Started"
                             delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
    [alert release];

    // Data Storage
    FileSystemTester *fileSystemTests = [[FileSystemTester alloc] init];
    [fileSystemTests runAllTests];
    [fileSystemTests release];

    // UIPasteboard
    [UIPasteboardTester runAllTests];

    // NSURLConnection
    [NSURLConnectionTester runAllTests];

    // KeyChain
//    [KeyChainTester runAllTests];

    // User Preferences
    [UserPreferencesTester runAllTests];

    // Crypto
//    [CryptoTester runAllTests];

}
@end

/* vim: set filetype=objc : */
