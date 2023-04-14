#import "MultiviewViewController.h"
#import "MultiviewAppDelegate.h"

#define SafeRelease(object) \
if (object !=nil) \
{\
[object release];\
object=nil;\
}\
else\
{\
}\

@interface MultiviewViewController (){
    MultiviewAppDelegate *appDelegate;
}
@property (nonatomic, strong) UIAlertView *alert;
@end

int noofview=3;
int current_view;
int LEFT_OFFSET=14;
int TOP_OFFSET=200;
int LEFT_OFFSET1=9;
int TOP_OFFSET1=100;
int game[25];
int root_game[25];
int noofbee;
int maxofbee;
int maxtime;

int current_row, current_col;
int count_down;
int count_time;

int current_time;
int time_game[25];

int phone_type;
//1. iphone 4
//2. iphone 5
//3. ipad

//rule:
//10 bees in:
//1. 3 minutes = 180 seconds
//each step: reduce 10 seconds
//to: 30 seconds

@implementation MultiviewViewController
@synthesize alert;

- (UIImage *)newImageFromResource:(NSString *)filename
{
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], filename];
    UIImage *image = nil;
    image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    [imageFile release];
    return image;
}

- (void)viewDidLoad {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    NSLog(@"%f %f",result.width,result.height);
    
    if (result.width==768) phone_type=3;
    else{
        if (result.height==480) phone_type=1;
        else phone_type=2;
    }
    
    int scn_width, scn_height;
    scn_width=result.width;
    scn_height=result.height;
    
    for (int i=0; i<noofview; i++)
    {
        view[i] = [[UIView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
        [self.view addSubview:view[i]];
        view[i].alpha=0;
    }
    
    view[0].alpha=1;
    current_view=0;
    
    //self.canDisplayBannerAds = YES;
    /*bottomAdBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0,scn_height-66,scn_width,66)];
    if (phone_type!=3) bottomAdBanner.frame=CGRectMake(0,scn_height-50,scn_width,50);
    [self.view addSubview:bottomAdBanner];
    bottomAdBanner.alpha=0;
    bottomAdBanner.delegate=self;*/

    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
    bannerView_.frame = CGRectMake((scn_width-728)/2,scn_height-90,728,90);
    if (phone_type!=3) {
        bannerView_.adSize=kGADAdSizeBanner;
        bannerView_.frame=CGRectMake(0,scn_height-50,scn_width,50);
    }
    bannerView_.adUnitID = @"ca-app-pub-4275663316056426/6017286792";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    [bannerView_ loadRequest:[GADRequest request]];
    
    //------------------------------------------------------------------
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    if (phone_type==1) [background setImage:[UIImage imageNamed:@"i_main1.png"]];
    if (phone_type==2) [background setImage:[UIImage imageNamed:@"i_main2.png"]];
    if (phone_type==3) [background setImage:[UIImage imageNamed:@"main.png"]];
	[view[0] addSubview:background];
    
    record_panel = [[UIView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    [view[0] addSubview:record_panel];
    record_panel.alpha=0;
    
    record_image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    if (phone_type==1) [record_image setImage:[UIImage imageNamed:@"i_record1.png"]];
    if (phone_type==2) [record_image setImage:[UIImage imageNamed:@"i_record2.png"]];
    if (phone_type==3) [record_image setImage:[UIImage imageNamed:@"record.png"]];
	[record_panel addSubview:record_image];
    
    record_bee = [[UILabel alloc] initWithFrame:CGRectMake(340,447,200,30)];
    if (phone_type==1) record_bee.frame=CGRectMake(144,215,200,20);
    if (phone_type==2) record_bee.frame=CGRectMake(144,248,200,20);
    record_bee.text=@"1";
    record_bee.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) record_bee.font = [UIFont boldSystemFontOfSize:16];
    record_bee.textColor = [UIColor redColor];
    record_bee.backgroundColor = [UIColor clearColor];
    [record_panel addSubview:record_bee];
    
    record_time = [[UILabel alloc] initWithFrame:CGRectMake(530,447,200,30)];
    if (phone_type==1) record_time.frame=CGRectMake(224,215,200,20);
    if (phone_type==2) record_time.frame=CGRectMake(224,248,200,20);
    record_time.text=@"1";
    record_time.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) record_time.font = [UIFont boldSystemFontOfSize:16];
    record_time.textColor = [UIColor redColor];
    record_time.backgroundColor = [UIColor clearColor];
    [record_panel addSubview:record_time];
    
    
    howtoplay_panel = [[UIView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    [view[0] addSubview:howtoplay_panel];
    howtoplay_panel.alpha=0;
    
    howtoplay_image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    if (phone_type==1) [howtoplay_image setImage:[UIImage imageNamed:@"i_howtoplay1.png"]];
    if (phone_type==2) [howtoplay_image setImage:[UIImage imageNamed:@"i_howtoplay2.png"]];
    if (phone_type==3) [howtoplay_image setImage:[UIImage imageNamed:@"howtoplay.png"]];
	[howtoplay_panel addSubview:howtoplay_image];
    
    //------------------------------------------------------------------
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    if (phone_type==1) [background setImage:[UIImage imageNamed:@"i_game1.png"]];
    if (phone_type==2) [background setImage:[UIImage imageNamed:@"i_game2.png"]];
    if (phone_type==3) [background setImage:[UIImage imageNamed:@"game.png"]];
	[view[1] addSubview:background];
    
    for (int i=0; i<5; i++)
        for (int j=0; j<5; j++)
        {
            matrix[i*5+j] = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_OFFSET+134*j+(i%2)*(134/2),TOP_OFFSET+123*i,134,161)];
            if (phone_type!=3) matrix[i*5+j].frame=CGRectMake(LEFT_OFFSET1+55*j+(i%2)*(55/2),TOP_OFFSET1+50*i,55,66);
            [matrix[i*5+j] setImage:[UIImage imageNamed:@"nest_cell1.png"]];
            if (phone_type!=3) [matrix[i*5+j] setImage:[UIImage imageNamed:@"i_nest_cell1.png"]];
            [view[1] addSubview:matrix[i*5+j]];
            
            number_label[i*5+j] = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET+134*j+(i%2)*(134/2),TOP_OFFSET+123*i,134,161)];
            if (phone_type!=3) number_label[i*5+j].frame=CGRectMake(LEFT_OFFSET1+55*j+(i%2)*(55/2),TOP_OFFSET1+50*i,55,66);
            number_label[i*5+j].text=@"10";
            number_label[i*5+j].textAlignment=NSTextAlignmentCenter;
            number_label[i*5+j].font = [UIFont boldSystemFontOfSize:40];
            if (phone_type!=3) number_label[i*5+j].font = [UIFont boldSystemFontOfSize:20];
            number_label[i*5+j].textColor = [UIColor whiteColor];
            number_label[i*5+j].backgroundColor = [UIColor clearColor];
            [view[1] addSubview:number_label[i*5+j]];
            number_label[i*5+j].layer.shadowRadius = 3.0;
            number_label[i*5+j].layer.shadowOpacity = 0.5;
        }
    
    time_count = [[UILabel alloc] initWithFrame:CGRectMake(198,34,200,30)];
    if (phone_type!=3) time_count.frame=CGRectMake(82,10,200,20);
    time_count.text=@"00:00";
    time_count.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) time_count.font = [UIFont boldSystemFontOfSize:13];
    time_count.textColor = [UIColor redColor];
    time_count.backgroundColor = [UIColor clearColor];
    [view[1] addSubview:time_count];
    
    step = [[UILabel alloc] initWithFrame:CGRectMake(198,85,200,30)];
    if (phone_type!=3) step.frame=CGRectMake(82,30,200,20);
    step.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) step.font = [UIFont boldSystemFontOfSize:13];
    step.textColor = [UIColor redColor];
    step.backgroundColor = [UIColor clearColor];
    [view[1] addSubview:step];
    
    for (int i=0; i<5; i++)
    {
        select_matrix[i] = [[UIImageView alloc] initWithFrame:CGRectMake(209+70*i,870,70,84)];
        if (phone_type==1) select_matrix[i].frame=CGRectMake(60+40*i,370,40,48);
        if (phone_type==2) select_matrix[i].frame=CGRectMake(60+40*i,454,40,48);
        [select_matrix[i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"nest_cell%i.png",(i+1)]]];
        if (phone_type!=3) [select_matrix[i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"i_nest_cell%i.png",(i+1)]]];
        [view[1] addSubview:select_matrix[i]];
        
        select_label[i] = [[UILabel alloc] initWithFrame:CGRectMake(209+70*i,870,70,84)];
        if (phone_type==1) select_label[i].frame=CGRectMake(60+40*i,370,40,48);
        if (phone_type==2) select_label[i].frame=CGRectMake(60+40*i,454,40,48);
        select_label[i].text=[NSString stringWithFormat:@"%i",(i+1)];
        select_label[i].textAlignment=NSTextAlignmentCenter;
        select_label[i].font = [UIFont boldSystemFontOfSize:30];
        if (phone_type!=3) select_label[i].font = [UIFont boldSystemFontOfSize:15];
        select_label[i].textColor = [UIColor whiteColor];
        select_label[i].backgroundColor = [UIColor clearColor];
        [view[1] addSubview:select_label[i]];
        select_label[i].layer.shadowRadius = 3.0;
        select_label[i].layer.shadowOpacity = 0.5;
    }
    
    bee_image = [[UIImageView alloc] initWithFrame:CGRectMake(580,840,144,160)];
    if (phone_type!=3) bee_image.frame=CGRectMake(580,840,60,67);
    [bee_image setImage:[UIImage imageNamed:@"bee.png"]];
    if (phone_type!=3) [bee_image setImage:[UIImage imageNamed:@"i_bee.png"]];
	[view[1] addSubview:bee_image];
    bee_image.alpha=0;
    
    result_panel = [[UIView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    [view[1] addSubview:result_panel];
    result_panel.alpha=0;
    
    result_image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    if (phone_type==3) [result_image setImage:[UIImage imageNamed:@"result.png"]];
    if (phone_type==1) [result_image setImage:[UIImage imageNamed:@"i_result1.png"]];
    if (phone_type==2) [result_image setImage:[UIImage imageNamed:@"i_result2.png"]];
	[result_panel addSubview:result_image];
    
    result_bee = [[UILabel alloc] initWithFrame:CGRectMake(340,447,200,30)];
    if (phone_type==1) result_bee.frame=CGRectMake(142,215,200,20);
    if (phone_type==2) result_bee.frame=CGRectMake(142,254,200,20);
    result_bee.text=@"1";
    result_bee.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) result_bee.font = [UIFont boldSystemFontOfSize:16];
    result_bee.textColor = [UIColor redColor];
    result_bee.backgroundColor = [UIColor clearColor];
    [result_panel addSubview:result_bee];
    
    result_record = [[UILabel alloc] initWithFrame:CGRectMake(340,502,200,30)];
    if (phone_type==1) result_record.frame=CGRectMake(142,238,200,20);
    if (phone_type==2) result_record.frame=CGRectMake(142,277,200,20);
    result_record.text=@"1";
    result_record.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) result_record.font = [UIFont boldSystemFontOfSize:16];
    result_record.textColor = [UIColor redColor];
    result_record.backgroundColor = [UIColor clearColor];
    [result_panel addSubview:result_record];
    
    time_result = [[UILabel alloc] initWithFrame:CGRectMake(530,447,200,30)];
    if (phone_type==1) time_result.frame=CGRectMake(220,215,200,20);
    if (phone_type==2) time_result.frame=CGRectMake(220,254,200,20);
    time_result.text=@"1";
    time_result.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) time_result.font = [UIFont boldSystemFontOfSize:16];
    time_result.textColor = [UIColor redColor];
    time_result.backgroundColor = [UIColor clearColor];
    [result_panel addSubview:time_result];
    
    time_record = [[UILabel alloc] initWithFrame:CGRectMake(530,502,200,30)];
    if (phone_type==1) time_record.frame=CGRectMake(220,238,200,20);
    if (phone_type==2) time_record.frame=CGRectMake(220,277,200,20);
    time_record.text=@"1";
    time_record.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) time_record.font = [UIFont boldSystemFontOfSize:16];
    time_record.textColor = [UIColor redColor];
    time_record.backgroundColor = [UIColor clearColor];
    [result_panel addSubview:time_record];
    
    next_level = [[UIView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    [view[1] addSubview:next_level];
    next_level.alpha=0;
    
    level_image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,scn_width,scn_height)];
    if (phone_type==1) [level_image setImage:[UIImage imageNamed:@"i_next_round1.png"]];
    if (phone_type==2) [level_image setImage:[UIImage imageNamed:@"i_next_round2.png"]];
    if (phone_type==3) [level_image setImage:[UIImage imageNamed:@"next_round.png"]];
	[next_level addSubview:level_image];
    
    level_content = [[UITextView alloc] initWithFrame:CGRectMake(120,436,768-240,551-436)];
    if (phone_type==1) level_content.frame=CGRectMake(45,205,320-90,308-243);
    if (phone_type==2) level_content.frame=CGRectMake(45,243,320-90,308-243);
    level_content.text=@"1";
    level_content.font = [UIFont boldSystemFontOfSize:26];
    if (phone_type!=3) level_content.font = [UIFont boldSystemFontOfSize:12];
    level_content.textColor = [UIColor redColor];
    level_content.backgroundColor = [UIColor clearColor];
    level_content.userInteractionEnabled=NO;
    level_content.textAlignment=NSTextAlignmentJustified;
    [next_level addSubview:level_content];
    
    //------------------------------------------------------------------
    NSError *error;
    
    NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click" ofType:@"mp3"]];
    clickSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
    clickSound.delegate = self;
    [clickSound prepareToPlay];
    
    NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"combinewhite" ofType:@"mp3"]];
    combineSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
    combineSound.delegate = self;
    [combineSound prepareToPlay];
    
    NSURL *url3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"level" ofType:@"mp3"]];
    levelSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:&error];
    levelSound.delegate = self;
    levelSound.numberOfLoops = -1;
    [levelSound prepareToPlay];

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}

