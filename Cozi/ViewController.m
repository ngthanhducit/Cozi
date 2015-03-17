//
//  ViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ViewController+Notification.h"
#import "ViewController+NetworkCommunication.h"

@interface ViewController ()

@end

static NSString         *dataNet;
static NSString         *dataNetwork;

@implementation ViewController

@synthesize lblNickName;
@synthesize shareMenu;

#define SWIPE_LEFT_CHAT -800.0f
#define SWIPE_RIGHT_CHAT 800.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.wallPageV8) {
        [self.wallPageV8 reloadData];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view endEditing:YES];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        for (NSString* family in [UIFont familyNames])
//        {
//            NSLog(@"%@", family);
//            
//            for (NSString* name in [UIFont fontNamesForFamilyName: family])
//            {
//                NSLog(@"  %@", name);
//            }
//        }
    
        [self setupNetworkStatus];
        [self initVariable];
        [self registerNotifications];
        [self initView];
    }
    
    return self;
}

- (void) setupNetworkStatus{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    hostReachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReachability startNotifier];
}

#pragma mark- init UIViewController

- (void) initVariable{
    currentPage = 0;
    isFirstLoadWall = YES;
    isFirstLoadNoise = YES;
    isVisibleChatView = NO;
    
    heightRowLeftMenu   = 40;
    alphatView = 0.6;
    heightHeader = 40;
    widthMenu = (self.view.bounds.size.width / 4) * 3;
    
    self.helperIns = [Helper shareInstance];

    isConnected = -1;
    
    isEnterBackground = NO;
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
    heightStatusBar = [UIApplication sharedApplication].statusBarFrame.size.height;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightStatusBar)];
    self.statusBarView.backgroundColor = [self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]];
    self.statusBarView.layer.zPosition = 10;
    
    [self.view addSubview:self.statusBarView];
    
    [self.view bringSubviewToFront:self.statusBarView];
    
    dataLocation = [[NSMutableData alloc] init];
    contactList = [[NSMutableArray alloc] init];
    
    self.storeIns = [Store shareInstance];
    self.coziCoreDataIns = [CoziCoreData shareInstance];
    [self.storeIns setDelegate:self];

    self.dataMapIns = [DataMap shareInstance];
    netController = [NetworkController shareInstance];
    
//    [[UINavigationBar appearance] setBarTintColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]]];
}

- (void) initView{
    
//    self.vMain = [[UIView alloc] initWithFrame:CGRectMake(0, heightStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - heightStatusBar)];
//    [self.vMain setBackgroundColor:[UIColor purpleColor]];
//    [self.vMain setClipsToBounds:YES];
//    [self.view addSubview:self.vMain];
    
    NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
    BOOL _isLogin = [_default boolForKey:@"IsLogin"];
    
    if (_isLogin) {
        
        NSInteger _userID = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"];
        [self.storeIns loadUser:(int)_userID];
        [self.storeIns loadFriend:(int)_userID];
        [self.storeIns loadFollower:(int)_userID];
        [self.storeIns getPostHistory:(int)_userID];
        //[self.storeIns getGroupChatByUserID:self.storeIns.user.userID];
        
        [self loadFriendComplete:nil];
    
        [self setup];
        
        [self initializeGestures];
        
    }else{

        self.loginPageV3 = [[SCLoginPageV3 alloc] initWithNibName:nil bundle:nil];
        [self.loginPageV3.view setFrame:self.view.bounds];
        
        [self addChildViewController:self.loginPageV3];
        [self.view addSubview:self.loginPageV3.view];
        [self.loginPageV3 didMoveToParentViewController:self];
        
    }
}

/**
 *  Register Receive All Notifications
 */
- (void) registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showListLibrary:) name:@"ShowListImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFriend:) name:@"postTapCellIndex" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResignActiveNotification:) name:@"ResignActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterBackgroundNotification:) name:@"EnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillEnterForegroundNotification:) name:@"WillEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BecomeActiveNotification:) name:@"BecomeActive" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAssetsComplete:) name:@"loadAssetsComplete" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserComplete:) name:@"loadUserComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFriendComplete:) name:@"loadFriendComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFriendComplete:) name:@"loadFriendComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWallComplete:) name:@"loadWallComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreWall:) name:@"loadMoreWall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewWall:) name:@"loadNewWall" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreNoise:) name:@"loadMoreNoise" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewNoise:) name:@"loadNewNoise" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapFriendProfile:) name:@"tapFriendProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapMyProfile:) name:@"tapMyProfile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWallAndNoises:) name:@"reloadWallAndNoises" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNoise:) name:@"selectNoiseNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSelectContact:) name:@"notificationCountSelect" object:nil];
    
    //notificationTapComment
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSelectComment:) name:@"notificationTapComment" object:nil];
    
//    notificationTapAllComment
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSelectAllComment:) name:@"notificationTapAllComment" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSelectLikes:) name:@"notificationTapLikes" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReloadListFriend:) name:@"notificationReloadListFriend" object:nil];
    
    //notificationDenyRequestChat
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDenyRequestChat:) name:@"notificationDenyRequestChat" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAllowRequestChat:) name:@"notificationAllowRequestChat" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationChatBackToHome:) name:@"notificationChatBack" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCreateNewGroup:) name:@"notificationCreateGroupChat" object:nil];
    
    //notificationOfflineMessage
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationOfflineMessage:) name:@"notificationOfflineMessage" object:nil];
}

#pragma mark- setup UIView MainPage

- (void) setup{

    //init blur view
    blurView = [[UIView alloc] initWithFrame:CGRectMake(0, heightHeader + heightStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar))];
    [blurView setAlpha:0.0f];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [blurView setUserInteractionEnabled:YES];
    
