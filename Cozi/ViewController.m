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
@synthesize wallPageV7;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setupNetworkStatus];
    [self initVariable];
    [self addressBookValidation];
    [self initView];
    [self registerNotifications];
}

- (void) setupNetworkStatus{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    hostReachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReachability startNotifier];
}

#pragma mark- init UIViewController

- (void) initVariable{
    isFirstLoadWall = YES;
    heightRowLeftMenu   = 40;
    alphatView = 0.8;
    heightHeader = 40;
    widthMenu = (self.view.bounds.size.width / 4) * 3;
    
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
    self.helperIns = [Helper shareInstance];
    self.dataMapIns = [DataMap shareInstance];
    
    if (isConnected == 1) {
        [self initNetwork];
    }
    
    [self.coziCoreDataIns getMessenger];
}

- (void) initView{
    NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
    BOOL _isLogin = [_default boolForKey:@"IsLogin"];
    
    if (_isLogin) {
        
        NSInteger _userID = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"];
        [self.storeIns loadUser:(int)_userID];
        [self.storeIns loadFriend:(int)_userID];
    
        [self setup];
        
        [self initializeGestures];
        
    }else{
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
        self.loginPage = [[LoginPage alloc] initWithFrame:self.view.bounds];
        [self.loginPage.signInView.btnSignInView addTarget:self action:@selector(btnSignInTouches) forControlEvents:UIControlEventTouchUpInside];
        [self.loginPage.enterPhoneView.btnSendPhoneNumber addTarget:self action:@selector(btnEnterPhoneTouches) forControlEvents:UIControlEventTouchUpInside];
        [self.loginPage.enterCodeView.btnSendCode addTarget:self action:@selector(btnEnterAuthCodeTouches) forControlEvents:UIControlEventTouchUpInside];
        [self.loginPage.joinNowView.btnJoinNow addTarget:self action:@selector(btnJoinNowTouches) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginPage];
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
}

- (void) addressBookValidation{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    ABAddressBookRef addressbook;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        addressbook = ABAddressBookCreateWithOptions(nil, nil);
        ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
            
        });
    }else{
        addressbook = ABAddressBookCreate();
    }
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error)
                                                     {
                                                         accessGranted = granted;
                                                         dispatch_semaphore_signal(sema);
                                                     });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            accessGranted = YES;
        }
        else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusDenied)
        {
            accessGranted = NO;
        }
        else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusRestricted){
            accessGranted = NO;
        }
        else
        {
            accessGranted = YES;
        }
    }
    else
    {
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
        ABAddressBookRef _addressBookRef = ABAddressBookCreate ();
        NSArray* allPeople = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
        
        NSMutableArray* _allItems = [[NSMutableArray alloc] initWithCapacity:[allPeople count]]; // capacity is only a rough guess, but better than nothing
        for (id record in allPeople) {
            CFTypeRef phoneProperty = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonPhoneProperty);
            CFTypeRef lastName = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonLastNameProperty);
            NSString *strLastName = (__bridge NSString*)lastName;
            NSString *strFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonFirstNameProperty);
            NSString *strMidleName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonMiddleNameProperty);
            
            if (strMidleName == nil) {
                strMidleName = @"";
            }
            
            if (strFirstName == nil) {
                strFirstName = @"";
            }
            
            if (strLastName == nil) {
                strLastName = @"";
            }
            
            NSArray *phones = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
            CFRelease(phoneProperty);
            for (NSString *phone in phones) {
                NSString* compositeName = (__bridge NSString *)ABRecordCopyCompositeName((__bridge ABRecordRef)record);
                
                PersonContact *newPerson = [[PersonContact alloc] init];
                [newPerson setFirstName:strFirstName];
                [newPerson setLastName:strLastName];
                [newPerson setMidName:strMidleName];
                [newPerson setFullName:[NSString stringWithFormat:@"%@ %@ %@", strFirstName, strMidleName, strLastName]];
                [newPerson setPhone:phone];
                
                [contactList addObject:newPerson];
                
                NSString *field = [NSString stringWithFormat:@"%@: %@", compositeName, phone];
                [_allItems addObject:field];
            }
        }
        
        [prefs synchronize];
        CFRelease(addressbook);
        
    }
}