/*-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error in Loading Banner!");
    bottomAdBanner.alpha=0;
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"iAd banner Loaded Successfully!");
    bottomAdBanner.alpha=1;
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"iAd Banner will load!");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"iAd Banner did finish");
}*/

- (void)playClickSound{
    [clickSound play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}

- (void)animate{
    bee_image.alpha=1;
    CABasicAnimation *imageRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    imageRotation.removedOnCompletion = YES; // Do not turn back after anim. is finished
    imageRotation.fillMode = kCAFillModeForwards;
    
    imageRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    
    imageRotation.duration = 0.5;
    imageRotation.repeatCount = 1;
    
    [bee_image.layer setValue:imageRotation.toValue forKey:imageRotation.keyPath];
    [bee_image.layer addAnimation:imageRotation forKey:@"imageRotation"];
    //bee_image.alpha=0;
}

- (void)onTick{
    if (view[1].alpha==1){
        if (result_panel.alpha==0 && next_level.alpha==0){
            int minutes = floor(count_down/60);
            int seconds = trunc(count_down - minutes * 60);
            time_count.text=[NSString stringWithFormat:@"%.2i:%.2i",minutes,seconds];
            
            int stop=0;
            for (int i=0; i<25; i++){
                if (time_game[i]>0) time_game[i]--;
                if (time_game[i]==0) stop=1;
            }
            
            [self drawGame];
            if (stop==1){
                [self displayResult];
                [levelSound play];
                return;
            }
            
            if (count_down==0){
                [self displayResult];
                [levelSound play];
            }
            else {
                count_time++;
                count_down--;
            }
        }
    }
}

- (void)displayResult{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int dem_bee = [[defaults objectForKey:@"noofbee"] intValue];
    int dem_time = [[defaults objectForKey:@"nooftime"] intValue];
    
    result_panel.alpha=1;
    
    if (dem_bee<noofbee){
        [defaults setValue:[NSString stringWithFormat:@"%i",noofbee] forKey:@"noofbee"];
        [defaults setValue:[NSString stringWithFormat:@"%i",count_time] forKey:@"nooftime"];
    }
    else if (dem_bee==noofbee){
        if (dem_time>count_time){
            [defaults setValue:[NSString stringWithFormat:@"%i",noofbee] forKey:@"noofbee"];
            [defaults setValue:[NSString stringWithFormat:@"%i",count_time] forKey:@"nooftime"];
        }
    }
    
    dem_bee = [[defaults objectForKey:@"noofbee"] intValue];
    dem_time = [[defaults objectForKey:@"nooftime"] intValue];
    
    result_bee.text=[NSString stringWithFormat:@"%i",noofbee];
    result_record.text=[NSString stringWithFormat:@"%i",dem_bee];
    
    int minutes1 = floor(count_time/60);
    int seconds1 = trunc(count_time - minutes1 * 60);
    time_result.text=[NSString stringWithFormat:@"%.2i:%.2i",minutes1,seconds1];
    
    int minutes2 = floor(dem_time/60);
    int seconds2 = trunc(dem_time - minutes2 * 60);
    time_record.text=[NSString stringWithFormat:@"%.2i:%.2i",minutes2,seconds2];
}

- (void)drawGame{
    for (int i=0; i<25; i++){
        number_label[i].text=@"";
        if (time_game[i]!=-1) number_label[i].text=[NSString stringWithFormat:@"%i",time_game[i]];
    }
    
    for (int i=0; i<5; i++)
        for (int j=0; j<5; j++)
        {
            [matrix[i*5+j] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"nest_cell%i.png",game[i*5+j]]]];
        }
}