//    [self.vMain addSubview:blurView];
    [self.view addSubview:blurView];
    
    isEndScroll = YES;
    isValidCondition = YES;
    page = 1;
    _lastPage = 1;
    preLocation = CGPointMake(0, 0);
    
    self.scrollHeader = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.statusBarView.bounds.size.height, self.view.bounds.size.width, heightHeader)];
    [self.scrollHeader setContentSize:CGSizeMake(self.view.bounds.size.width * 3, heightHeader)];
    [self.scrollHeader setBackgroundColor:[UIColor clearColor]];
    [self.scrollHeader setScrollEnabled:NO];
    [self.view addSubview:self.scrollHeader];

    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heightHeader + heightStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar))];
    [mainScroll setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248.0/255.0f alpha:1]];
    [mainScroll setPagingEnabled:YES];
    [mainScroll setContentSize:CGSizeMake(self.view.bounds.size.width * 3, 0)];
    [mainScroll setShowsHorizontalScrollIndicator:NO];
    [mainScroll setShowsVerticalScrollIndicator:NO];
    [mainScroll setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [mainScroll setBounces:NO];
    [mainScroll setDelegate:self];
    [self.view addSubview:mainScroll];
    
    //property vip
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //init recent header
    [self initHeaderRecents];
    
    //===========================WALL HEADER==================
    [self initHeaderWall];
    
    //init noise header
    [self initHeaderNoise];
    
//    self.chatViewPage = [[ChatView alloc] initWithFrame:CGRectMake(-self.view.bounds.size.width, heightStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - heightStatusBar)];
//    [self.chatViewPage setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
//    [self.view addSubview:self.chatViewPage];
//    
//    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panChatView:)];
//    [self.chatViewPage addGestureRecognizer:self.pan];
    
    self.chatViewPage = [[SCChatViewV2ViewController alloc] initWithNibName:nil bundle:nil];
    [self.chatViewPage.view setFrame:CGRectMake(-self.view.bounds.size.width, heightStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - heightStatusBar)];
    [self.chatViewPage.view setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
    
    [self addChildViewController:self.chatViewPage];
    [self.view addSubview:self.chatViewPage.view];
    [self.chatViewPage didMoveToParentViewController:self];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panChatView:)];
    [self.chatViewPage.view addGestureRecognizer:self.pan];

    self.homePageV6 = [[MainPageV7 alloc] initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
    [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
    [mainScroll addSubview:self.homePageV6];
    
    self.wallPageV8 = [[SCWallTableViewV2 alloc] initWithFrame:CGRectMake(1 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height) style:UITableViewStylePlain];
    [self.wallPageV8 initWithData:nil withType:0];
    [mainScroll addSubview:self.wallPageV8];
    
    self.noisePageV6 = [[NoisesPage alloc] initWithFrame:CGRectMake(2 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
    [self.noisePageV6 setBackgroundColor:[UIColor clearColor]];
    [self.noisePageV6.scCollection initData:nil withType:0];
    [mainScroll addSubview:self.noisePageV6];

    [self.homePageV6 setAlpha:1.0f];
    
    //init status view
    viewStatusConnect = [[UIView alloc] initWithFrame:CGRectMake(0, -heightStatusBar, self.view.bounds.size.width, heightHeader)];
    [viewStatusConnect setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor4"]]];
    [viewStatusConnect setHidden:YES];
    
    lblStatusConnect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [lblStatusConnect setTextAlignment:NSTextAlignmentCenter];
    [lblStatusConnect setFont:[self.helperIns getFontLight:15.0f]];
    [lblStatusConnect setTextColor:[UIColor whiteColor]];
    
    [viewStatusConnect addSubview:lblStatusConnect];
    [self.view addSubview:viewStatusConnect];

    //init Share Menu
    vBlurShareMenu = [[UIView alloc] initWithFrame:CGRectMake(0, heightHeader + heightStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar))];
    [vBlurShareMenu setBackgroundColor:[UIColor blackColor]];
    [vBlurShareMenu setHidden:YES];
    [vBlurShareMenu setAlpha:0.0];
    [self.view addSubview:vBlurShareMenu];
    
    self.shareMenu = [[SCShareMenu alloc] initWithFrame:CGRectMake(0, -(self.view.bounds.size.width / 4), self.view.bounds.size.width, self.view.bounds.size.width / 4)];
    [self.shareMenu setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:0.4]];
    [self.shareMenu setHidden:YES];
    [self.view addSubview:self.shareMenu];
    
    [self.shareMenu.btnCamera addTarget:self action:@selector(showAddPost) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMenu.btnPhoto addTarget:self action:@selector(showAddPostPhoto:) forControlEvents:UIControlEventTouchUpInside];
//    [self.shareMenu.btnLocation addTarget:self action:@selector(showAddPostLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMenu.btnMood addTarget:self action:@selector(showAddPostMood:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initLineStatusConnect];
}

- (void) initLineStatusConnect{
    self.vLineFirstStatusConnect = [[UIView alloc] initWithFrame:CGRectMake(0, (heightStatusBar + heightHeader) - 5, self.view.bounds.size.width, 5)];
    [self.vLineFirstStatusConnect setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor4"]]];
    [self.vLineFirstStatusConnect setHidden:YES];
    [self.view addSubview:self.vLineFirstStatusConnect];
    
    self.vLineSecondStatusConnect = [[UIView alloc] initWithFrame:CGRectMake(-(self.view.bounds.size.width + heightHeader), (heightStatusBar + heightHeader) - 5, self.view.bounds.size.width, 5)];
    [self.vLineSecondStatusConnect setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor4"]]];
    [self.vLineSecondStatusConnect setHidden:YES];
    [self.view addSubview:self.vLineSecondStatusConnect];
}

- (void) initHeaderRecents{
    
    UIView *viewChat = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [viewChat setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    
    UIImage *imgContact = [self.helperIns getImageFromSVGName:@"icon-openMenu.svg"];
    
    UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnContact setImage:imgContact forState:UIControlStateNormal];
    [btnContact setFrame:CGRectMake(0, 0, heightHeader, heightHeader)];
    [btnContact setContentMode:UIViewContentModeCenter];
    [btnContact addTarget:self action:@selector(showHiddenLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [viewChat addSubview:btnContact];

    UILabel *lblChat = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, heightHeader)];
    [lblChat setText:@"CHAT"];
    [lblChat setTextAlignment:NSTextAlignmentCenter];
    [lblChat setTextColor:[UIColor whiteColor]];
    [lblChat setFont:[self.helperIns getFontLight:16.0f]];
    [viewChat addSubview:lblChat];
    
    UIImage *imgOpenMenu = [self.helperIns getImageFromSVGName:@"icon-contactSearch.svg"];
    UIButton *btnMenuFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMenuFriend setImage:imgOpenMenu forState:UIControlStateNormal];
    [btnMenuFriend setFrame:CGRectMake(heightHeader + lblChat.bounds.size.width, 0, heightHeader, heightHeader)];
    [btnMenuFriend setContentMode:UIViewContentModeCenter];
    [btnMenuFriend addTarget:self action:@selector(showHiddenRightMenu) forControlEvents:UIControlEventTouchUpInside];
    [viewChat addSubview:btnMenuFriend];
    
    [self.scrollHeader addSubview:viewChat];
}

- (void) initHeaderWall{
    UIView *viewWall = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, heightHeader)];
    [viewWall setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    
    UIImage *imgContact = [self.helperIns getImageFromSVGName:@"icon-openMenu.svg"];
    
    UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnContact setImage:imgContact forState:UIControlStateNormal];
    [btnContact setFrame:CGRectMake(0, 0, heightHeader, heightHeader)];
    [btnContact setContentMode:UIViewContentModeCenter];
    [btnContact addTarget:self action:@selector(showHiddenLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [viewWall addSubview:btnContact];

    UILabel *lblWall = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, heightHeader)];
    [lblWall setText:@"WALL"];
    [lblWall setTextAlignment:NSTextAlignmentCenter];
    [lblWall setTextColor:[UIColor whiteColor]];
    [lblWall setFont:[self.helperIns getFontLight:16.0f]];
    [lblWall setUserInteractionEnabled:YES];
    
    [viewWall addSubview:lblWall];
    
    UIButton *btnShareMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShareMenu setFrame:CGRectMake(40 + lblWall.bounds.size.width, 0, 40, 40)];
    [btnShareMenu setTitle:@"+" forState:UIControlStateNormal];
    [btnShareMenu.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [btnShareMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnShareMenu addTarget:self action:@selector(showShareMenu) forControlEvents:UIControlEventTouchUpInside];
    [viewWall addSubview:btnShareMenu];
    
    [self.scrollHeader addSubview:viewWall];
}

- (void) initHeaderNoise{
    
    UIView *vNoise = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 2, 0, self.view.bounds.size.width, heightHeader)];
    [vNoise setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    
    UILabel *lblNoise = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [lblNoise setText:@"MARKET PLACE"];
    [lblNoise setTextAlignment:NSTextAlignmentCenter];
    [lblNoise setTextColor:[UIColor whiteColor]];
    [lblNoise setFont:[self.helperIns getFontLight:16.0f]];
    
    [vNoise addSubview:lblNoise];

    [self.scrollHeader addSubview:vNoise];

}