#pragma mark- setup UIView MainPage

- (void) setup{
    
    blurView = [[UIView alloc] initWithFrame:CGRectMake(0, heightHeader, self.view.bounds.size.width, self.view.bounds.size.height)];
    [blurView setUserInteractionEnabled:NO];
    [blurView setAlpha:0.0f];
    [blurView setBackgroundColor:[UIColor whiteColor]];
    [blurView setUserInteractionEnabled:YES];
    
    blurImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [blurView addSubview:blurImage];
    
    [self.view addSubview:blurView];
    
    isEndScroll = YES;
    isValidCondition = YES;
    _isInAni=NO;
    page = 1;
    _lastPage = 1;
    preLocation = CGPointMake(0, 0);
    _allIcon = [[NSMutableArray alloc] init];
    _iconW=30;
    _pageW=self.view.bounds.size.width;
//    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //init header
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:headerView];
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(-widthMenu, heightHeader, widthMenu, self.view.bounds.size.height - heightHeader)];
    [leftView setBackgroundColor:[UIColor blackColor]];
    
    leftView.layer.shadowColor = [UIColor blackColor].CGColor;
    leftView.layer.shadowOffset = CGSizeMake(3, 0);
    leftView.layer.shadowOpacity = 0.3f;
    leftView.layer.shadowRadius = 1;
    
    [self.view addSubview:leftView];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, heightHeader, widthMenu, self.view.bounds.size.height - 30)];
    [rightView setBackgroundColor:[UIColor blackColor]];
    
    rightView.layer.shadowColor = [UIColor blackColor].CGColor;
    rightView.layer.shadowOffset = CGSizeMake(-3, 0);
    rightView.layer.shadowOpacity = 0.3f;
    rightView.layer.shadowRadius = 1;
    
    [self.view addSubview:rightView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cozi.jpg"]];
    [imgView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [self.view addSubview:imgView];
    
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heightHeader, self.view.bounds.size.width, self.view.bounds.size.height - heightHeader)];
//    [mainScroll setBackgroundColor:[UIColor clearColor]];
    [mainScroll setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248.0/255.0f alpha:1]];
    [mainScroll setPagingEnabled:YES];
    [mainScroll setContentSize:CGSizeMake(self.view.bounds.size.width * 4, self.view.bounds.size.height - heightHeader)];
//    [mainScroll setClipsToBounds:YES];
    [mainScroll setUserInteractionEnabled:YES];
    [mainScroll setShowsHorizontalScrollIndicator:NO];
    [mainScroll setShowsVerticalScrollIndicator:NO];
    [mainScroll setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
//    [mainScroll setScrollEnabled:YES];
//    [mainScroll setScrollsToTop:NO];
    [mainScroll setBounces:NO];
    [mainScroll setDelaysContentTouches:YES];
    [mainScroll setDelegate:self];
    
    _pageTitleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _iconW, _iconW)];
    _pageTitleView.backgroundColor=[UIColor blackColor];
    [_pageTitleView setContentMode:UIViewContentModeLeft];
//    [self.view bringSubviewToFront:_pageTitleView];
//    [self.view addSubview:_pageTitleView];
    
    _pageTitleLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, _iconW)];
    [_pageTitleLa setTextColor:[UIColor whiteColor]];
    [_pageTitleLa setFont:[self.helperIns getFontLight:15.0f]];
    [_pageTitleView addSubview:_pageTitleLa];
    
    int left=(_pageW-_iconW)/2;