- (void)generateGame{
    noofbee=0;
    current_time=30;
    
    for (int i=0; i<25; i++) time_game[i]=-1;
    
    int tmp_count=5;
    while (tmp_count>0){
        int row=arc4random() % 5;
        int col=arc4random() % 5;
        if (time_game[row*5+col]==-1){
            time_game[row*5+col]=current_time;
            tmp_count--;
        }
    }
    
    for (int i=0; i<25; i++) game[i]=0;
    
    for (int i=0; i<5; i++){
        int count=0;
        while (count<5){
            int row=arc4random() % 5;
            int col=arc4random() % 5;
            if (game[row*5+col]==0){
                game[row*5+col]=i+1;
                count++;
            }
        }
    }
    
    [self drawGame];
    
    
}

- (int)checkValue:(int)val withRow:(int)row andCol:(int)col{
        return 1;
}

- (void)refreshData{
    for (int i=0; i<5; i++)
        for (int j=0; j<5; j++)
        {
            number_label[i*5+j].text=@"";
        }
    count_time=0;
    time_count.text=@"00:00";
    maxofbee=10;
    step.text=[NSString stringWithFormat:@"0 / %i",maxofbee];
    noofbee=0;
    maxtime=120;//300;
    count_down=maxtime;
    int minutes = floor(count_down/60);
    int seconds = trunc(count_down - minutes * 60);
    time_count.text=[NSString stringWithFormat:@"%.2i:%.2i",minutes,seconds];
    
    int minutes1 = floor(count_down/60);
    int seconds1 = trunc(count_down - minutes1 * 60);
    level_content.text=[NSString stringWithFormat:@"Level 1! In this level, you need to match 10 pairs of white cell within %i minute(s) %i second(s)!",minutes1,seconds1];
    next_level.alpha=1;
    [levelSound play];
}

