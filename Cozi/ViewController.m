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
    if (self.wallPageV8) {
        [self.wallPageV8 reloadData];
    }
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
    currentPage = 1;
    isFirstLoadWall = YES;
    heightRowLeftMenu   = 40;
    alphatView = 0.8;
    heightHeader = 40;
    widthMenu = (self.view.bounds.size.width / 4) * 3;
    
    self.helperIns = [Helper shareInstance];
    BOOL _isConnected  = [self.helperIns checkConnected];
    if (_isConnected) {
        isConnected = 1;
    }else{
        isConnected = 0;
    }
    
    isEnterBackground = NO;
    
    dataLocation = [[NSMutableData alloc] init];
    contactList = [[NSMutableArray alloc] init];
    
    self.storeIns = [Store shareInstance];
    self.coziCoreDataIns = [CoziCoreData shareInstance];
    [self.storeIns setDelegate:self];

    self.dataMapIns = [DataMap shareInstance];
    netController = [NetworkController shareInstance];
    
    if (isConnected == 1) {
        [self initNetwork];
    }
}

- (void) initView{
    NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
    BOOL _isLogin = [_default boolForKey:@"IsLogin"];
    
    if (_isLogin) {
        
        NSInteger _userID = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"];
        [self.storeIns loadUser:(int)_userID];
        [self.storeIns loadFriend:(int)_userID];
        [self.storeIns loadFollower:(int)_userID];
        [self.storeIns getPostHistory:(int)_userID];
//        [self.storeIns loadFriendRequest:(int)_userID];
        
        [self setup];
        
        [self loadUserComplete:nil];
        
        [self initializeGestures];
        
    }else{
//        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//        
//        self.loginPage = [[LoginPage alloc] initWithFrame:self.view.bounds];
//        [self.loginPage.signInView.btnSignInView addTarget:self action:@selector(btnSignInTouches) forControlEvents:UIControlEventTouchUpInside];
//        [self.loginPage.enterPhoneView.btnSendPhoneNumber addTarget:self action:@selector(btnEnterPhoneTouches) forControlEvents:UIControlEventTouchUpInside];
//        [self.loginPage.enterCodeView.btnSendCode addTarget:self action:@selector(btnEnterAuthCodeTouches) forControlEvents:UIControlEventTouchUpInside];
//        [self.loginPage.joinNowView.btnJoinNow addTarget:self action:@selector(btnJoinNowTouches) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:self.loginPage];
        
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BecomeActiveNotification:) name:@"postIsLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAssetsComplete:) name:@"loadAssetsComplete" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserComplete:) name:@"loadUserComplete" object:nil];
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
}

#pragma mark- setup UIView MainPage

- (void) setup{
    
    blurView = [[UIView alloc] initWithFrame:CGRectMake(0, heightHeader, self.view.bounds.size.width, self.view.bounds.size.height)];
    [blurView setUserInteractionEnabled:NO];
    [blurView setAlpha:0.0f];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [blurView setUserInteractionEnabled:YES];
    
    blurImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [blurView addSubview:blurImage];
    
    [self.view addSubview:blurView];
    
    isEndScroll = YES;
    isValidCondition = YES;
//    _isInAni=NO;
    page = 1;
    _lastPage = 1;
    preLocation = CGPointMake(0, 0);
//    _iconW=30;
//    _pageW=self.view.bounds.size.width;
    
    //init header
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:headerView];
    
    waitingReconnect = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [waitingReconnect setFrame:CGRectMake(0, heightHeader, self.view.bounds.size.width, self.view.bounds.size.height - heightHeader)];
    [waitingReconnect setBackgroundColor:[UIColor blackColor]];
    [waitingReconnect setAlpha:0.6];
    [waitingReconnect startAnimating];
    [self.view addSubview:waitingReconnect];
    
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heightHeader, self.view.bounds.size.width, self.view.bounds.size.height - heightHeader)];
    [mainScroll setDirectionalLockEnabled:NO];
    [mainScroll setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248.0/255.0f alpha:1]];
    [mainScroll setPagingEnabled:YES];
    [mainScroll setContentSize:CGSizeMake(self.view.bounds.size.width * 3, self.view.bounds.size.height - heightHeader)];
