#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <AVFoundation/AVFoundation.h>
//#import <iAd/iAd.h>
#import <Social/Social.h>
#import "GADBannerView.h"

@interface MultiviewViewController : UIViewController <UIAlertViewDelegate,AVAudioPlayerDelegate>{
    UIView *view[3];
    
    UIImageView *background;
    UIImageView *matrix[25];
    UILabel *number_label[25];
    UILabel *time_count, *step;
    UIImageView *select_matrix[5];
    UILabel *select_label[5];
    
    UIView *result_panel;
    UIImageView *result_image;
    UILabel *result_bee, *result_record;
    UILabel *time_result, *time_record;
    
    UIView *next_level;
    UIImageView *level_image;
    UITextView *level_content;
    
    UIImageView *bee_image;
    
    UIView *record_panel;
    UIImageView *record_image;
    UILabel *record_bee, *record_time;
    
    UIView *howtoplay_panel;
    UIImageView *howtoplay_image;
    
    BOOL mSwiping;
	CGFloat mSwipeStartX,mSwipeStartY;
    
    AVAudioPlayer *clickSound;
    AVAudioPlayer *combineSound;
    AVAudioPlayer *levelSound;
    
    //ADBannerView *bottomAdBanner;
    GADBannerView *bannerView_;
}

- (void)showAlert:(NSString*) message;
- (void) dismissAlert;

@end