- (void)chooseView:(int)idx
{
    [UIView transitionFromView:view[current_view]
                        toView:view[idx]
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        //[view[current_view] removeFromSuperview];
                        view[current_view].alpha=0;
                        current_view=idx;
                    }];
    
    view[idx].alpha=1;
    [self.view bringSubviewToFront:bannerView_];
}

- (void)startGame{
    [clickSound play];
    result_panel.alpha=0;
    [self refreshData];
    [self generateGame];
    [self chooseView:1];
}

- (void)showRecord{
    [clickSound play];
    record_panel.alpha=1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int dem_bee = [[defaults objectForKey:@"noofbee"] intValue];
    int dem_time = [[defaults objectForKey:@"nooftime"] intValue];
    
    record_bee.text=[NSString stringWithFormat:@"%i",dem_bee];
    
    int minutes1 = floor(dem_time/60);
    int seconds1 = trunc(dem_time - minutes1 * 60);
    record_time.text=[NSString stringWithFormat:@"%.2i:%.2i",minutes1,seconds1];
}

- (void)closeRecordPanel{
    [clickSound play];
    record_panel.alpha=0;
}

- (void)quitGame{
    [self chooseView:0];
    [clickSound play];
}

- (void)closeNextLevelPanel{
    next_level.alpha=0;
    [levelSound stop];
    //[clickSound play];
}

