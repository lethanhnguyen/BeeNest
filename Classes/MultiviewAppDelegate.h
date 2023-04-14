#import <UIKit/UIKit.h>

@class MultiviewViewController;

@interface MultiviewAppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    MultiviewViewController *viewController;
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MultiviewViewController *viewController;

@end