//    [mainScroll setUserInteractionEnabled:YES];
    [mainScroll setShowsHorizontalScrollIndicator:NO];
    [mainScroll setShowsVerticalScrollIndicator:NO];
    [mainScroll setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [mainScroll setBounces:NO];
    [mainScroll setDelaysContentTouches:YES];
    [mainScroll setDelegate:self];
    
    scrollHeader = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [scrollHeader setContentSize:CGSizeMake(self.view.bounds.size.width * 3, heightHeader)];
    [scrollHeader setBackgroundColor:[UIColor blackColor]];
    [scrollHeader setScrollEnabled:NO];
    
    self.lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [self.lblNickName setText:@"MESSENGER"];
    [self.lblNickName setTextAlignment:NSTextAlignmentCenter];
    [self.lblNickName setTextColor:[UIColor whiteColor]];
    [self.lblNickName setFont:[self.helperIns getFontLight:15.0f]];
//    [scrollHeader addSubview:self.lblNickName];
    
    [self initHeaderRecents];
    
    //===========================WALL HEADER
    [self initHeaderWall];
    
    UILabel *lblNoise = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 2, 0, self.view.bounds.size.width, heightHeader)];
    [lblNoise setText:@"NOISE"];
    [lblNoise setTextAlignment:NSTextAlignmentCenter];
    [lblNoise setTextColor:[UIColor whiteColor]];
    [lblNoise setFont:[self.helperIns getFontLight:15.0f]];
    [scrollHeader addSubview:lblNoise];
    
    [self.view addSubview:scrollHeader];
    
    self.chatViewPage = [[ChatView alloc] initWithFrame:CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.chatViewPage setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
    [self.view addSubview:self.chatViewPage];
    
    UIPanGestureRecognizer      *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panChatView:)];
    [self.chatViewPage addGestureRecognizer:pan];

    self.homePageV6 = [[MainPageV7 alloc] initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
    [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
    [mainScroll addSubview:self.homePageV6];
    
    self.wallPageV8 = [[SCWallTableViewV2 alloc] initWithFrame:CGRectMake(1 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height) style:UITableViewStylePlain];
    [self.wallPageV8 initWithData:nil withType:0];
    [mainScroll addSubview:self.wallPageV8];
    
    waitingWall = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [waitingWall setFrame:CGRectMake(1 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
    [waitingWall setBackgroundColor:[UIColor blackColor]];
    [waitingWall setAlpha:0.6];
    [waitingWall startAnimating];
    [mainScroll addSubview:waitingWall];
    
    self.noisePageV6 = [[NoisesPage alloc] initWithFrame:CGRectMake(2 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height - heightHeader)];
    [self.noisePageV6 setBackgroundColor:[UIColor clearColor]];
    [self.noisePageV6.scCollection initData:nil withType:0];
    [mainScroll addSubview:self.noisePageV6];
    
    waitingNoise = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [waitingNoise setFrame:CGRectMake(2 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height - heightHeader)];
    [waitingNoise setBackgroundColor:[UIColor blackColor]];
    [waitingNoise setAlpha:0.6];
    [waitingNoise startAnimating];
    [mainScroll addSubview:waitingNoise];
    
    [self.view addSubview:mainScroll];
    
    [scrollHeader setContentOffset:mainScroll.contentOffset];
    
    //init status view
    viewStatusConnect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [viewStatusConnect setBackgroundColor:[UIColor redColor]];
    [viewStatusConnect setHidden:YES];
    
    lblStatusConnect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [lblStatusConnect setTextAlignment:NSTextAlignmentCenter];
    [lblStatusConnect setFont:[self.helperIns getFontLight:15.0f]];
    [lblStatusConnect setTextColor:[UIColor whiteColor]];
    
    [viewStatusConnect addSubview:lblStatusConnect];
    
    [self.view addSubview:viewStatusConnect];

//    [mainScroll setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:NO];
    
    [self.homePageV6 setAlpha:1.0f];
    
    //init Share Menu
    self.shareMenu = [[SCShareMenu alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, self.view.bounds.size.width / 4)];
    [self.shareMenu setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:0.4]];
    [self.shareMenu setHidden:YES];
    [self.view addSubview:self.shareMenu];
    
    [self.shareMenu.btnCamera addTarget:self action:@selector(showAddPost) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMenu.btnPhoto addTarget:self action:@selector(showAddPostPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMenu.btnLocation addTarget:self action:@selector(showAddPostLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMenu.btnMood addTarget:self action:@selector(showAddPostMood:) forControlEvents:UIControlEventTouchUpInside];
    
    vBlurShareMenu = [[UIView alloc] initWithFrame:CGRectMake(0, heightHeader, self.view.bounds.size.width, self.view.bounds.size.height - heightHeader)];
    [vBlurShareMenu setBackgroundColor:[UIColor blackColor]];
    [vBlurShareMenu setHidden:YES];
    [vBlurShareMenu setAlpha:0.0];
    [self.view addSubview:vBlurShareMenu];
}

- (void) initHeaderRecents{
    UIView *viewChat = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    
    UIImage *imgContact = [self.helperIns getImageFromSVGName:@"icon-openMenu.svg"];
    imgMyInfo = [[UIImageView alloc] initWithImage:imgContact];
    [imgMyInfo setUserInteractionEnabled:YES];
    [imgMyInfo setFrame:CGRectMake(0, 0, 40, 40)];
    [imgMyInfo setContentMode:UIViewContentModeCenter];
    [viewChat addSubview:imgMyInfo];
    
    UITapGestureRecognizer *tapContactSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHiddenLeftMenu)];
    [tapContactSearch setNumberOfTapsRequired:1];
    [tapContactSearch setNumberOfTouchesRequired:1];
    [imgMyInfo addGestureRecognizer:tapContactSearch];
    
    UILabel *lblChat = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, heightHeader)];
    [lblChat setText:@"CHAT"];
    [lblChat setTextAlignment:NSTextAlignmentCenter];
    [lblChat setTextColor:[UIColor whiteColor]];
    [lblChat setFont:[self.helperIns getFontLight:15.0f]];
    [viewChat addSubview:lblChat];
    
    UIImage *imgOpenMenu = [self.helperIns getImageFromSVGName:@"icon-contactSearch.svg"];
    UIImageView *imgViewOpenMenu = [[UIImageView alloc] initWithImage:imgOpenMenu];
    [imgViewOpenMenu setUserInteractionEnabled:YES];
    [imgViewOpenMenu setContentMode:UIViewContentModeCenter];
    [imgViewOpenMenu setFrame:CGRectMake(40 + lblChat.bounds.size.width, 0, 40, 40)];
    [viewChat addSubview:imgViewOpenMenu];
    
    UITapGestureRecognizer *tapOpenMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHiddenRightMenu)];
    [tapOpenMenu setNumberOfTapsRequired:1];
    [tapOpenMenu setNumberOfTouchesRequired:1];
    [imgViewOpenMenu addGestureRecognizer:tapOpenMenu];
    
    [scrollHeader addSubview:viewChat];
}