- (void)closeResultPanel{
    NSLog(@"stop");
    [self chooseView:0];
    [levelSound stop];
    //result_panel.alpha=0;
}

- (void)showInstruction{
    [clickSound play];
    howtoplay_panel.alpha=1;
}

- (void)closeInstruction{
    howtoplay_panel.alpha=0;
}

- (void)shareResult{
    [clickSound play];
    
    NSString *text = [NSString stringWithFormat:@"Wow! I got %@ bee(s) within %@",result_bee.text,time_result.text];
    UIImage *image = [UIImage imageNamed:@"icon100.png"];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, image] applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)shareRecord{
    [clickSound play];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int dem_bee = [[defaults objectForKey:@"noofbee"] intValue];
    int dem_time = [[defaults objectForKey:@"nooftime"] intValue];
    
    int minutes1 = floor(dem_time/60);
    int seconds1 = trunc(dem_time - minutes1 * 60);
    
    NSString *text = [NSString stringWithFormat:@"Wow! My record is %i bee(s) within %.2i:%.2i",dem_bee,minutes1,seconds1];
    UIImage *image = [UIImage imageNamed:@"icon100.png"];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, image] applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([touches count] != 1)
		return;
	UITouch *touch = [[event allTouches] anyObject];
	
	CGPoint touchLocation = [touch locationInView:touch.view];
	
	mSwipeStartX = touchLocation.x;
    mSwipeStartY = touchLocation.y;
	mSwiping= YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (! mSwiping)
		return;
	
	UITouch *touch = [[event allTouches] anyObject];
	
	CGPoint touchLocation = [touch locationInView:touch.view];
	
	//NSLog(@"hehe touch %f %f",touchLocation.x, touchLocation.y);
	
	float X = touchLocation.x;
	float Y = touchLocation.y;
	
	CGFloat swipeDistance = sqrt((X - mSwipeStartX)*(X - mSwipeStartX) + (Y - mSwipeStartY)*(Y - mSwipeStartY));
    NSLog(@"%f",swipeDistance);
    bee_image.alpha=0;
	
	if (swipeDistance>-30.0f && swipeDistance<30.0f)
    {
        NSLog(@"touch %f %f",X,Y);
        if (view[0].alpha==1){
            if (record_panel.alpha!=1 && howtoplay_panel.alpha!=1){
                if (phone_type==3){
                    if (X>123 && X<652){
                        if (Y>379 && Y<461) [self startGame];
                        else if (Y>477 && Y<560) [self showRecord];
                        else if (Y>576 && Y<654) [self showInstruction];
                    }
                }
                else{
                    if (X>53 && X<271){
                        if (Y>181 && Y<213) [self startGame];
                        else if (Y>237 && Y<271) [self showRecord];
                        else if (Y>294 && Y<326) [self showInstruction];
                    }
                }
            }
            else if (record_panel.alpha==1){
                if (phone_type==3){
                    if (X>103 && X<358 && Y>596 && Y<668) [self shareRecord];
                    else if (X>415 && X<671 && Y>596 && Y<668) [self closeRecordPanel];
                }
                else if (phone_type==2){
                    if (X>42 && X<150 && Y>313 && Y<345) [self shareRecord];
                    else if (X>172 && X<279 && Y>313 && Y<345) [self closeRecordPanel];
                }
                else{
                    if (X>42 && X<150 && Y>281 && Y<312) [self shareRecord];
                    else if (X>172 && X<280 && Y>281 && Y<312) [self closeRecordPanel];
                }
            }
            else{
                if (phone_type==3){
                    if (X>256 && X<512 && Y>832 && Y<906) [self closeInstruction];
                }
                else if (phone_type==2){
                    if (X>107 && X<215 && Y>419 && Y<449) [self closeInstruction];
                }
                else{
                    if (X>107 && X<215 && Y>371 && Y<402) [self closeInstruction];
                }
            }
        }
        else if (view[1].alpha==1){
            if (result_panel.alpha==0 && next_level.alpha==0){
                if (phone_type==3) {
                    if (X>648 && Y<130) [self quitGame];
                }
                else {
                    if (X>259 && Y<59) [self quitGame];
                }
            }
            else if (next_level.alpha==1){
                if (phone_type==3){
                    if (X>260 && X<513 && Y>594 && Y<669) [self closeNextLevelPanel];
                }
                else if (phone_type==2){
                    if (X>108 && X<215 && Y>320 && Y<351) [self closeNextLevelPanel];
                }
                else{
                    if (X>108 && X<215 && Y>280 && Y<312) [self closeNextLevelPanel];
                }
            }
            else{
                if (phone_type==3){
                    if (X>103 && X<358 && Y>596 && Y<668) [self shareResult];
                    else if (X>415 && X<671 && Y>596 && Y<668) [self closeResultPanel];
                }
                else if (phone_type==2){
                    if (X>42 && X<150 && Y>320 && Y<351) [self shareResult];
                    else if (X>172 && X<280 && Y>320 && Y<351) [self closeResultPanel];
                }
                else{
                    if (X>42 && X<150 && Y>281 && Y<312) [self shareResult];
                    else if (X>172 && X<280 && Y>281 && Y<312) [self closeResultPanel];
                }
            }
        }
    }
    else{
        if (view[1].alpha==1){
            if (result_panel.alpha==0 && next_level.alpha==0){
                NSLog(@"touch %f %f %f %f",mSwipeStartX,mSwipeStartY,X,Y);
                
                int row1=[self getRowWithPosX:mSwipeStartX andPosY:mSwipeStartY];
                int col1=[self getColWithPosX:mSwipeStartX andPosY:mSwipeStartY];
                //int row2=[self getRowWithPosX:X andPosY:Y];
                //int col2=[self getColWithPosX:X andPosY:Y];
                
                double degree = tanh((mSwipeStartY-Y)/(X-mSwipeStartX));
                NSLog(@"%f",degree);
                
                int togo=-1;
                if (degree<=1 && degree>0.5){
                    if (Y<mSwipeStartY) togo=1;
                    else togo=4;
                }
                if (degree>-0.5 && degree<=0.5) {
                    if (X>mSwipeStartX) togo=2;
                    else togo=5;
                }
                if (degree>=-1 && degree<-0.5) {
                    if (Y>mSwipeStartY) togo=3;
                    else togo=6;
                }
                
                NSLog(@"togo %i",togo);
                
                int row2 = [self getNextRowWithRow:row1 andCol:col1 andDegree:togo];
                int col2 = [self getNextColWithRow:row1 andCol:col1 andDegree:togo];
                
                if (row1!=-1 && row2!=-1 && col1!=-1 && col2!=-1){
                    if (row1!=row2 || col1!=col2){
                        if (game[row1*5+col1]!=game[row2*5+col2]){
                            [self swapCellWithRow1:row1 andCol1:col1 andRow2:row2 andCol2:col2];
                        }
                        else{
                            if (game[row2*5+col2]<5){
                                [self matchCellWithRow1:row1 andCol1:col1 andRow2:row2 andCol2:col2];
                            }
                            else{
                                [self winCellWithRow1:row1 andCol1:col1 andRow2:row2 andCol2:col2];
                            }
                        }
                    }
                }
                /*if (row1!=-1 && row2!=-1 && col1!=-1 && col2!=-1){
                 if ([self nearCellWithRow1:row1 andCol1:col1 andRow2:row2 andCol2:col2]){
                 if (row1!=row2 || col1!=col2){
                 if (game[row1*5+col1]!=game[row2*5+col2]){
                 [self swapCellWithRow1:row1 andCol1:col1 andRow2:row2 andCol2:col2];
                 }
                 else{
                 if (game[row2*5+col2]<5){
                 [self matchCellWithRow1:row1 andCol1:col1 andRow2:row2 andCol2:col2];
                 }
                 else{
                 [self winCellWithRow1:row1 andCol1:col1 andRow2:row2 andCol2:col2];
                 }
                 }
                 }
                 }
                 }*/
            }
        }
    }
}

