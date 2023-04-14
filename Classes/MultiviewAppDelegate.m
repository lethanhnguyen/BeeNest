#import "MultiviewAppDelegate.h"
#import "MultiviewViewController.h"

@implementation MultiviewAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch
    [window setRootViewController:viewController];
    //[window addSubview:viewController.view];
    [window makeKeyAndVisible];            
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
