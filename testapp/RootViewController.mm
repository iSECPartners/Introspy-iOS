#import "RootViewController.h"

#import "FileSystemTester.h"
#import "UserPreferencesTester.h"
#import "KeyChainTester.h"
#import "CCCryptorTester.h"


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

    // KeyChain
    [KeyChainTester runAllTests];

    // User Preferences
    [UserPreferencesTester runAllTests];

    // Crypto
    [CCCryptorTester runAllTests];

}
@end