- (int)getNextRowWithRow:(int)row1 andCol:(int)col1 andDegree:(int)togo{
    if (togo==1 || togo==6){
        if (row1>0) return row1-1;
    }
    if (togo==2 || togo==5){
        return row1;
    }
    if (togo==3 || togo==4){
        if (row1<4) return row1+1;
    }
    
    return -1;
}

- (int)getNextColWithRow:(int)row1 andCol:(int)col1 andDegree:(int)togo{
    if (row1%2==0){
        if (togo==1 || togo==3) return col1;
        if (togo==2){
            if (col1<4) return col1+1;
        }
        if (togo==4 || togo==5 || togo==6){
            if (col1>0) return col1-1;
        }
    }
    else{
        if (togo==1 || togo==2 || togo==3) {
            if (col1<4) return col1+1;
        }
        if (togo==4 || togo==6) return col1;
        if (togo==5){
            if (col1>0) return col1-1;
        }
    }
    
    return -1;
}

- (void)winCellWithRow1:(int)row1 andCol1:(int)col1 andRow2:(int)row2 andCol2:(int)col2{
    [combineSound play];
    NSLog(@"match %i %i",game[row1*5+col1],game[row2*5+col2]);
    game[row2*5+col2]=(arc4random() % 3)+1;
    game[row1*5+col1]=(arc4random() % 3)+1;
    noofbee++;
    bee_image.frame = CGRectMake(LEFT_OFFSET+134*col2+(row2%2)*(134/2)-5,TOP_OFFSET+123*row2,144,160);
    if (phone_type!=3) bee_image.frame = CGRectMake(LEFT_OFFSET1+55*col2+(row2%2)*(55/2),TOP_OFFSET1+50*row2,55,66);
    [self animate];
    
    int dem=0;
    if (time_game[row1*5+col1]>0){
        time_game[row1*5+col1]=-1;
        dem++;
    }
    if (time_game[row2*5+col2]>0){
        time_game[row2*5+col2]=-1;
        dem++;
    }
    
    int tmp_count=dem;
    while (tmp_count>0){
        int row=arc4random() % 5;
        int col=arc4random() % 5;
        if (time_game[row*5+col]==-1){
            time_game[row*5+col]=current_time;
            tmp_count--;
        }
    }
    
    if (noofbee==maxofbee){
        maxofbee+=10;
        if (maxtime>30){
            maxtime-=5;
            count_down+=maxtime;
        }
        if (current_time>5){
            current_time-=2;
        }
        
        int minutes1 = floor(count_down/60);
        int seconds1 = trunc(count_down - minutes1 * 60);
        
        int level = maxofbee/10;
        level_content.text=[NSString stringWithFormat:@"Level %i! In this level, you need to match 10 pairs of white cell within %i minute(s) %i second(s)!",level,minutes1,seconds1];
        time_count.text=[NSString stringWithFormat:@"%.2i:%.2i",minutes1,seconds1];
        next_level.alpha=1;
        [levelSound play];
    }
    step.text=[NSString stringWithFormat:@"%i / %i",noofbee,maxofbee];
    [self drawGame];
}