- (void) initHeaderWall{
    UIView *viewWall = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, heightHeader)];
    
    UIImageView *imgLeftMenuWall = [[UIImageView alloc] initWithImage:[self.helperIns getImageFromSVGName:@"icon-openMenu.svg"]];
    [imgLeftMenuWall setUserInteractionEnabled:YES];
    [imgLeftMenuWall setFrame:CGRectMake(0, 0, 40, 40)];
    [imgLeftMenuWall setContentMode:UIViewContentModeCenter];
    [viewWall addSubview:imgLeftMenuWall];
    
    UITapGestureRecognizer *tapLeftMenuWall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHiddenLeftMenu)];
    [tapLeftMenuWall setNumberOfTapsRequired:1];
    [tapLeftMenuWall setNumberOfTouchesRequired:1];
    [imgLeftMenuWall addGestureRecognizer:tapLeftMenuWall];
    
    UILabel *lblWall = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, heightHeader)];
    [lblWall setText:@"WALL"];
    [lblWall setTextAlignment:NSTextAlignmentCenter];
    [lblWall setTextColor:[UIColor whiteColor]];
    [lblWall setFont:[self.helperIns getFontLight:15.0f]];
    [lblWall setUserInteractionEnabled:YES];
    
    [viewWall addSubview:lblWall];
    
    UIImageView *imgAddPost = [[UIImageView alloc] initWithImage:[self.helperIns getImageFromSVGName:@"icon-contactSearch.svg"]];
    [imgAddPost setUserInteractionEnabled:YES];
    [imgAddPost setContentMode:UIViewContentModeCenter];
    [imgAddPost setFrame:CGRectMake(40 + lblWall.bounds.size.width, 0, 40, 40)];
    [viewWall addSubview:imgAddPost];
    
    UITapGestureRecognizer *tapAddPost = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShareMenu)];
    [tapAddPost setNumberOfTapsRequired:1];
    [tapAddPost setNumberOfTouchesRequired:1];
    [imgAddPost addGestureRecognizer:tapAddPost];
    
    [viewWall addSubview:imgAddPost];
    
    [scrollHeader addSubview:viewWall];
}

