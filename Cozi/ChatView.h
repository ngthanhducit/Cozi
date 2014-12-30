//
//  ChatView.h
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMessageTableView.h"
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

@interface ChatView : SwapView <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, SCMessageTableViewDelegate, UIScrollViewDelegate, HPGrowingTextViewDelegate,UIGestureRecognizerDelegate>
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
}

@property (nonatomic, strong) Store                *storeIns;
@property (nonatomic, strong) Helper               *helperIns;
@property (nonatomic, strong) NetworkCommunication *networkIns;
@property (nonatomic, strong) DataMap              *dataMapIns;
@property (nonatomic, strong) Friend               *friendIns;

@property (nonatomic, strong) SCMessageTableView   *tbView;
@property (nonatomic, strong) UIView               *messageView;
//@property (nonatomic, strong) SCTextField          *scTextChat;
@property (nonatomic, strong) HPGrowingTextView          *hpTextChat;
@property (nonatomic, strong) UIView               *viewSendMessage;

@property (nonatomic, strong) UIButton             *btnTakePhoto;
@property (nonatomic, strong) UIButton             *btnPhoto;
@property (nonatomic, strong) UIButton             *btnLocation;
@property (nonatomic, strong) UIButton             *btnSend;
@property (nonatomic, strong) UIView               *viewToolKit;

@property (nonatomic, strong) UIImageView               *imgViewAvatar;
@property (nonatomic, strong) UIView                    *viewInfo;
@property (nonatomic, strong) UILabel                   *lblFirstName;
@property (nonatomic, strong) UILabel                   *lblLastName;
@property (nonatomic, strong) UILabel                   *lblLocationInfo;

- (NSData*) getImgDataSend;
- (void) addFriendIns:(Friend*)_friendInstance;
- (void) reloadFriend;
- (void) initFriendInfo:(Friend *)_myFriend;
- (void) autoScrollTbView;
- (void) initLibraryImage;
- (void) resetCamera;
@end
