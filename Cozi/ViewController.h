//
//  ViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import "SVGKImage.h"
#import "LoginPage.h"
#import "Store.h"
#import "Helper.h"
#import "DataMap.h"
#import "NetworkCommunication.h"
#import "MainPageV6.h"
#import "ChatView.h"
#import "PersonContact.h"
#import "HPGrowingTextView.h"
#import "ReceiveLocation.h"
#import "CoziCoreData.h"
#import "ImageRender.h" 
#import "MainPageV7.h"
#import "SCContactTableView.h"
#import "ImageLibraryViewController.h"
#import "Reachability.h"
#import "GPUImageGrayscaleFilter.h"
#import "DataWall.h"
#import "SCSearchBar.h"
#import "SCWallTableViewV2.h"
#import "NoisesPage.h"
#import "NetworkController.h"
#import "SCShareMenu.h"
#import "SCPostViewController.h"
#import "SCPostPhotoViewController.h"
#import "SCPostLocationViewController.h"
#import "SCMoodPostViewController.h"
#import "AmazonInfoPost.h"
#import "SCProfileViewController.h"
#import "SCFriendProfileViewController.h"
#import "SCSinglePostViewController.h"
#import "SCCommentViewController.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate, HPGrowingTextViewDelegate, StoreDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    BOOL                                        isEndScroll;
    BOOL                                        isValidCondition;
    BOOL                                        _isInAni;
    BOOL                                        beginShowMenu;
    BOOL                                        beginShowRightMenu;
    BOOL                                        showSiderBar;
    BOOL                                        showRightMenu;
    BOOL                                        isShow;
    RMMapView                                   *mapView;
    UIScrollView                                *mainScroll;
    UIView                                      *leftView;
    UIView                                      *rightView;
//    UIView                                      *blurLayer;
    UIView                                      *_pageTitleView;
    UILabel                                     *_pageTitleLa;
    NSMutableArray                              *_allIcon,*_allTitle;
    int                                         _lastPage,_aniTimeout,_aniStep,_txtW;
    int                                         _iconW,_pageW;
    int                                         page;
        int                                         currentPage;
    NSTimer                                     *_timer;
    CGPoint                                     preScrollLocation;
    CGPoint                                     beginScroll;
    
    UIPanGestureRecognizer *panGestureRecognizer;
    LoginPage                   *_loginPage;
    BOOL                                        isEnterBackground;
    BOOL    isBecomeActive;
    BOOL        isActiveFromBackground;
    
    NSString                    *_long;
    NSString                    *_lati;
    NSString                    *deviceToken;
    
    CLLocationManager           *locationManager;
    CLGeocoder                  *geoCoder;
    CLPlacemark                 *placeMark;
    
    NSOperationQueue            *loginQueue;
    
    NSMutableArray                    *contactList;
    
    AmazonInfo                      *amazonThumbnail;
    AmazonInfo                      *amazonAvatar;
    
    NSMutableData                   *dataLocation;
    UIView *containerView;
    HPGrowingTextView *textView;
    SCContactTableView                  *tbContact;
    UIView                              *headerView;
    UIScrollView                        *scrollHeader;
    
    //Parameter Right Menu
    UIView                              *rmHeader;
    UIScrollView                        *rmScrollView;
    UIButton                            *rmButtonPhone;
    UIButton                            *rmButtonCozi;
    UIButton                            *rmButtonOnline;
    UIView                              *rmLine;
    
    //network status
    Reachability                        *hostReachability;
    
    UIView                              *viewStatusConnect;
    UILabel                             *lblStatusConnect;
    
    int                                isConnected; //0: no connected - 1: connecting - 2:connected
    
    UIImageView                         *blurImage;
    UIView                              *blurView;
    
    CGFloat          heightRowLeftMenu;
    
    CGFloat                             heightHeader;
    //left right menu
    CGPoint                                     preLocation;
    CGPoint                                     preTouchLocation;
    
    SCSearchBar                         *searchRightMenu;
    
    CGFloat                     widthMenu;
    CGFloat                     deltaLeft;
    CGFloat                     deltaRight;
    CGFloat                     deltaMoveBlurView;
    BOOL                        isShowMenuLeft;
    BOOL                        isShowMenuRight;
    
    BOOL                        isFirstLoadWall;
    BOOL                        isFirstLoadNoise;
    
    BOOL                        isShowShareMenu;
    BOOL                        inShowShareMenu;
    UIView                      *vBlurShareMenu;
    
    CGFloat                     alphatView;
    NetworkController           *netController;
}

@property (nonatomic, strong) UILabel              *lblNickName;

@property (nonatomic, strong) Store                *storeIns;
@property (nonatomic, strong) CoziCoreData         *coziCoreDataIns;
@property (nonatomic, strong) Helper               *helperIns;
@property (nonatomic, strong) DataMap              *dataMapIns;
@property (nonatomic        ) NetworkCommunication *networkIns;

@property (nonatomic, strong) LoginPage            *loginPage;
@property (nonatomic, strong) SCWallTableViewV2       *wallPageV8;
@property (nonatomic, strong) NoisesPage               *noisePageV6;
@property (nonatomic, strong) ChatView             *chatViewPage;
@property (nonatomic, strong) MainPageV7           *homePageV6;
@property (nonatomic, strong) SCShareMenu           *shareMenu;

@property (nonatomic, strong) UIButton              *btnNewChat;

- (void) setup;
- (void) initializeGestures;
- (void) initRightMenu;
//- (void) vibrate;
- (void) deleteMessenger:(NSString *)value;
- (void) initLeftMenu;
@end