/**
 *  Init Left Menu
 */
- (void) initLeftMenu{
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(-widthMenu, heightHeader, widthMenu, self.view.bounds.size.height - heightHeader)];
    [leftView setBackgroundColor:[UIColor blackColor]];
    
    leftView.layer.shadowColor = [UIColor blackColor].CGColor;
    leftView.layer.shadowOffset = CGSizeMake(3, 0);
    leftView.layer.shadowOpacity = 0.3f;
    leftView.layer.shadowRadius = 1;
    
    [self.view addSubview:leftView];
    
    UIImage *imgWhite;
    if (self.storeIns.user.avatar) {
        GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
        imgWhite = [grayscaleFilter imageByFilteringImage:self.storeIns.user.avatar];
    }else{
        imgWhite = [self.helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"];
    }
    
    UIImageView *imgAvatar = [[UIImageView alloc] initWithImage:imgWhite];
    [imgAvatar setFrame:CGRectMake(0, 0, widthMenu, self.view.bounds.size.height / 3)];
    [imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    [imgAvatar setClipsToBounds:YES];
    [leftView addSubview:imgAvatar];
    
    UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 3, widthMenu, heightRowLeftMenu)];
    [lblFullName setText:[self.storeIns.user.nickName uppercaseString]];
    [lblFullName setTextColor:[UIColor whiteColor]];
    [lblFullName setBackgroundColor:[UIColor clearColor]];
    [lblFullName setTextAlignment:NSTextAlignmentCenter];
    [lblFullName setFont:[self.helperIns getFontLight:20]];
    
    [leftView addSubview:lblFullName];
    
    CALayer *bottomUserName = [CALayer layer];
    [bottomUserName setFrame:CGRectMake(0.0f, (self.view.bounds.size.height / 3) + heightRowLeftMenu + 1, leftView.bounds.size.width, 0.5f)];
    [bottomUserName setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [leftView.layer addSublayer:bottomUserName];

    UIImage *imgShareToWall = [self.helperIns getImageFromSVGName:@"form-icon-username"];
    UIButton *btnShareToWall = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShareToWall setFrame:CGRectMake(0, (self.view.bounds.size.height / 3) + lblFullName.bounds.size.height + 2, widthMenu, heightRowLeftMenu)];
    [btnShareToWall setTitle:@"SHARE TO WALL" forState:UIControlStateNormal];
    [btnShareToWall setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnShareToWall setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnShareToWall setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnShareToWall.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnShareToWall setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnShareToWall setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnShareToWall setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnShareToWall setImage:imgShareToWall forState:UIControlStateNormal];
    UIColor *colorSignInNormal = [UIColor blackColor];
    UIColor *colorSignInHighLight = [self.helperIns colorFromRGBWithAlpha:[self.helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:0.8f];
    [btnShareToWall setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnShareToWall setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [leftView addSubview:btnShareToWall];

    UIButton *btnNewChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNewChat setFrame:CGRectMake(0, btnShareToWall.frame.origin.y + btnShareToWall.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnNewChat setTitle:@"NEW CHAT" forState:UIControlStateNormal];
    [btnNewChat.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnNewChat setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnNewChat setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnNewChat setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnNewChat setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnNewChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNewChat setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnNewChat setImage:imgShareToWall forState:UIControlStateNormal];
    [btnNewChat setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnNewChat setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [leftView addSubview:btnNewChat];

    UIButton *btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTakePhoto setFrame:CGRectMake(0, btnNewChat.frame.origin.y + btnNewChat.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnTakePhoto setTitle:@"FRIEND REQUESTS" forState:UIControlStateNormal];
    [btnTakePhoto.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnTakePhoto setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnTakePhoto setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnTakePhoto setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnTakePhoto setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnTakePhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTakePhoto setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnTakePhoto setImage:imgShareToWall forState:UIControlStateNormal];
    [btnTakePhoto setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnTakePhoto setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    [btnTakePhoto addTarget:self action:@selector(btnShowFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:btnTakePhoto];

    UIButton *btnLookAround = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLookAround setFrame:CGRectMake(0, btnTakePhoto.frame.origin.y + btnTakePhoto.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnLookAround setTitle:@"LOOK AROUND" forState:UIControlStateNormal];
    [btnLookAround.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnLookAround setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLookAround setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnLookAround setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLookAround setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLookAround setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLookAround setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnLookAround setImage:imgShareToWall forState:UIControlStateNormal];
    [btnLookAround setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnLookAround setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [leftView addSubview:btnLookAround];
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLocation setFrame:CGRectMake(0, btnLookAround.frame.origin.y + btnLookAround.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnLocation setTitle:@"LOCATION" forState:UIControlStateNormal];
    [btnLocation.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnLocation setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLocation setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnLocation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLocation setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLocation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnLocation setImage:imgShareToWall forState:UIControlStateNormal];
    [btnLocation setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnLocation setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [leftView addSubview:btnLocation];

//    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnSetting setFrame:CGRectMake(0, btnLocation.frame.origin.y + btnLocation.bounds.size.height, widthMenu, heightRowLeftMenu)];
//    [btnSetting setTitle:@"SETTINGS" forState:UIControlStateNormal];
//    [btnSetting.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
//    [btnSetting setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [btnSetting setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [btnSetting setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [btnSetting setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnSetting setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [btnSetting setImage:imgShareToWall forState:UIControlStateNormal];
//    [btnSetting setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
//    [btnSetting setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
//    
//    [leftView addSubview:btnSetting];
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnLogout setFrame:CGRectMake(0, btnSetting.frame.origin.y + btnSetting.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnLogout setFrame:CGRectMake(0, btnLocation.frame.origin.y + btnLocation.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnLogout setTitle:@"LOGOUT" forState:UIControlStateNormal];
    [btnLogout.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnLogout setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLogout setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnLogout setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLogout setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnLogout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, heightHeader, widthMenu, self.view.bounds.size.height - 30)];
    [rightView setBackgroundColor:[UIColor grayColor]];
    
    rightView.layer.shadowColor = [UIColor blackColor].CGColor;
    rightView.layer.shadowOffset = CGSizeMake(-3, 0);
    rightView.layer.shadowOpacity = 0.3f;
    rightView.layer.shadowRadius = 1;
    
    [self.view addSubview:rightView];
    
    searchRightMenu = [[SCSearchBar alloc] initWithFrame:CGRectMake(0, 0, rightView.bounds.size.width - 49, 39)];
    [searchRightMenu setPlaceholder:@"SEARCH NAME"];
    [searchRightMenu setBackgroundColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
    [searchRightMenu setTintColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
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
    [btnSearchFriend setBackgroundColor:[UIColor orangeColor]];
    [btnSearchFriend addTarget:self action:@selector(btnSearchFriend:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:btnSearchFriend];

    CALayer *bottomSearch = [CALayer layer];
    [bottomSearch setFrame:CGRectMake(0.0f, 39.5, rightView.bounds.size.width, 0.5f)];
    [bottomSearch setBackgroundColor:[UIColor whiteColor].CGColor];
    [rightView.layer addSublayer:bottomSearch];
    
    tbContact = [[SCContactTableView alloc] initWithFrame:CGRectMake(0, 40, rightView.bounds.size.width, rightView.bounds.size.height - 120) style:UITableViewStylePlain];
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
    [self.btnNewChat setFrame:CGRectMake(0, rightView.bounds.size.height - 80, rightView.bounds.size.width, 80)];
    [self.btnNewChat setBackgroundColor:[UIColor blackColor]];
    [self.btnNewChat setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnNewChat.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnNewChat setContentMode:UIViewContentModeCenter];
    [self.btnNewChat setTitle:@"NEW CHAT" forState:UIControlStateNormal];
    [self.btnNewChat setTitleColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]] forState:UIControlStateNormal];
    [self.btnNewChat addTarget:self action:@selector(btnNewChatClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNewChat.titleLabel setFont:[self.helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnNewChat.titleLabel.text sizeWithFont:[self.helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
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

#pragma -mark  GestureRecognizer Delegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return NO;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

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
                
                [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaLeft, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
                
                [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                
            } completion:^(BOOL finished) {
                isShowMenuLeft = NO;
            }];
        }else{
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [leftView setFrame:CGRectMake(0, heightHeader, widthMenu , leftView.bounds.size.height)];
                [blurView setAlpha:alphatView];
                
                [self.view bringSubviewToFront:blurView];
                [self.view bringSubviewToFront:leftView];
                
                [mainScroll setFrame:CGRectMake(widthMenu, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
                
                [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaRight, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
                
                [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
                
                [mainScroll setFrame:CGRectMake(-widthMenu, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
    CGFloat deltaMove = self.chatViewPage.frame.origin.x + t.x;
    
    if (deltaMove < 0) {
        self.chatViewPage.center = CGPointMake(self.chatViewPage.center.x + t.x, self.chatViewPage.center.y);
        mainScroll.center = CGPointMake(mainScroll.center.x + t.x, mainScroll.center.y);
        scrollHeader.center = CGPointMake(scrollHeader.center.x + t.x, scrollHeader.center.y);
        [self.view endEditing:YES];
        
        // But also, detect the swipe gesture
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            CGPoint vel = [recognizer velocityInView:recognizer.view];
            
            if (vel.x < SWIPE_LEFT_CHAT)
            {
                //move to left
                //reset move
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [self.chatViewPage setFrame:CGRectMake(-self.view.bounds.size.width, 0, self.chatViewPage.bounds.size.width, self.chatViewPage.bounds.size.height)];
                    [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                    [scrollHeader setFrame:CGRectMake(0, 0, scrollHeader.bounds.size.width, scrollHeader.bounds.size.height)];
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
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.chatViewPage setFrame:CGRectMake(-self.view.bounds.size.width, 0, self.chatViewPage.bounds.size.width, self.chatViewPage.bounds.size.height)];
                        [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                        [scrollHeader setFrame:CGRectMake(0, 0, scrollHeader.bounds.size.width, scrollHeader.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        [self.homePageV6.scCollection reloadData];
                    }];
                }else{
                    //reset to right
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.chatViewPage setFrame:CGRectMake(0, 0, self.chatViewPage.bounds.size.width, self.chatViewPage.bounds.size.height)];
                        [mainScroll setFrame:CGRectMake(self.view.bounds.size.width, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                        [scrollHeader setFrame:CGRectMake(self.view.bounds.size.width, 0, scrollHeader.bounds.size.width, scrollHeader.bounds.size.height)];
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
                        
                        [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaMoveBlurView, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                        
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
                        
                        [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaMoveBlurView, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                        
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
                        
                        [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaMoveBlurView, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
                        
                        [mainScroll setFrame:CGRectMake(mainScroll.frame.origin.x + deltaMoveBlurView, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
                    
                    [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                    
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
                        
                        [mainScroll setFrame:CGRectMake(-widthMenu, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
                        
                        [mainScroll setFrame:CGRectMake(widthMenu, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
                    
                    [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
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
        
        [scrollHeader setContentOffset:scrollView.contentOffset];
        
        [self.chatViewPage endEditing:YES];
        
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
        
        if (scrollView.contentOffset.x >= 0) {
            [UIView animateWithDuration:0.1 animations:^{
                [rmLine setFrame:CGRectMake((scrollView.contentOffset.x / 3) + 0.5, rmLine.frame.origin.y, rmLine.bounds.size.width, rmLine.bounds.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
    preScrollLocation = scrollView.contentOffset;
    
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.homePageV6.scCollection reloadData];
    
    if (scrollView == mainScroll) {
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.chatViewPage setAlpha:1.0f];
            [self.homePageV6 setAlpha:1.0f];
            [self.wallPageV8 setAlpha:1.0f];
            [self.noisePageV6 setAlpha:1.0f];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

#pragma mark - Event touches control
- (void) btnSignInTouches{
    
    [self.loginPage startLoadingView];
    
    [self.loginPage.txtUserName resignFirstResponder];
    [self.loginPage.txtPassword resignFirstResponder];
    
    NSString *strUserName = self.loginPage.signInView.txtUserName.text;
    NSString *strPassword = self.loginPage.signInView.txtPassword.text;
    
    if (![strPassword isEqualToString:@""] && ![strUserName isEqualToString:@""]) {
        
        BOOL isValidEmail = [self.helperIns validateEmail:strUserName];
        if (isValidEmail) {
            NSString *strUserNameEncode = [self.helperIns encodedBase64:[strUserName dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *strPasswordEncode = [self.helperIns encoded:strPassword];
            
            [[NSUserDefaults standardUserDefaults] setObject:strPassword forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSData *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
            NSString *_deviceToken = @"c5d46419d7e93ce0c6cd3cb0b01d1f9c1d41fb16e05a73ef8969efdaf91d5e24";
            
            if (token != nil) {
                _deviceToken = [NSString stringWithFormat:@"%@", token];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
            }
            
            NSString *cmdLogin = [self.dataMapIns loginCommand:strUserNameEncode withHashPass:strPasswordEncode withToken:_deviceToken withLongitude:[self.storeIns getLongitude] withLatitude:[self.storeIns getlatitude]];
            
            [self.networkIns sendData:cmdLogin];
        }else{


        }
    }
}

- (void) btnSignInTouchesV3{
    
    [self.loginPage startLoadingView];
    
    [self.loginPage.txtUserName resignFirstResponder];
    [self.loginPage.txtPassword resignFirstResponder];
    
    NSString *strUserName = self.loginPageV3.txtUserNameSignIn.text;
    NSString *strPassword = self.loginPageV3.txtPasswordSignIn.text;
    
    if (![strPassword isEqualToString:@""] && ![strUserName isEqualToString:@""]) {
        
        BOOL isValidEmail = [self.helperIns validateEmail:strUserName];
        if (isValidEmail) {
            NSString *strUserNameEncode = [self.helperIns encodedBase64:[strUserName dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *strPasswordEncode = [self.helperIns encoded:strPassword];
            
            [[NSUserDefaults standardUserDefaults] setObject:strPassword forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSData *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
            NSString *_deviceToken = @"c5d46419d7e93ce0c6cd3cb0b01d1f9c1d41fb16e05a73ef8969efdaf91d5e24";
            
            if (token != nil) {
                _deviceToken = [NSString stringWithFormat:@"%@", token];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
            }
            
            NSString *cmdLogin = [self.dataMapIns loginCommand:strUserNameEncode withHashPass:strPasswordEncode withToken:_deviceToken withLongitude:[self.storeIns getLongitude] withLatitude:[self.storeIns getlatitude]];
            
            [self.networkIns sendData:cmdLogin];
        }else{
            
            
        }
    }
}

- (void) btnEnterPhoneTouches{
    if (![self.loginPage.enterPhoneView.txtEnterPhone.text isEqualToString: @""]) {
        
        NSString *phone = [NSString stringWithFormat:@"+84%@", self.loginPage.enterPhoneView.txtEnterPhone.text];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WELCOME" message:[NSString stringWithFormat:@"YOUR PHONE NUMBER: %@\nARE YOU REALLY?", phone] delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
}

- (void) btnEnterAuthCodeTouches{
    if (![self.loginPage.enterCodeView.txtEnterCode.text isEqualToString: @""]) {
        NSString *code = self.loginPage.enterCodeView.txtEnterCode.text;
        
        NSString *cmd = [self.dataMapIns cmdSendAuthCode:code];
        [self.networkIns sendData:cmd];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:{
            NSString *phone = [NSString stringWithFormat:@"+84%@", self.loginPage.enterPhoneView.txtEnterPhone.text];
            NSString *cmd = [self.dataMapIns regPhone:phone];
            [self.networkIns sendData:cmd];
        }
            break;
            
        default:
            break;
    }
}

- (void) btnJoinNowTouches{
    
    [self.loginPage startLoadingView];
    
    NSOperationQueue *uploadAvatarQueue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(processUpAvatar) object:nil];
    [uploadAvatarQueue addOperation:operation];

    [operation setCompletionBlock:^{
        
    }];
}

- (void) processUpAvatar{
    UIImage *imgAvatar = [self.loginPage getAvatar];
    UIImage *imgThumbnail = [self.loginPage getThumbnail];
    NSData *dataAvatar = [self.helperIns compressionImage:imgAvatar];
    NSData *dataThumbnail = UIImageJPEGRepresentation(imgThumbnail, 1);
    
    int codeAvatar = [self uploadAvatarAmazon:amazonAvatar withImage:dataAvatar];
    int codeThumbnail = [self uploadAvatarAmazon:amazonThumbnail withImage:dataThumbnail];
    
    NSString *cmd = [self.dataMapIns commandResultUploadAvatar:codeAvatar withCodeThumbnail:codeThumbnail];
    [self.networkIns sendData:cmd];
}

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

    [self.view bringSubviewToFront:scrollHeader];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.shareMenu setFrame:CGRectMake(0, -70, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
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
    
    [self.view bringSubviewToFront:scrollHeader];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.shareMenu setFrame:CGRectMake(0, -70, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
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
    [self.view bringSubviewToFront:scrollHeader];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.shareMenu setFrame:CGRectMake(0, -70, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
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
    
    [self.view bringSubviewToFront:scrollHeader];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.shareMenu setFrame:CGRectMake(0, -70, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
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
//    [self showHiddenRightMenu];
    SCSearchFriendViewController *post = [[SCSearchFriendViewController alloc] init];
    [post showHiddenClose:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

- (void) btnShowFriendRequest:(id)sender{
    SCFriendRequestViewController *post = [[SCFriendRequestViewController alloc] init];
    [post showHiddenClose:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

#pragma -mark StoreDelegate
- (void) reloadChatView{
    [self.chatViewPage autoScrollTbView];
    
    [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
    [self.homePageV6.scCollection reloadData];
}

#pragma -mark UISearchBar Delegate
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar == searchRightMenu) {
        NSLog(@"enter text search");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self flushCache];
}

- (void)flushCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

@end