//    _allTitle=[[NSMutableArray alloc] init];
//    [_allTitle addObject:@"CHAT"];
//    [_allTitle addObject:@"CONTACTS"];
//    [_allTitle addObject:@"WALL"];
//    [_allTitle addObject:@"NOISE"];
    
    scrollHeader = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [scrollHeader setContentSize:CGSizeMake(self.view.bounds.size.width * 4, heightHeader)];
    [scrollHeader setBackgroundColor:[UIColor blackColor]];
    [scrollHeader setScrollEnabled:NO];
    
    self.lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightHeader)];
    [self.lblNickName setText:@"MESSENGER"];
    [self.lblNickName setTextAlignment:NSTextAlignmentCenter];
    [self.lblNickName setTextColor:[UIColor whiteColor]];
    [self.lblNickName setFont:[self.helperIns getFontLight:15.0f]];
    [scrollHeader addSubview:self.lblNickName];
    
    UIView *viewChat = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, heightHeader)];
    
    UIImage *imgContact = [self.helperIns getImageFromSVGName:@"icon-openMenu.svg"];
    UIImageView *imgContactSearch = [[UIImageView alloc] initWithImage:imgContact];
    [imgContactSearch setUserInteractionEnabled:YES];
    [imgContactSearch setFrame:CGRectMake(0, 0, 40, 40)];
    [imgContactSearch setContentMode:UIViewContentModeCenter];
    [viewChat addSubview:imgContactSearch];
    
    UITapGestureRecognizer *tapContactSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHiddenLeftMenu)];
    [tapContactSearch setNumberOfTapsRequired:1];
    [tapContactSearch setNumberOfTouchesRequired:1];
    [imgContactSearch addGestureRecognizer:tapContactSearch];

    
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
    
    //===========================
    
    UILabel *lblWall = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 2, 0, self.view.bounds.size.width, heightHeader)];
    [lblWall setText:@"WALL"];
    [lblWall setTextAlignment:NSTextAlignmentCenter];
    [lblWall setTextColor:[UIColor whiteColor]];
    [lblWall setFont:[self.helperIns getFontLight:15.0f]];
    [lblWall setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddPost)];
    [tap setNumberOfTapsRequired:1];
    [tap  setNumberOfTouchesRequired:1];
    [lblWall addGestureRecognizer:tap];
    
    [scrollHeader addSubview:lblWall];
    
    UILabel *lblNoise = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 3, 0, self.view.bounds.size.width, heightHeader)];
    [lblNoise setText:@"NOISE"];
    [lblNoise setTextAlignment:NSTextAlignmentCenter];
    [lblNoise setTextColor:[UIColor whiteColor]];
    [lblNoise setFont:[self.helperIns getFontLight:15.0f]];
    [scrollHeader addSubview:lblNoise];
    
    [self.view addSubview:scrollHeader];
    
    UITapGestureRecognizer *tapLogo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLogout:)];
    [tapLogo setNumberOfTapsRequired:1];
    [tapLogo setNumberOfTouchesRequired:1];
    [self.homePageV6.imgLogoView addGestureRecognizer:tapLogo];
    
    self.chatViewPage = [[ChatView alloc] initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
    [self.chatViewPage initFriendInfo:nil];
    [self.chatViewPage initBackView];
    [mainScroll addSubview:self.chatViewPage];

    self.homePageV6 = [[MainPageV7 alloc] initWithFrame:CGRectMake(1 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
//    [self.homePageV6 initMyInfo:self.storeIns.user];
//    [self.homePageV6 drawAvatar]
//    [self.homePageV6 setBackgroundColor:[UIColor clearColor]];
    [mainScroll addSubview:self.homePageV6];

//    self.wallPageV8 = [[SCWallTableViewV2 alloc] initWithNibName:nil bundle:nil];
//    [self.wallPageV8.view setBackgroundColor:[UIColor grayColor]];
//    [self.wallPageV8.view setFrame:CGRectMake(2 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
//    
//    [self.view addSubview:self.wallPageV8.view];
//    [self addChildViewController:self.wallPageV8];
//    [self.wallPageV8 didMoveToParentViewController:self];
    
    self.wallPageV8 = [[SCWallTableViewV2 alloc] initWithFrame:CGRectMake(2 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height) style:UITableViewStylePlain];
    [self.wallPageV8 setBackgroundColor:[UIColor lightGrayColor]];
    [mainScroll addSubview:self.wallPageV8];
    
//    self.wallPageV7 = [[SCWallTableView alloc] initWithFrame:CGRectMake(2 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
////    [self.wallPageV7 setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1]];
//    [self.wallPageV7 setBackgroundColor:[UIColor lightGrayColor]];
//    [mainScroll addSubview:self.wallPageV7];
    
//    self.wallPage = [[Wall alloc] initWithFrame:CGRectMake(2 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
//    [self.wallPage setBackgroundColor:[UIColor lightGrayColor]];
//    [mainScroll addSubview:self.wallPage];
    
//    self.wallPageV6 = [[WallV6 alloc] initWithFrame:CGRectMake(3 * self.view.bounds.size.width, 0, self.view.bounds.size.width, mainScroll.bounds.size.height)];
//    [self.wallPageV6 setBackgroundColor:[UIColor clearColor]];
//    [mainScroll addSubview:self.wallPageV6];
    
    self.noisePageV6 = [[NoisesPage alloc] initWithFrame:CGRectMake(3 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.noisePageV6 setBackgroundColor:[UIColor clearColor]];
    [mainScroll addSubview:self.noisePageV6];
    
    for (int i = 0; i < 4; i++) {
        
        UIImage *img = [SVGKImage imageNamed:[NSString stringWithFormat:@"header-%i-white", i + 1]].UIImage;
        
        UIImageView *viewPage = [[UIImageView alloc] initWithFrame:CGRectMake(left+i*_iconW, 0,_iconW,_iconW)];
        [viewPage setImage:img];
        [viewPage setContentMode:UIViewContentModeScaleAspectFill];
        [viewPage setTag:100 + i];
        [viewPage setBackgroundColor:[UIColor clearColor]];
//        [self.view addSubview:viewPage];
        
//        [headerView addSubview:viewPage];
        [_allIcon addObject:viewPage];
    }
    
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

    [mainScroll setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:NO];
    
    //set first icon select
    UIImage *imgFirstSelect = [SVGKImage imageNamed:[NSString stringWithFormat:@"header-%i", 2]].UIImage;
    UIImageView *imgViewFirst = (UIImageView*)[self.view viewWithTag:101];
    [imgViewFirst setImage:imgFirstSelect];
}

/**
 *  Init Left Menu
 */
- (void) initLeftMenu{
    
    GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
    UIImage *imgWhite = [grayscaleFilter imageByFilteringImage:self.storeIns.user.avatar];
    
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

    UIImage *imgShareToWall = [self.helperIns getImageFromSVGName:@"form-icon-username.svg"];
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
    [btnTakePhoto setTitle:@"TAKE A PHOTO" forState:UIControlStateNormal];
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

    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSetting setFrame:CGRectMake(0, btnLocation.frame.origin.y + btnLocation.bounds.size.height, widthMenu, heightRowLeftMenu)];
    [btnSetting setTitle:@"SETTINGS" forState:UIControlStateNormal];
    [btnSetting.titleLabel setFont:[self.helperIns getFontLight:13.0f]];
    [btnSetting setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnSetting setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnSetting setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnSetting setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSetting setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnSetting setImage:imgShareToWall forState:UIControlStateNormal];
    [btnSetting setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [btnSetting setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [leftView addSubview:btnSetting];
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogout setFrame:CGRectMake(0, btnSetting.frame.origin.y + btnSetting.bounds.size.height, widthMenu, heightRowLeftMenu)];
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
    searchRightMenu = [[SCSearchBar alloc] initWithFrame:CGRectMake(0, 0, rightView.bounds.size.width, 29)];
    [searchRightMenu setPlaceholder:@"SEARCH NAME & NUMBER"];
    [searchRightMenu setBackgroundColor:[UIColor blackColor]];
    [searchRightMenu setTintColor:[UIColor blackColor]];
    
    [rightView addSubview:searchRightMenu];
    
    CALayer *bottomSearch = [CALayer layer];
    [bottomSearch setFrame:CGRectMake(0.0f, 29.5, rightView.bounds.size.width, 0.5f)];
    [bottomSearch setBackgroundColor:[UIColor whiteColor].CGColor];
    [rightView.layer addSublayer:bottomSearch];
    
    rmScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, rightView.bounds.size.width, rightView.bounds.size.height - 30)];
    [rmScrollView setContentSize:CGSizeMake(rightView.bounds.size.width, rightView.bounds.size.height - 30)];
    [rmScrollView setPagingEnabled:YES];
    [rmScrollView setDelegate:self];
    [rightView addSubview:rmScrollView];
    
    tbContact = [[SCContactTableView alloc] initWithFrame:CGRectMake(0, 0, rightView.bounds.size.width, self.view.bounds.size.height - 30) style:UITableViewStylePlain];
    [tbContact initData:self.storeIns.friends];
    [tbContact reloadData];
    [rmScrollView addSubview:tbContact];
}

/**
 *  init Gestures
 */
-(void)initializeGestures{
    
//    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    
//    [panGestureRecognizer setDelegate:self];
//    [mainScroll addGestureRecognizer:panGestureRecognizer];
    
    UIScreenEdgePanGestureRecognizer *leftRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftRecognizer:)];
    leftRecognizer.edges = UIRectEdgeLeft;
    leftRecognizer.delegate = self;
    
    [mainScroll addGestureRecognizer:leftRecognizer];
    
    UIScreenEdgePanGestureRecognizer *rightRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightRecognizer:)];
    rightRecognizer.edges = UIRectEdgeRight;
    rightRecognizer.delegate = self;
    
    [mainScroll addGestureRecognizer:rightRecognizer];
    
}

