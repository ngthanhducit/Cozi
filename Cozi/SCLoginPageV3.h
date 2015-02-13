//
//  SCLoginPageV3.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriangleView.h"
#import "Helper.h"
#import "SCCameraCaptureV7.h"
#import "SCGridView.h"
#import "SCPhotoPreview.h"
#import "SCPhotoLibraryViewController.h"
#import "SCTextField.h"
#import "NetworkController.h"
#import "PNetworkCommunication.h"
#import "NetworkController.h"
#import "NewUser.h"
#import "Store.h"
#import "DataMap.h"

@interface SCLoginPageV3 : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PNetworkCommunication>
{
    Helper              *helperIns;
    NetworkController   *netIns;
    int                 totalPage;
    int                 cPage;
    int                 pPage;
    CGFloat             hHeader;
    CGFloat             hButton;
    CGSize              sizeText;
    CGFloat             hStartPage;
    
    CGFloat             hDisplayPhone;
    CGFloat             hKeyboard;
    
    CGFloat             hTool;
    CGFloat             yLineTool;
    
    int                 statusFlash; //0:off-1:on:2:auto
    BOOL                inSwitchCamera;
    BOOL                inChangeFlash;
    
    Store               *storeIns;
    DataMap             *dataMapIns;
    
    UIColor             *borderColor;
    
    UIImage             *imgAvatar;
    UIImage             *imgThumb;
    
//    AmazonInfo                      *amazonThumbnail;
//    AmazonInfo                      *amazonAvatar;
}

@property (nonatomic, strong) AmazonInfo            *amazonThumbnail;
@property (nonatomic, strong) AmazonInfo            *amazonAvatar;

//Header
@property (nonatomic, strong) UIView            *vHeader;
@property (nonatomic, strong) UIButton          *btnPrevious;
@property (nonatomic, strong) UIView            *vParentPage;

@property (nonatomic, strong) UIImageView       *imgLogo;
@property (nonatomic, strong) UILabel           *lblCozi;

//Login Page
@property (nonatomic, strong) UIView            *vLoginPage;
@property (nonatomic, strong) UIView            *vLogin;
@property (nonatomic, strong) SCTextField       *txtUserNameSignIn;
@property (nonatomic, strong) SCTextField       *txtPasswordSignIn;
@property (nonatomic, strong) UIButton          *btnShowPasswordSignIn;
@property (nonatomic, strong) UIButton          *btnSignIn;

//view start page
@property (nonatomic, strong) UIView            *vStartPage;
@property (nonatomic, strong) UIButton          *btnRegister;
@property (nonatomic, strong) UIButton          *btnLogin;
@property (nonatomic, strong) UIView            *vRegisterFB;

//view verify phone number
@property (nonatomic, strong) UIView            *vVerify;
@property (nonatomic, strong) UIView            *vDisplayPhone;
@property (nonatomic, strong) UIView            *vFlag;
@property (nonatomic, strong) UIView            *vIconFlag;
@property (nonatomic, strong) UILabel           *lblCountryCode;
@property (nonatomic, strong) SCTextField       *txtPhoneNumber;
@property (nonatomic, strong) UIView            *vKeyboard;
@property (nonatomic, strong) UIButton          *btnVerifyPhone;

//Popup
@property (nonatomic, strong) UIView            *vBlurPopup;
@property (nonatomic, strong) UIView            *vPopup;
@property (nonatomic, strong) UILabel           *lblConfirm;
@property (nonatomic, strong) UILabel           *lblPhoneNumber;
@property (nonatomic, strong) UIButton          *btnEdit;
@property (nonatomic, strong) UIButton          *btnContinue;

//Popup warning
@property (nonatomic, strong) UIView            *vBlurPopupWarning;
@property (nonatomic, strong) UIView            *vPopupWaring;
@property (nonatomic, strong) UILabel           *lblConfirmWaring;
@property (nonatomic, strong) UILabel           *lblPhoneNumberWaring;
@property (nonatomic, strong) UIButton          *btnEditWaring;
@property (nonatomic, strong) UIButton          *btnContinueWaring;

@property (nonatomic, strong) UIView            *vProgressBlur;
@property (nonatomic, strong) UIView            *vProgress;
@property (nonatomic, strong) UILabel           *lblProgressHeader;
@property (nonatomic, strong) UILabel           *lblContent;

//Email
@property (nonatomic, strong) UIView            *vEmail;
@property (nonatomic, strong) SCTextField       *txtEmail;

//Password
@property (nonatomic, strong) UIView            *vPassword;
@property (nonatomic, strong) UIView            *vPasswordField;
@property (nonatomic, strong) SCTextField       *txtPassword;
@property (nonatomic, strong) UIButton          *btnShowPassword;

@property (nonatomic, strong) UIView            *vName;
@property (nonatomic, strong) UIView            *vFullName;
@property (nonatomic, strong) SCTextField       *txtFirstName;
@property (nonatomic, strong) SCTextField       *txtLastName;

//Take a photo
@property (nonatomic, strong) UIView            *vCamera;
@property (nonatomic, strong) SCCameraCaptureV7 *cameraCapture;
@property (nonatomic, strong) UIView            *vTool;
@property (nonatomic, strong) UIButton          *btnLibrary;
@property (nonatomic, strong) UIButton          *btnGrid;
@property (nonatomic, strong) UIButton          *btnFlash;
@property (nonatomic, strong) UIButton          *btnSwithCamera;
@property (nonatomic, strong) UIButton          *btnTakePhoto;
@property (nonatomic, strong) SCGridView        *vGridLine;
@property (nonatomic, strong) UIButton          *btnSkip;

//Edit Photo
@property (nonatomic, strong) UIView            *vEditPhoto;
@property (nonatomic, strong) SCPhotoPreview    *vPreviewPhoto;
@property (nonatomic, strong) SCGridView        *vGridLineEditPhoto;
@property (nonatomic, strong) UIButton          *btnDone;

- (void) resetForm;
- (void) resetFormLogin;
- (void) showHiddenPopupWarning:(BOOL)_isShow withWarning:(NSString*)_warning;
- (void) showHiddenProgress:(BOOL)_isShow;
@end
