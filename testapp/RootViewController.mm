#import "RootViewController.h"
#import "DataStorageTester.h"

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
    DataStorageTester *dataStorageTests = [[DataStorageTester alloc] init];
    [dataStorageTests runAllTests];
    [dataStorageTests release];
   	// End

}
@end