#pragma -mark  GestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
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

- (void)handleRightRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer
{
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

#pragma -mark Touch Delegate
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
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
                    [leftView setFrame:CGRectMake(-widthMenu, heightHeader, widthMenu, self.view.bounds.size.height)];
                    
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
                    [rightView setFrame:CGRectMake(self.view.bounds.size.width, heightHeader, widthMenu, self.view.bounds.size.height)];
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

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{

    [scrollHeader setContentOffset:scrollView.contentOffset];
    
    [self.chatViewPage endEditing:YES];
    
    CGFloat pageWidth = mainScroll.frame.size.width;
    int currentPage = floor((mainScroll.contentOffset.x - (pageWidth / 2)) / pageWidth) + 1;

    page = currentPage;

    if (scrollView.contentOffset.x < self.view.bounds.size.width && page == 1) {
        [mainScroll setScrollEnabled:NO];
    }else{
        [mainScroll setScrollEnabled:YES];
    }
    
    if (scrollView == mainScroll) {
        
//        if(_isInAni==YES)
//        {
//            [self endAni];
//        }
//        
//        CGRect rect=_pageTitleView.frame;
//        rect.size.width=0;
//        _pageTitleView.frame=rect;
//        if (!showSiderBar) {
//            
//            int left=(_pageW-_iconW)/2;
//            left-=mainScroll.contentOffset.x*_iconW/_pageW;
//            for(int i=0;i<4;i++)
//            {
//                UIImageView *imgV=_allIcon[i];
//                imgV.frame=CGRectMake(left+i*_iconW, 0, _iconW, _iconW);
//            }
//            
//            if (isShow == NO) {
//                isShow = YES;
//            }
//            
//            isEndScroll = NO;
//        }
//        
//        preScrollLocation = scrollView.contentOffset;
    }

    if (scrollView == rmScrollView) {
        if (scrollView.contentOffset.x >= 0) {
            [UIView animateWithDuration:0.1 animations:^{
                [rmLine setFrame:CGRectMake((scrollView.contentOffset.x / 3) + 0.5, rmLine.frame.origin.y, rmLine.bounds.size.width, rmLine.bounds.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    int _temp = mainScroll.contentOffset.x / self.view.bounds.size.width;
    NSLog(@"end animation %i", _temp);
    if (scrollView == mainScroll) {
        
//        if (scrollView.contentOffset.x < self.view.bounds.size.width || page == 0) {
//            [mainScroll setScrollEnabled:NO];
//        }
//
//        int div=fmod(mainScroll.contentOffset.x , _pageW);
//        int _page=(mainScroll.contentOffset.x-div)/_pageW;
//        page = _page;
//        UIImageView *imgV=_allIcon[_page];
//        NSString *title=_allTitle[_page];
//        CGSize strSize=[title sizeWithFont:_pageTitleLa.font];
//        _txtW=strSize.width;
//        _pageTitleLa.frame =CGRectMake(0, 0, strSize.width, _iconW);
//        _pageTitleLa.text=title;
//        
//        [_pageTitleLa setAlpha:0.0];
//        [_pageTitleView setFrame:CGRectMake(imgV.frame.origin.x+_iconW, 0, 0, _iconW)];
//        //    CGRect rect=CGRectMake(imgV.frame.origin.x+_iconW, 0, strSize.width, _iconW);
//        _isInAni=YES;
//        
//        _aniTimeout=25;
//        _aniStep=0;
//        _isInAni=YES;
//        _timer=[NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(openAni:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        
//        UIImage *imgSelect = [SVGKImage imageNamed:[NSString stringWithFormat:@"header-%i", _page + 1]].UIImage;
//        UIImageView *imgView = (UIImageView*)[self.view viewWithTag:_page + 100];
//        [imgView setImage:imgSelect];
//        
//        if (_lastPage != _page) {
//            UIImage *imgSelectLast = [SVGKImage imageNamed:[NSString stringWithFormat:@"header-%i-white", _lastPage + 1]].UIImage;
//            UIImageView *imgViewLast = (UIImageView*)[self.view viewWithTag:_lastPage + 100];
//            [imgViewLast setImage:imgSelectLast];
//        }
//        
//        _lastPage=_page;
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.homePageV6.scCollection reloadData];
    
    if (scrollView == mainScroll) {
        
//        if (scrollView.contentOffset.x < self.view.bounds.size.width || page == 0) {
//            [mainScroll setScrollEnabled:NO];
//        }
//
//        [mainScroll setScrollEnabled:YES];
//        
//        int div=fmod(mainScroll.contentOffset.x , _pageW);
//        int _page=(mainScroll.contentOffset.x-div)/_pageW;
//        page = _page;
//        UIImageView *imgV=_allIcon[_page];
//        NSString *title=_allTitle[_page];
//        CGSize strSize=[title sizeWithFont:_pageTitleLa.font];
//        _txtW=strSize.width;
//        _pageTitleLa.frame =CGRectMake(0, 0, strSize.width, _iconW);
//        _pageTitleLa.text=title;
//        
//        [_pageTitleLa setAlpha:0.0];
//        [_pageTitleView setFrame:CGRectMake(imgV.frame.origin.x+_iconW, 0, 0, _iconW)];
//        //    CGRect rect=CGRectMake(imgV.frame.origin.x+_iconW, 0, strSize.width, _iconW);
//        _isInAni=YES;
//        
//        _aniTimeout=25;
//        _aniStep=0;
//        _isInAni=YES;
//        _timer=[NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(openAni:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        
//        UIImage *imgSelect = [SVGKImage imageNamed:[NSString stringWithFormat:@"header-%i", _page + 1]].UIImage;
//        UIImageView *imgView = (UIImageView*)[self.view viewWithTag:_page + 100];
//        [imgView setImage:imgSelect];
//        
//        if (_lastPage != _page) {
//            UIImage *imgSelectLast = [SVGKImage imageNamed:[NSString stringWithFormat:@"header-%i-white", _lastPage + 1]].UIImage;
//            UIImageView *imgViewLast = (UIImageView*)[self.view viewWithTag:_lastPage + 100];
//            [imgViewLast setImage:imgSelectLast];
//        }
//        
//        _lastPage=_page;
    }
    
}

#pragma -mark Animation show Page
-(void)openAni:(NSTimer*)step{
    
    if(_aniStep>_aniTimeout)
    {
        [_timer invalidate];
        _timer=0;
        _timer=[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(runCloseAni:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    CGRect rect=_pageTitleView.frame;
    float div=(float)_aniStep/(float)_aniTimeout;
    int w=(int)(div*(float)_txtW);
    int l=rect.origin.x;
    rect.size.width=w;
    _pageTitleView.frame=rect;
    [_pageTitleLa setAlpha:div];
    
    if(_lastPage+1<=[_allIcon count]-1)
    {
        for(int i=_lastPage+1;i<[_allIcon count];i++)
        {
            UIImageView *item=_allIcon[i];
            CGRect iRect=item.frame;
            iRect.origin.x=w+l;
            item.frame=iRect;
            l+=_iconW;
            
        }
    }
    _aniStep++;
}

-(void) runCloseAni:(NSTimer*)timer{
    [_timer invalidate];
    _timer=nil;
    _aniStep=0;
    _timer=[NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(closeAni:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)closeAni:(NSTimer*)timer{
    
    if(_aniStep>_aniTimeout)
    {
        [_timer invalidate];
        _timer=nil;
        _aniStep=0;
        
        _isInAni=NO;
        return;
    }
    
    CGRect rect=_pageTitleView.frame;
    float div=1.0 - (float)_aniStep/(float)_aniTimeout;
    int w=(int)(div*(float)_txtW);
    int l=rect.origin.x;
    rect.size.width=w;
    _pageTitleView.frame=rect;
    [_pageTitleLa setAlpha:div];
    if(_lastPage+1<=[_allIcon count]-1)
    {
        for(int i=_lastPage+1;i<[_allIcon count];i++)
        {
            
            UIImageView *item=_allIcon[i];
            CGRect iRect=item.frame;
            iRect.origin.x=l+w;
            item.frame=iRect;
            l+=_iconW;
            
        }
    }
    _aniStep++;
}

-(void)endAni{
    [_timer invalidate];
    _timer=nil;
    _isInAni=NO;
    _aniStep=0;
    CGRect rect=_pageTitleView.frame;
    rect.size.width=0;
    _pageTitleView.frame=rect;
    [_pageTitleLa setAlpha:0.0];
    
    int left=(_pageW-_iconW)/2 + _lastPage*_iconW;
    if(page+1<=[_allIcon count]-1)
    {
        for(int i=_lastPage+1;i<[_allIcon count];i++)
        {
            UIImageView *item=_allIcon[i];
            CGRect iRect=item.frame;
            iRect.origin.x=left + (i-_lastPage)*_iconW;
            item.frame=iRect;
        }
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
            NSLog(@"Invalid email address");
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

//    [self.homePageV6 setHidden:NO];
//    [self.homePageV6.scCollection reloadData];
//    [self.chatViewPage removeFromSuperview];

//    [[self.chatViewPage viewWithTag:100000] removeFromSuperview];
//    [[self.chatViewPage viewWithTag:200000] removeFromSuperview];
    
    [UIView animateWithDuration:0.1 animations:^{
        [mainScroll setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:YES];
    }];
    
    [self.homePageV6.scCollection reloadData];

//    [self.chatViewPage.tbView setClearData:YES];
//    [self.chatViewPage resetCamera];
//    [self.chatViewPage.tbView reloadData];
}

#pragma mark - private function

//- (void) processLogin{
//    NSString *data = [[NSString alloc] init];
//    int userID = -1;
//    data = [dataNet stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
//
//    NSArray *subCommand = [data componentsSeparatedByString:@"{"];
//    NSArray *subData = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
//    if ([subData count] > 0) {
//        NSArray *subParameter = [[subData objectAtIndex:0] componentsSeparatedByString:@"}"];
//        if ([[subParameter objectAtIndex:0] intValue] > 0) {
//            userID = [[subParameter objectAtIndex:0] intValue];
//            NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
//            [_default setBool:YES forKey:@"IsLogin"];
//            [_default setInteger:[[subParameter objectAtIndex:0] integerValue] forKey:@"UserID"];
//            [_default setInteger:[[subParameter objectAtIndex:0] integerValue] forKey:@"keyMessage"];
//            [_default setObject:[subParameter objectAtIndex:5] forKey:@"accessKey"];
//        }
//    }
//    
//    if (userID > 0) {
//        //Load Friend from database
//        
//        [self.dataMapIns mapLogin:data];
//    }
//}

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
            
            NSInteger keyMessage = [[subParameter objectAtIndex:1] integerValue];
            
            BOOL isDelete = [self.storeIns deleteMessenger:userReceiveID withKeyMessenger:keyMessage];
            
            if (isDelete) {
                [self.coziCoreDataIns deleteMessenger:(int)keyMessage];
            }
            
        }else{
            //Delete failed
        }
    }
}



- (void) showAddPost{

    postWall = [[PostViewController alloc] init];
    [postWall setup];
    UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:postWall];
    [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
    [naviController setDelegate:self];
    
    [self presentViewController:naviController animated:YES completion:^{
        
    }];
}

#pragma -mark StoreDelegate
- (void) reloadChatView{
    [self.chatViewPage autoScrollTbView];
    
    [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
    [self.homePageV6.scCollection reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