- (void)matchCellWithRow1:(int)row1 andCol1:(int)col1 andRow2:(int)row2 andCol2:(int)col2{
    //[clickSound play];
    game[row2*5+col2]++;
    game[row1*5+col1]=(arc4random() % 3)+1;
    
    int dem=0;
    if (time_game[row1*5+col1]>0){
        time_game[row1*5+col1]=-1;
        dem++;
    }
    if (time_game[row2*5+col2]>0){
        time_game[row2*5+col2]=-1;
        dem++;
    }
    
    int tmp_count=dem;
    while (tmp_count>0){
        int row=arc4random() % 5;
        int col=arc4random() % 5;
        if (time_game[row*5+col]==-1){
            time_game[row*5+col]=current_time;
            tmp_count--;
        }
    }
    
    NSLog(@"match %i %i",game[row1*5+col1],game[row2*5+col2]);
    [self drawGame];
}

- (void)swapCellWithRow1:(int)row1 andCol1:(int)col1 andRow2:(int)row2 andCol2:(int)col2{
    NSLog(@"old %i %i - %i %i - %i %i",game[row1*5+col1],game[row2*5+col2],row1,col1,row2,col2);
    int tmp = game[row1*5+col1];
    game[row1*5+col1] = game[row2*5+col2];
    game[row2*5+col2] = tmp;
    NSLog(@"new %i %i",game[row1*5+col1],game[row2*5+col2]);
    
    tmp = time_game[row1*5+col1];
    time_game[row1*5+col1] = time_game[row2*5+col2];
    time_game[row2*5+col2] = tmp;
    
    [self drawGame];
}

