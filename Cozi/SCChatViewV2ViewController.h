//
//  SCChatViewV2ViewController.h
//  Cozi
//
//  Created by ChjpCoj on 3/8/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMessageTableViewV3.h"
#import "SCTextField.h"
#import "Store.h"
#import "NetworkCommunication.h"
#import "DataMap.h"
#import "Helper.h"
#import "SwapView.h"
#import "TriangleView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CameraCaptureV6.h"
#import "AmazonInfo.h"
#import "UIImage+ImageEffects.h"
#import "HPGrowingTextView.h"
#import "ReceiveLocation.h"
#import "CoziCoreData.h"
#import "ImageLibraryViewController.h"
#import "SCChatToolKitView.h"
#import "SCRequestChat.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Recent.h"
#import "SCActivityIndicatorView.h"

@interface SCChatViewV2ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, SCMessageGroupTableViewDelegate, HPGrowingTextViewDelegate, UITextViewDelegate>
{
    BOOL                isShowPanel;
    BOOL                isShowKeyboar;
    TriangleView            *upTrian;
    TriangleView            *downTrian;
    CameraCaptureV6           *cameraPreview;
    UIView                      *viewLibrary;
    UIScrollView                    *scrollImageLibrary;
    int lastPhotoSelected;
    UIImage     *lastImageSelected;
    NSData                  *imgDataSend;
    UIButton            *btnCameraCapture;
    UIView *toolkitCamera;
    UILabel *lblTapTakePhoto;
    UILabel *lblSendPhoto;
    UILabel *lblCancelSend;
    UILabel *lblChangeCamera;
    BOOL    isTouchTableView;
    CGRect          lastFrameTextChat;
    CoziCoreData        *coziCoreData;
    BOOL                isBackCamera;
    
    UIButton            *btnShowLibrary;
    CGFloat             hHeader;
    UIView              *vHeader;
    
    int                 typeChat;
    NSMutableArray      *assetsThumbnail;
    NSMutableArray      *urlAssetsImage;
    SCActivityIndicatorView             *waitingLoadPhoto;
}

@property (nonatomic, strong) UIView                *vCameraTool;
@property (nonatomic, strong) UIView                *vNewMessage;
@property (nonatomic, strong) UILabel               *lblNewMessenger;
@property (nonatomic, strong) UILabel               *lblNickName;
@property (nonatomic, strong) SCChatToolKitView     *chatToolKit;
@property (nonatomic, strong) Store                *storeIns;
@property (nonatomic, strong) Helper               *helperIns;
@property (nonatomic, strong) NetworkCommunication *networkIns;
@property (nonatomic, strong) DataMap              *dataMapIns;
@property (nonatomic, strong) Recent                *recentIns;

@property (nonatomic, strong) SCMessageTableViewV3   *tbView;
@property (nonatomic, strong) HPGrowingTextView          *hpTextChat;
@property (nonatomic, strong) UIView               *viewSendMessage;

@property (nonatomic, strong) UIButton             *btnTakePhoto;
@property (nonatomic, strong) UIButton             *btnPhoto;
@property (nonatomic, strong) UIButton             *btnLocation;
@property (nonatomic, strong) UIView               *viewToolKit;

@property (nonatomic, strong) UIImageView               *imgViewAvatar;
@property (nonatomic, strong) UIView                    *viewInfo;
@property (nonatomic, strong) UILabel                   *lblFirstName;
@property (nonatomic, strong) UILabel                   *lblLastName;
@property (nonatomic, strong) UILabel                   *lblLocationInfo;
@property (nonatomic, strong) UIButton                  *btnBack;

@property (nonatomic, strong) SCRequestChat             *vRequestChat;

- (void) addRecent:(Recent *)_recent;
- (NSData*) getImgDataSend;
- (void) reloadFriend;
- (void) autoScrollTbView;
- (void) initLibraryImage;
- (void) resetCamera;
- (void) resetUI;
- (CGFloat) getHeaderHeight;
- (BOOL) getStatusIsShowPanel;
@end