/**
 *  Init Left Menu
 */
- (void) initLeftMenu{
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(-widthMenu - 5, heightHeader + heightStatusBar, widthMenu, self.view.bounds.size.height - (heightHeader + heightStatusBar))];
    [leftView setBackgroundColor:[UIColor whiteColor]];
    leftView.layer.shadowColor = [UIColor blackColor].CGColor;
    leftView.layer.shadowOffset = CGSizeMake(3, 0);
    leftView.layer.shadowOpacity = 0.3f;
    leftView.layer.shadowRadius = 1;
    
    [self.view addSubview:leftView];
    
//    UIImage *imgWhite;
//    if (self.storeIns.user.avatar) {
//        GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
//        imgWhite = [grayscaleFilter imageByFilteringImage:self.storeIns.user.avatar];
//    }else{
//        imgWhite = [self.helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"];
//    }
    
    UIImageView *imgAvatar = [[UIImageView alloc] initWithImage:self.storeIns.user.avatar];
    [imgAvatar setUserInteractionEnabled:YES];
    [imgAvatar setFrame:CGRectMake(leftView.bounds.size.width / 2 - (40), 30, 80, 80)];
    [imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    [imgAvatar setClipsToBounds:YES];
    imgAvatar.layer.cornerRadius = imgAvatar.bounds.size.width / 2;
    [leftView addSubview:imgAvatar];
    
    UITapGestureRecognizer *tapImgAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyProfile:)];
    [tapImgAvatar setNumberOfTapsRequired:1];
    [tapImgAvatar setNumberOfTouchesRequired:1];
    [imgAvatar addGestureRecognizer:tapImgAvatar];
    
    UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(0, imgAvatar.frame.origin.y + imgAvatar.bounds.size.height + 10, widthMenu, heightRowLeftMenu)];
    [lblFullName setUserInteractionEnabled:YES];
    [lblFullName setText:[self.storeIns.user.nickName uppercaseString]];
    [lblFullName setTextColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    [lblFullName setBackgroundColor:[UIColor clearColor]];
    [lblFullName setTextAlignment:NSTextAlignmentCenter];
    [lblFullName setFont:[self.helperIns getFontLight:20]];
    
    [leftView addSubview:lblFullName];
    
    UITapGestureRecognizer *tapFullName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyProfile:)];
    [tapFullName setNumberOfTouchesRequired:1];
    [tapFullName setNumberOfTapsRequired:1];
    [lblFullName addGestureRecognizer:tapFullName];
    
    CALayer *bottomUserName = [CALayer layer];
    [bottomUserName setFrame:CGRectMake(0.0f, lblFullName.frame.origin.y + lblFullName.bounds.size.height + 1, leftView.bounds.size.width, 0.5f)];
    [bottomUserName setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [leftView.layer addSublayer:bottomUserName];

    ///Menu Line
    UIImage *imgShareToWall = [self.helperIns getImageFromSVGName:@"form-icon-username"];
//    UIButton *btnShareToWall = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnShareToWall setFrame:CGRectMake(0, bottomUserName.frame.origin.y + bottomUserName.bounds.size.height + 5, widthMenu, heightRowLeftMenu)];
//    [btnShareToWall setTitle:@"SHARE TO WALL" forState:UIControlStateNormal];
//    [btnShareToWall setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [btnShareToWall setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [btnShareToWall setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [btnShareToWall.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
//    [btnShareToWall setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [btnShareToWall setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnShareToWall setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [btnShareToWall setImage:imgShareToWall forState:UIControlStateNormal];
    UIColor *colorSignInNormal = [UIColor whiteColor];
    UIColor *colorSignInHighLight = [self.helperIns colorFromRGBWithAlpha:[self.helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:0.8f];
//    [btnShareToWall setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
//    [btnShareToWall setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
//    
//    [leftView addSubview:btnShareToWall];

//    UIButton *btnNewChat = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnNewChat setFrame:CGRectMake(0, btnShareToWall.frame.origin.y + btnShareToWall.bounds.size.height, widthMenu, heightRowLeftMenu)];
//    [btnNewChat setTitle:@"NEW CHAT" forState:UIControlStateNormal];
//    [btnNewChat.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
//    [btnNewChat setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [btnNewChat setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [btnNewChat setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [btnNewChat setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [btnNewChat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnNewChat setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [btnNewChat setImage:imgShareToWall forState:UIControlStateNormal];
//    [btnNewChat setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
//    [btnNewChat setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
//    
//    [leftView addSubview:btnNewChat];

    btnFriendRequest = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFriendRequest setFrame:CGRectMake(0, bottomUserName.frame.origin.y + bottomUserName.bounds.size.height + 5, widthMenu, heightRowLeftMenu)];
    [btnFriendRequest setTitle:@"FRIEND REQUESTS" forState:UIControlStateNormal];
    [btnFriendRequest.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnFriendRequest setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnFriendRequest setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnFriendRequest setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnFriendRequest setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnFriendRequest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFriendRequest setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnFriendRequest setImage:imgShareToWall forState:UIControlStateNormal];
    [btnFriendRequest setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnFriendRequest setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    [btnFriendRequest addTarget:self action:@selector(btnShowFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:btnFriendRequest];

    
    UIButton *btnLookAround = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLookAround setFrame:CGRectMake(0, btnFriendRequest.frame.origin.y + btnFriendRequest.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnLookAround setTitle:@"LOOK AROUND" forState:UIControlStateNormal];
    [btnLookAround.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnLookAround setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLookAround setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnLookAround setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLookAround setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLookAround setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLookAround setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnLookAround setImage:imgShareToWall forState:UIControlStateNormal];
    [btnLookAround addTarget:self action:@selector(btnShowLookAround:) forControlEvents:UIControlEventTouchUpInside];
    [btnLookAround setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnLookAround setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [leftView addSubview:btnLookAround];
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLocation setFrame:CGRectMake(0, btnLookAround.frame.origin.y + btnLookAround.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnLocation setTitle:@"SETTINGS" forState:UIControlStateNormal];
    [btnLocation.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnLocation setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLocation setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnLocation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLocation setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnLocation setImage:imgShareToWall forState:UIControlStateNormal];
    [btnLocation setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnLocation setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [leftView addSubview:btnLocation];

    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogout setFrame:CGRectMake(0, btnLocation.frame.origin.y + btnLocation.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnLogout setTitle:@"LOGOUT" forState:UIControlStateNormal];
    [btnLogout.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnLogout setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLogout setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnLogout setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLogout setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnLogout setImage:imgShareToWall forState:UIControlStateNormal];
    [btnLogout setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnLogout setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    [btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    [leftView addSubview:btnLogout];
}

/**
 *  Init Right Menu
 */
- (void) initRightMenu{
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width + 5, heightHeader + heightStatusBar, widthMenu, self.view.bounds.size.height - (heightHeader + heightStatusBar))];
    [rightView setBackgroundColor:[UIColor whiteColor]];
    
    rightView.layer.shadowColor = [UIColor blackColor].CGColor;
    rightView.layer.shadowOffset = CGSizeMake(-3, 0);
    rightView.layer.shadowOpacity = 0.3f;
    rightView.layer.shadowRadius = 1;
    
    [self.view addSubview:rightView];
    
    searchRightMenu = [[SCSearchBar alloc] initWithFrame:CGRectMake(0, 0, rightView.bounds.size.width - 49, 39)];
    [searchRightMenu setPlaceholder:@"SEARCH FRIENDS"];
//    [searchRightMenu setBackgroundColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
//    [searchRightMenu setTintColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
    
//    [searchRightMenu setBackgroundColor:[UIColor clearColor]];
//    [searchRightMenu setTintColor:[UIColor whiteColor]];

//    [searchRightMenu setUserInteractionEnabled:NO];
    [searchRightMenu setDelegate:self];
    [searchRightMenu setKeyboardAppearance:UIKeyboardAppearanceDark];
    [searchRightMenu setReturnKeyType:UIReturnKeySearch];
    
    [rightView addSubview:searchRightMenu];
    
    //init Button
    btnSearchFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearchFriend setFrame:CGRectMake(rightView.bounds.size.width - 50, 0, 50, 39)];
    [btnSearchFriend setTitle:@"+" forState:UIControlStateNormal];
    [btnSearchFriend.titleLabel setFont:[self.helperIns getFontLight:18.0f]];
    [btnSearchFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSearchFriend setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    [btnSearchFriend addTarget:self action:@selector(btnSearchFriend:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:btnSearchFriend];

    CALayer *bottomSearch = [CALayer layer];
    [bottomSearch setFrame:CGRectMake(0.0f, 39.5, rightView.bounds.size.width, 0.5f)];
    [bottomSearch setBackgroundColor:[UIColor whiteColor].CGColor];
    [rightView.layer addSublayer:bottomSearch];
    
    tbContact = [[SCContactTableView alloc] initWithFrame:CGRectMake(0, 40, rightView.bounds.size.width, rightView.bounds.size.height - 40) style:UITableViewStylePlain];
//    NSMutableArray   *items = self.storeIns.friends;
    [tbContact setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive | UIScrollViewKeyboardDismissModeOnDrag];
    [tbContact initData:self.storeIns.friends];
    [tbContact reloadData];
    [rightView addSubview:tbContact];
    
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor whiteColor]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [self.helperIns imageWithView:triangleJoinNow];
    
    self.btnNewChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnNewChat setFrame:CGRectMake(0, rightView.bounds.size.height, rightView.bounds.size.width, 80)];
    [self.btnNewChat setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    [self.btnNewChat setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnNewChat.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnNewChat setContentMode:UIViewContentModeCenter];
    [self.btnNewChat setTitle:@"START NEW CHAT" forState:UIControlStateNormal];
//    [self.btnNewChat setTitleColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]] forState:UIControlStateNormal];
    [self.btnNewChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnNewChat addTarget:self action:@selector(btnNewChatClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNewChat.titleLabel setFont:[self.helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnNewChat.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading| NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[self.helperIns getFontLight:15.0f]} context:nil].size;
    
    [self.btnNewChat setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnNewChat.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [rightView addSubview:self.self.btnNewChat];
}

/**
 *  init Gestures
 */
-(void)initializeGestures{

//    UIScreenEdgePanGestureRecognizer *leftRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftRecognizer:)];
//    leftRecognizer.edges = UIRectEdgeLeft;
//    leftRecognizer.delegate = self;
//    
//    [mainScroll addGestureRecognizer:leftRecognizer];
//    
//    UIScreenEdgePanGestureRecognizer *rightRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightRecognizer:)];
//    rightRecognizer.edges = UIRectEdgeRight;
//    rightRecognizer.delegate = self;
//    
//    [mainScroll addGestureRecognizer:rightRecognizer];
    
}

- (void)handlePan:(UISwipeGestureRecognizer *)recognizer{
    
    CGPoint touchPoint = [recognizer locationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        beginShowMenu = NO;
        beginShowRightMenu = NO;
        isValidCondition = YES;
        
        if (page != 0) {
            //check if menu show < 1/2 size then hidden
            [mainScroll setScrollEnabled:YES];
        }
        
        //show or hidden menu left
        if (leftView.frame.origin.x < -100) {
            [UIView animateWithDuration:0.3f animations:^{
                [blurView setAlpha:0.0];
                
                [leftView setFrame:CGRectMake(-(self.view.bounds.size.width / 2), 30, leftView.bounds.size.width, leftView.bounds.size.height)];
                
            } completion:^(BOOL finished) {
                showSiderBar = NO;
            }];
        }else{
            [UIView animateWithDuration:0.3f animations:^{
                [blurView setAlpha:0.5];
                [leftView setFrame:CGRectMake(0, 30, leftView.bounds.size.width, leftView.bounds.size.height)];
                
            } completion:^(BOOL finished) {
                [self.view bringSubviewToFront:leftView];
                showSiderBar = YES;
                [mainScroll setScrollEnabled:NO];
            }];
        }
        
        if (!showSiderBar) {
            //show or hidden menu right
            if (rightView.frame.origin.x < self.view.bounds.size.width - 100) {
                [UIView animateWithDuration:0.3f animations:^{
                    [blurView setAlpha:0.5];
                    [rightView setFrame:CGRectMake((self.view.bounds.size.width / 6) * 2, 30, rightView.bounds.size.width, rightView.bounds.size.height)];
                    
                } completion:^(BOOL finished) {
                    showRightMenu = YES;
                    [self.view bringSubviewToFront:rightView];
                    [mainScroll setScrollEnabled:NO];
                }];
            }else{
                [UIView animateWithDuration:0.3f animations:^{
                    [blurView setAlpha:0.0];
                    [rightView setFrame:CGRectMake(self.view.bounds.size.width, 30, rightView.bounds.size.width, rightView.bounds.size.height)];
                    
                } completion:^(BOOL finished) {
                    showRightMenu = NO;
                }];
            }
        }
        
    }else{
        if (showSiderBar || showRightMenu) {
            if (showSiderBar) {
                if (touchPoint.x < preLocation.x) {
                    [mainScroll setScrollEnabled:NO];
                    CGFloat delta = touchPoint.x - preLocation.x;
                    [UIView animateWithDuration:0.1 animations:^{
                        
                        blurView.alpha += delta / (self.view.bounds.size.width / 2);
                        [self.view bringSubviewToFront:blurView];
                        
                        [leftView setFrame:CGRectMake(leftView.frame.origin.x + delta, 30, leftView.bounds.size.width, leftView.bounds.size.height)];
                        [self.view bringSubviewToFront:leftView];
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
            
            if (showRightMenu) {
                if (touchPoint.x > preLocation.x) {
                    [mainScroll setScrollEnabled:NO];
                    CGFloat delta = touchPoint.x - preLocation.x;
                    [UIView animateWithDuration:0.1 animations:^{
                        [rightView setFrame:CGRectMake(rightView.frame.origin.x + delta, 30, rightView.bounds.size.width, rightView.bounds.size.height)];
                        [self.view bringSubviewToFront:rightView];
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
        }else{
            
            if (beginShowMenu == YES || beginShowRightMenu) {
                
                //begin show menu left
                if (beginShowMenu) {
                    [mainScroll setScrollEnabled:NO];
                    CGFloat delta = touchPoint.x - preLocation.x;
                    
                    [UIView animateWithDuration:0.1 animations:^{
                        CGFloat deltaLeftView = leftView.frame.origin.x + delta;
                        if (deltaLeftView < 0) {
                            
                            blurView.alpha += delta / (self.view.bounds.size.width / 2);
                            [self.view bringSubviewToFront:blurView];

                            [leftView setFrame:CGRectMake(leftView.frame.origin.x + delta, 30, leftView.bounds.size.width, leftView.bounds.size.height)];
                            [self.view bringSubviewToFront:leftView];
                            
                        }
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
                //begin show menu right
                if (beginShowRightMenu) {
                    [mainScroll setScrollEnabled:NO];
                    CGFloat delta = preLocation.x - touchPoint.x;
                    [UIView animateWithDuration:0.1 animations:^{
                        CGFloat deltaRightView = rightView.frame.origin.x - delta;
                        if (deltaRightView > (self.view.bounds.size.width / 6) * 2) {
                            [rightView setFrame:CGRectMake(rightView.frame.origin.x - delta, 30, rightView.bounds.size.width, rightView.bounds.size.height)];
                            [self.view bringSubviewToFront:rightView];
                        }
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
            }else{
                //show menu left
                if (touchPoint.x > 0 && touchPoint.x < 50 && touchPoint.x > preLocation.x) {
                    
                    isValidCondition = YES;
                    //hidden menu right if is show
                    if (showRightMenu) {
                        [UIView animateWithDuration:0.1 animations:^{
                            [rightView setFrame:CGRectMake(self.view.bounds.size.width, 30, rightView.bounds.size.width, rightView.bounds.size.height)];
                            showRightMenu = NO;
                            beginShowRightMenu = NO;
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                    
                    //begin show menu left
                    beginShowMenu = YES;
                    [mainScroll setScrollEnabled:NO];
                    CGFloat delta = touchPoint.x - preLocation.x;
                    
                    [UIView animateWithDuration:0.1 animations:^{
                        CGFloat deltaLeftView = leftView.frame.origin.x + delta;
                        if (deltaLeftView < 0) {
                            [leftView setFrame:CGRectMake(leftView.frame.origin.x + delta, 30, leftView.bounds.size.width, leftView.bounds.size.height)];
                            [self.view bringSubviewToFront:leftView];
                        }
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }else if(touchPoint.x < self.view.bounds.size.width && touchPoint.x > self.view.bounds.size.width - 50 && touchPoint.x < preLocation.x){

                    isValidCondition = YES;
                    
                    //hidden menu left if is show
                    if (showSiderBar) {
                        [UIView animateWithDuration:0.1 animations:^{
                            [leftView setFrame:CGRectMake(-(self.view.bounds.size.width / 2), 30, leftView.bounds.size.width, leftView.bounds.size.height)];
                            showSiderBar = NO;
                            beginShowMenu = NO;
                        } completion:^(BOOL finished) {
                            
                        }];
                    }

                    //begin show menu right
                    beginShowRightMenu = YES;
                    [mainScroll setScrollEnabled:NO];
                    CGFloat delta = preLocation.x - touchPoint.x;
                    
                    [UIView animateWithDuration:0.1 animations:^{
                        
                        CGFloat deltaRightView = rightView.frame.origin.x - delta;
                        if (deltaRightView > 0) {
                            [rightView setFrame:CGRectMake(rightView.frame.origin.x - delta, 30, rightView.bounds.size.width, rightView.bounds.size.height)];
                            [self.view bringSubviewToFront:rightView];
                        }
                    }];
                    
                }else{
                    isValidCondition = NO;

                    if (mainScroll.contentOffset.x < self.view.bounds.size.width && touchPoint.x > preLocation.x) {
                        [mainScroll setScrollEnabled:NO];
                    }
                    
                    if (page == 0) {
                        [mainScroll setScrollEnabled:NO];
                    }
                }
            }
            //end if
        }
        
    }
    
    preLocation = touchPoint;
}

/**
 *  swipe left show menu
 *
 *  @param recognizer EdgePanGestureRecognizer
 */
- (void)handleLeftRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        
        [mainScroll setScrollEnabled:NO];
        
        deltaLeft = touchPoint.x - preLocation.x;
        
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGFloat deltaLeftView = leftView.frame.origin.x + deltaLeft;
            if (deltaLeftView < 0 && deltaLeftView >= -widthMenu) {
                [leftView setFrame:CGRectMake(leftView.frame.origin.x + deltaLeft, heightHeader, widthMenu, self.view.bounds.size.height - heightHeader)];
                
                CGFloat deltaAlpha = (alphatView * deltaLeft) / (widthMenu);
                blurView.alpha += deltaAlpha;
                
                [self.view bringSubviewToFront:blurView];
                [self.view bringSubviewToFront:leftView];
                
                [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaLeft, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            }
        } completion:^(BOOL finished) {
            
        }];
        
    } else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        
        if (deltaLeft < 0) {
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [leftView setFrame:CGRectMake(-widthMenu, heightHeader, widthMenu, leftView.bounds.size.height)];
                
                [blurView setAlpha:0.0];
                
                [self.view bringSubviewToFront:blurView];
                [self.view bringSubviewToFront:leftView];
                
                [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                
            } completion:^(BOOL finished) {
                isShowMenuLeft = NO;
            }];
        }else{
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [leftView setFrame:CGRectMake(0, heightHeader, widthMenu , leftView.bounds.size.height)];
                [blurView setAlpha:alphatView];
                
                [self.view bringSubviewToFront:blurView];
                [self.view bringSubviewToFront:leftView];
                
                [mainScroll setFrame:CGRectMake(widthMenu, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            } completion:^(BOOL finished) {
                isShowMenuLeft = YES;
            }];
            
        }
        
        [mainScroll setScrollEnabled:YES];
    }
    
    preLocation = touchPoint;
}

/**
 *  swipe right show menu
 *
 *  @param recognizer EdgePanGestureRecognizer
 */
- (void)handleRightRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        
        [mainScroll setScrollEnabled:NO];
        
        deltaRight = touchPoint.x - preLocation.x;
        
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGFloat deltaRightView = rightView.frame.origin.x + deltaRight;
            
            if (deltaRightView > (self.view.bounds.size.width / 4) && deltaRightView < self.view.bounds.size.width) {
                [rightView setFrame:CGRectMake(rightView.frame.origin.x + deltaRight, heightHeader, widthMenu, self.view.bounds.size.height)];
                
                CGFloat deltaAlpha = (alphatView * deltaRight) / widthMenu;
                blurView.alpha -= deltaAlpha;
                
                [self.view bringSubviewToFront:blurView];
                [self.view bringSubviewToFront:rightView];
                
                [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaRight, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    } else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){

        if (deltaRight > 0) {
            
            //hidden menu right
            //hidden menu
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [rightView setFrame:CGRectMake(self.view.bounds.size.width, heightHeader, widthMenu, self.view.bounds.size.height)];
                
                [blurView setAlpha:0.0];
                
                [self.view bringSubviewToFront:blurView];
                [self.view bringSubviewToFront:rightView];
                
                [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            } completion:^(BOOL finished) {
                isShowMenuRight = NO;
            }];
            
        }else{
            //show menu right
            
            //show menu
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [rightView setFrame:CGRectMake((self.view.bounds.size.width / 4), heightHeader, widthMenu, self.view.bounds.size.height)];
                
                [blurView setAlpha:alphatView];
                
                [self.view bringSubviewToFront:blurView];
                [self.view bringSubviewToFront:rightView];
                
                [mainScroll setFrame:CGRectMake(-widthMenu, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            } completion:^(BOOL finished) {
                isShowMenuRight = YES;
            }];
        }
        
        if (rightView.frame.origin.x < self.view.bounds.size.width - 5) {
            
            
        }else{
            
        }
        
        [mainScroll setScrollEnabled:YES];
    }
    
    preLocation = touchPoint;
    
}

- (void) panChatView:(UIPanGestureRecognizer*)recognizer{
    
    // Get the translation in the view
    CGPoint t = [recognizer translationInView:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    // TODO: Here, you should translate your target view using this translation
    CGFloat deltaMove = self.chatViewPage.view.frame.origin.x + t.x;
    
    if (deltaMove < 0) {
        
        self.chatViewPage.view.center = CGPointMake(self.chatViewPage.view.center.x + t.x, self.chatViewPage.view.center.y);
        mainScroll.center = CGPointMake(mainScroll.center.x + t.x, mainScroll.center.y);
        self.scrollHeader.center = CGPointMake(self.scrollHeader.center.x + t.x, self.scrollHeader.center.y);
        [self.view endEditing:YES];
        
        [self.chatViewPage.chatToolKit reset];
        
        // But also, detect the swipe gesture
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            CGPoint vel = [recognizer velocityInView:recognizer.view];
            
            if (vel.x < SWIPE_LEFT_CHAT)
            {
                isVisibleChatView = NO;
                
                //move to left
                //reset move
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [self.chatViewPage.view setFrame:CGRectMake(-self.view.bounds.size.width, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
                    [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                    [self.scrollHeader setFrame:CGRectMake(0, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
                } completion:^(BOOL finished) {
                    [self.homePageV6.scCollection reloadData];
                }];
            }
            else if (vel.x > SWIPE_RIGHT_CHAT)
            {
                //move to right
                
            }else{
                if (mainScroll.frame.origin.x < self.view.bounds.size.width / 2) {
                    //reset move
                    isVisibleChatView = NO;
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.chatViewPage.view setFrame:CGRectMake(-self.view.bounds.size.width, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
                        [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                        [self.scrollHeader setFrame:CGRectMake(0, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        [self.homePageV6.scCollection reloadData];
                    }];
                }else{
                    //reset to right
                    isVisibleChatView = YES;
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.chatViewPage.view setFrame:CGRectMake(0, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
                        [mainScroll setFrame:CGRectMake(self.view.bounds.size.width, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                        [self.scrollHeader setFrame:CGRectMake(self.view.bounds.size.width, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
            
        }
    }
    

}

#pragma -mark Touch Delegate
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (touch.view == vBlurShareMenu) {
        [self.view endEditing:YES];
        [self showShareMenu];
    }
    
    if (touch.view == blurView) {
        [self.view endEditing:YES];
        [self hiddenMenu];
    }
    
    preTouchLocation = touchLocation;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if ([touch view] == blurView) {
        deltaMoveBlurView = touchLocation.x - preTouchLocation.x;
        //swipe left
        if (deltaMoveBlurView < 0) {
            
            //process menu left
            if (isShowMenuLeft) {
                CGFloat tempDelta = leftView.frame.origin.x + deltaMoveBlurView;
                if (tempDelta > -widthMenu) {
                    
                    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        
                        [leftView setFrame:CGRectMake(leftView.frame.origin.x + deltaMoveBlurView, heightHeader, widthMenu, self.view.bounds.size.height)];
                        CGFloat deltaAlpha = (alphatView * deltaMoveBlurView) / widthMenu;
                        blurView.alpha += deltaAlpha;
                        
                        [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaMoveBlurView, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }
                
            }
            
            //process menu right
            if (isShowMenuRight) {
                
                CGFloat tempDeltaRight = rightView.frame.origin.x + deltaMoveBlurView;
                if (tempDeltaRight > (self.view.bounds.size.width / 4) && rightView.frame.origin.x > self.view.bounds.size.width / 4) {
                    
                    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        
                        [rightView setFrame:CGRectMake(rightView.frame.origin.x + deltaMoveBlurView, heightHeader, widthMenu, self.view.bounds.size.height)];
                        CGFloat deltaAlpha = (alphatView * deltaMoveBlurView) / widthMenu;
                        blurView.alpha -= deltaAlpha;
                        
                        [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaMoveBlurView, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }
                
            }
        }else{//swipe right
            
            if (isShowMenuLeft) {
                CGFloat _delta = leftView.frame.origin.x + deltaMoveBlurView;
                if (leftView.frame.origin.x < 0 && _delta < 0) {
                    
                    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [leftView setFrame:CGRectMake(leftView.frame.origin.x + deltaMoveBlurView, heightHeader, widthMenu, self.view.bounds.size.height)];
                        CGFloat deltaAlpha = (alphatView * deltaMoveBlurView) / widthMenu;
                        blurView.alpha += deltaAlpha;
                        
                        [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaMoveBlurView, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
            
            if (isShowMenuRight) {
                
                CGFloat _delta = rightView.frame.origin.x + deltaMoveBlurView;
                if (_delta < self.view.bounds.size.width) {
                    
                    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [rightView setFrame:CGRectMake(rightView.frame.origin.x + deltaMoveBlurView, heightHeader, widthMenu, self.view.bounds.size.height)];
                        CGFloat deltaAlpha = (alphatView * deltaMoveBlurView) / widthMenu;
                        blurView.alpha -= deltaAlpha;
                        
                        [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaMoveBlurView, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
        }
        
        preTouchLocation = touchLocation;
        
    }
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == blurView) {
        //process menu left
        if (deltaMoveBlurView < 0) {
            
            if (isShowMenuLeft) {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [leftView setFrame:CGRectMake(-widthMenu - 2, heightHeader, widthMenu, self.view.bounds.size.height)];
                    
                    [blurView setAlpha:0.0];
                    
                    [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                    
                } completion:^(BOOL finished) {
                    isShowMenuLeft = NO;
                }];
            }
            
            if (isShowMenuRight) {
                
                //                //show menu
                if (rightView.frame.origin.x > self.view.bounds.size.width / 4) {
                    
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [rightView setFrame:CGRectMake(self.view.bounds.size.width / 4, heightHeader, widthMenu, self.view.bounds.size.height)];
                        [blurView setAlpha:alphatView];
                        
                        [mainScroll setFrame:CGRectMake(-widthMenu, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        isShowMenuRight = YES;
                    }];
                    
                }
            }
            
        }else{
            
            if (isShowMenuLeft) {
                
                if (leftView.frame.origin.x < 0) {
                    
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [leftView setFrame:CGRectMake(0, heightHeader, widthMenu, self.view.bounds.size.height)];
                        [blurView setAlpha:alphatView];
                        
                        [mainScroll setFrame:CGRectMake(widthMenu, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        isShowMenuLeft = YES;
                    }];
                    
                }
            }
            
            if (isShowMenuRight) {
                
                //                //show menu
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [rightView setFrame:CGRectMake(self.view.bounds.size.width + 2, heightHeader, widthMenu, self.view.bounds.size.height)];
                    [blurView setAlpha:0.0];
                    
                    [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                } completion:^(BOOL finished) {
                    isShowMenuRight = NO;
                }];
                
            }
            
        }
        
    }
}

#pragma -mark UIScrollView Delegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    beginScroll = scrollView.contentOffset;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{

    if ([scrollView isMemberOfClass:[mainScroll class]]) {
        CGPoint offsetHeader = CGPointMake(scrollView.contentOffset.x, 0);
        self.scrollHeader.contentOffset = offsetHeader;
        
        [self.chatViewPage.view endEditing:YES];
        
        CGFloat pageWidth = mainScroll.frame.size.width;
        int cPage = floor((mainScroll.contentOffset.x - (pageWidth / 2)) / pageWidth) + 1;
        
        page = cPage;
        
        //get current page
        switch (currentPage) {
            case 0:{
                [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    CGFloat deltaMove = scrollView.contentOffset.x - preScrollLocation.x;
                    CGFloat deltaAlpha = (alphatView * deltaMove) / self.view.bounds.size.width;
                    
                    [self.homePageV6 setAlpha:(self.homePageV6.alpha - deltaAlpha)];
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
                
                break;
                
            case 1:{
                [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    
                    CGFloat deltaMove = scrollView.contentOffset.x - preScrollLocation.x;
                    CGFloat deltaAlpha = (alphatView * deltaMove) / self.view.bounds.size.width;
                    
                    if (beginScroll.x < scrollView.contentOffset.x) {
                        //move right
                        self.wallPageV8.alpha -= (deltaAlpha);
                    }else{
                        //move left;
                        self.wallPageV8.alpha += (deltaAlpha);
                    }
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
                break;
                
            case 2:{
                [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    
                    CGFloat deltaMove = scrollView.contentOffset.x - preScrollLocation.x;
                    CGFloat deltaAlpha = (alphatView * deltaMove) / self.view.bounds.size.width;
                    
                    if (beginScroll.x < scrollView.contentOffset.x) {
                        //move right
                        self.noisePageV6.alpha -= (deltaAlpha);
                    }else{
                        //move left;
                        self.noisePageV6.alpha += (deltaAlpha);
                    }
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
                break;
                
            case 3:{
                
            }
                break;
        }
        
//        if (scrollView.contentOffset.x >= 0) {
//            [UIView animateWithDuration:0.1 animations:^{
//                [rmLine setFrame:CGRectMake((scrollView.contentOffset.x / 3) + 0.5, rmLine.frame.origin.y, rmLine.bounds.size.width, rmLine.bounds.size.height)];
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
    }
    
    preScrollLocation = scrollView.contentOffset;
    
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.homePageV6.scCollection reloadData];
//    });

    if (scrollView == mainScroll) {
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.chatViewPage.view setAlpha:1.0f];
            [self.homePageV6 setAlpha:1.0f];
            [self.wallPageV8 setAlpha:1.0f];
            [self.noisePageV6 setAlpha:1.0f];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

#pragma mark - Event touches control

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer{

    [UIView animateWithDuration:0.1 animations:^{
        [mainScroll setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:YES];
    }];
    
    [self.homePageV6.scCollection reloadData];
}

#pragma mark - private function

- (int) uploadAvatarAmazon:(AmazonInfo *)info withImage:(NSData *)imgData{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:info.url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"***";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // key
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.key] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // content-type
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"content-type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // AWSAccessKeyId
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AWSAccessKeyId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.accessKey] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // acl
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"acl\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"public-read" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // policy
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"policy\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.policy] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // signature
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"signature\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.signature] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"jpg"];
    //    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"ios.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imgData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    //return and test
    NSHTTPURLResponse *response=nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    int code = (int)[response statusCode];
    
    return code;
}

- (void) deleteMessenger:(NSString *)value{
    
    NSArray *subParameter = [value componentsSeparatedByString:@"}"];
    if ([subParameter count] > 1) {
        int userReceiveID = [[subParameter objectAtIndex:0] intValue];
        if (userReceiveID > 0) {
            
            NSString *keyMessage = [subParameter objectAtIndex:1];
            
            BOOL isDelete = [self.storeIns deleteMessenger:userReceiveID withKeyMessenger:keyMessage];
            
            if (isDelete) {
                [self.coziCoreDataIns deleteMessenger:keyMessage];
            }
            
        }else{
            //Delete failed
        }
    }
}

- (void) showAddPost{
    [self.storeIns playSoundPress];
    
    [self.view bringSubviewToFront:self.scrollHeader];
    [self.view bringSubviewToFront:self.statusBarView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.shareMenu setFrame:CGRectMake(0, -self.shareMenu.bounds.size.height, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
        [vBlurShareMenu setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.shareMenu setHidden:YES];
        [vBlurShareMenu setHidden:YES];
        isShow = NO;
        inShowShareMenu = NO;
        
        SCPostViewController *post = [[SCPostViewController alloc] init];
        [post showHiddenBack:YES];
        UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:post];
        [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
        [naviController setDelegate:self];
        
        [self presentViewController:naviController animated:YES completion:^{
            
        }];

    }];
    
}

- (void) showAddPostPhoto:(id)sender{
    [self.storeIns playSoundPress];
    
    [self.view bringSubviewToFront:self.scrollHeader];
    [self.view bringSubviewToFront:self.statusBarView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.shareMenu setFrame:CGRectMake(0, -self.shareMenu.bounds.size.height, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
        [vBlurShareMenu setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.shareMenu setHidden:YES];
        [vBlurShareMenu setHidden:YES];
        isShow = NO;
        inShowShareMenu = NO;
        
        SCPostPhotoViewController *post = [[SCPostPhotoViewController alloc] init];
        [post showHiddenBack:YES];
        UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:post];
        
        [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
        [naviController setDelegate:self];
        
        [self presentViewController:naviController animated:YES completion:^{
            
        }];
        
    }];
    
}

- (void) showAddPostLocation:(id)sender{
    [self.storeIns playSoundPress];
    
    [self.view bringSubviewToFront:self.scrollHeader];
    [self.view bringSubviewToFront:self.statusBarView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.shareMenu setFrame:CGRectMake(0, -self.shareMenu.bounds.size.height, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
        [vBlurShareMenu setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.shareMenu setHidden:YES];
        [vBlurShareMenu setHidden:YES];
        isShow = NO;
        inShowShareMenu = NO;
        
        SCPostLocationViewController *post = [[SCPostLocationViewController alloc] init];
        [post showHiddenBack:YES];
        UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:post];
        
        [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
        [naviController setDelegate:self];
        
        [self presentViewController:naviController animated:YES completion:^{
            
        }];
        
    }];
}

- (void) showAddPostMood:(id)sender{
    [self.storeIns playSoundPress];
    [self.view bringSubviewToFront:self.scrollHeader];
    [self.view bringSubviewToFront:self.statusBarView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.shareMenu setFrame:CGRectMake(0, -self.shareMenu.bounds.size.height, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
        [vBlurShareMenu setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.shareMenu setHidden:YES];
        [vBlurShareMenu setHidden:YES];
        isShow = NO;
        inShowShareMenu = NO;
        
        SCMoodPostViewController *post = [[SCMoodPostViewController alloc] init];
        [post showHiddenBack:YES];
        UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:post];
        
        [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
        [naviController setDelegate:self];
        
        [self presentViewController:naviController animated:YES completion:^{
            
        }];
        
    }];
    
}

- (void) btnSearchFriend:(id)sender{
    [self.storeIns playSoundPress];
    
    [self.view endEditing:YES];
    
    SCSearchFriendViewController *post = [[SCSearchFriendViewController alloc] init];
    [post showHiddenClose:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
    
    [self hiddenMenu];
}

- (void) btnShowFriendRequest:(id)sender{
    [self hiddenMenu];
    
    SCFriendRequestViewController *post = [[SCFriendRequestViewController alloc] init];
    [post showHiddenClose:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

- (void) btnShowLookAround:(id)sender{
    SCLookAroundViewController *post = [[SCLookAroundViewController alloc] init];
    [post showHiddenClose:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

#pragma -mark StoreDelegate
- (void) reloadChatView:(Messenger *)_messenger{
    
    if (self.chatViewPage && isVisibleChatView && self.chatViewPage.recentIns.friendIns.friendID == _messenger.friendID) {
        [self.chatViewPage autoScrollTbView];
    }else{
        [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
        [self.homePageV6.scCollection reloadData];
    }
}

#pragma -mark UISearchBar Delegate
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar == searchRightMenu) {
        if (![searchBar.text isEqualToString:@""]) {
            NSMutableArray *result = [self filterContentForSearchText:searchBar.text];
            [tbContact initData:result];
            [tbContact reloadData];
        }else{
            [tbContact initData:self.storeIns.friends];
            [tbContact reloadData];
        }

    }
}

- (NSMutableArray*)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"nickName contains[c] %@", searchText];
    NSArray *searchResult = [self.storeIns.friends filteredArrayUsingPredicate:resultPredicate];
    
    return [NSMutableArray arrayWithArray:searchResult];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self flushCache];
}

- (void)flushCache
{
    NSInteger cacheSize = [SDWebImageManager.sharedManager.imageCache getSize];
    NSLog(@"size cache: %i", (int)cacheSize);
    
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];

//    if (self.storeIns.walls) {
//        int count = (int)[self.storeIns.walls count];
//        for (int i = 0 ; i < count; i++) {
//            DataWall *_wall = [self.storeIns.walls objectAtIndex:i];
//            [SDWebImageManager.sharedManager.imageCache removeImageForKey:_wall.urlFull];
//        }
//    }
//    
//    if (self.storeIns.noises) {
//        int count = (int)[self.storeIns.noises count];
//        for (int i = 0;  i < count; i++) {
//            DataWall *_noise = [self.storeIns.noises objectAtIndex:i];
//            [SDWebImageManager.sharedManager.imageCache removeImageForKey:_noise.urlThumb];
//        }
//    }
    
}

@end
