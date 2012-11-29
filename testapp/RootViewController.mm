#import "RootViewController.h"

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

    //NSFileManager
    NSLog(@"**************Test**************");
    NSFileManager * fileManager = [NSFileManager defaultManager];

    //createFileAtPath
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"test.file"];
    //NSDictionary attributes;
    NSString* myString = @"testing12345";
    NSData* contents = [myString dataUsingEncoding: [NSString defaultCStringEncoding]];

   	[fileManager createFileAtPath:path contents:contents attributes:nil];


   	// End

}
@end
