//
//  TabReaderAppDelegate.m
//  TabReader
//
//  Created by spadix on 5/3/11.
//

#import "ShiftReaderAppDelegate.h"
#import "ResultsViewController.h"

@implementation TabReaderAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;

- (BOOL)            application: (UIApplication*) application
  didFinishLaunchingWithOptions: (NSDictionary*) options
{
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    // force class to load so it may be referenced directly from nib
    [ZBarReaderViewController class];

    ZBarReaderViewController *reader =
        [self.tabBarController.viewControllers objectAtIndex: 0];
    reader.readerDelegate = self;
    reader.showsZBarControls = NO;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    NSLog(@"ALL YOUR BASE ARE BELONG TO US");
    NSString *test = @"Is this how it works?";
    NSLog(@"%@", test);

    return(YES);
}

- (void) dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}


// ZBarReaderDelegate

- (void)  imagePickerController: (UIImagePickerController*) picker
  didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // do something useful with results
    UITabBarController *tabs = self.tabBarController;
    tabs.selectedIndex = 1;
    ResultsViewController *results = [tabs.viewControllers objectAtIndex: 1];
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    results.resultImage.image = image;
    NSString *test = @"Is this how it works?";
    NSLog(@"%@", test);
    id <NSFastEnumeration> syms =
    [info objectForKey: ZBarReaderControllerResults];
    for(ZBarSymbol *sym in syms) {
        NSString *url = [self ParseResults:sym.data];
        NSLog(@"%@%@", @"URL Returned from ParseResults: ", url);
        //TODO: edit results.resultText.text to include success or fail
        results.resultText.text = sym.data;
        NSLog(@"%@", results.resultText.text);
        break;
    }
}

// Format text into something I can do something with
- (NSString*) ParseResults: (NSString*) scannedtext {
    NSLog(@"%@%@", @"ParseResults, input: ", scannedtext);
    NSString *prefix = [scannedtext substringToIndex:5];
    NSLog(@"%@%@", @"ParseResults, prefix: ", prefix);
    if ([prefix isEqualToString: @"shift"]) {
        NSString *url = [NSString stringWithFormat:@"%@%@%@%@", @"http://localhost/Validate/params?token=", scannedtext, @"&user=", @"iPhone"];
        NSLog(@"%@%@", @"ParseResults, return: ", url);
        return url;
    } else {
        return nil;
    }
}

// Send results to the server
- (void) SendResults: (NSString*) url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
}

@end