- (int)nearCellWithRow1:(int)row1 andCol1:(int)col1 andRow2:(int)row2 andCol2:(int)col2{
    if (row1==row2){
        if (col2==col1-1) return 1;
        if (col2==col1+1) return 1;
    }
    else if (row2==row1-1){
        if (row2%2==0){
            if (col2==col1) return 1;
            if (col2==col1+1) return 1;
        }
        else{
            if (col2==col1) return 1;
            if (col2==col1-1) return 1;
        }
    }
    else if (row2==row1+1){
        if (row2%2==0){
            if (col2==col1) return 1;
            if (col2==col1+1) return 1;
        }
        else{
            if (col2==col1) return 1;
            if (col2==col1-1) return 1;
        }
    }
    return 0;
}

- (int)getRowWithPosX:(float)X andPosY:(float)Y{
    int row;
    row=-1;
    
    if (phone_type==3){
        if (Y<203 || Y>857) return -1;
        if (Y>=203 && Y<349) row=1;
        if (Y>=349 && Y<463) row=2;
        if (Y>=463 && Y<595) row=3;
        if (Y>=595 && Y<716) row=4;
        if (Y>=716 && Y<857) row=5;
    }
    else{
        if (Y<103 || Y>368) return -1;
        if (Y>=103 && Y<162) row=1;
        if (Y>=162 && Y<209) row=2;
        if (Y>=209 && Y<261) row=3;
        if (Y>=261 && Y<309) row=4;
        if (Y>=309 && Y<368) row=5;
    }
    
    return (row-1);
}

- (int)getColWithPosX:(float)X andPosY:(float)Y{
    int row, col;
    row=-1;
    col=-1;
    
    if (phone_type==3){
        if (Y<203 || Y>857) return -1;
        
        if (Y>=203 && Y<349) row=1;
        if (Y>=349 && Y<463) row=2;
        if (Y>=463 && Y<595) row=3;
        if (Y>=595 && Y<716) row=4;
        if (Y>=716 && Y<857) row=5;
        
        if (row%2==1){
            if (X>=18 && X<150) col=1;
            if (X>=150 && X<285) col=2;
            if (X>=285 && X<421) col=3;
            if (X>=421 && X<553) col=4;
            if (X>=553 && X<685) col=5;
        }
        else{
            if (X>=85 && X<218) col=1;
            if (X>=218 && X<352) col=2;
            if (X>=352 && X<488) col=3;
            if (X>=488 && X<619) col=4;
            if (X>=619 && X<754) col=5;
        }
    }
    else{
        if (Y<103 || Y>368) return -1;
        
        if (Y>=103 && Y<162) row=1;
        if (Y>=162 && Y<209) row=2;
        if (Y>=209 && Y<261) row=3;
        if (Y>=261 && Y<309) row=4;
        if (Y>=309 && Y<368) row=5;
        
        if (row%2==1){
            if (X>=10 && X<66) col=1;
            if (X>=66 && X<119) col=2;
            if (X>=119 && X<177) col=3;
            if (X>=177 && X<232) col=4;
            if (X>=232 && X<286) col=5;
        }
        else{
            if (X>=38 && X<93) col=1;
            if (X>=93 && X<147) col=2;
            if (X>=147 && X<202) col=3;
            if (X>=202 && X<257) col=4;
            if (X>=257 && X<313) col=5;
        }
    }
    
    if (col==-1) return -1;
    
    return (col-1);
}

- (void)showAlert:(NSString *)sMessage
{
    if(!alert)
        alert = [[UIAlertView alloc] initWithTitle:nil message:sMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    else
        [alert setMessage:sMessage];
	[alert show];
}

- (void) dismissAlert{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
}


# pragma UIAlertViewDelegate
- (void)alertViewCancel:(UIAlertView *)alertView{
    
}

-(void)alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window

{
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotate {
    return YES;
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	NSLog(@"exit");
    [super dealloc];
}

@end
