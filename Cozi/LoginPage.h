//
//  LoginPage.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "SCTextField.h"
#import "TriangleView.h"
#import "SignInPageView.h"
#import "JoinNowPageView.h"
#import "EnterPhone.h"
#import "SCScrollJoinNow.h"
#import "EnterAuthCodeView.h"

@interface LoginPage : UIView
{
    BOOL                _isShowView;
    BOOL                _isShowLoading;
}

@property (nonatomic, strong) Helper                *helperIns;

@property (nonatomic, strong) UIView                *viewSignIn;
@property (nonatomic, strong) UIView                *viewJoinNow;
@property (nonatomic, strong) SCTextField           *txtUserName;
@property (nonatomic, strong) SCTextField           *txtPassword;

@property (nonatomic, strong) SCTextField           *txtUserNameJoin;
@property (nonatomic, strong) SCTextField           *txtPasswordJoin;
@property (nonatomic, strong) SCTextField           *txtRePasswordJoin;
@property (nonatomic, strong) SCTextField           *txtEmailJoin;
@property (nonatomic, strong) SCTextField           *txtGenderJoin;
@property (nonatomic, strong) SCTextField           *txtBirthDayJoin;

@property (nonatomic, strong) UIImageView           *logoView;
@property (nonatomic, strong) UIButton              *btnJoinNow;
@property (nonatomic, strong) UIButton              *btnSignIn;
@property (nonatomic, strong) UIButton               *btnForget;
@property (nonatomic, strong) UIView                *buttonView;

@property (nonatomic, strong) SignInPageView        *signInView;
@property (nonatomic, strong) EnterPhone            *enterPhoneView;
@property (nonatomic, strong) EnterAuthCodeView            *enterCodeView;
@property (nonatomic, strong) JoinNowPageView       *joinNowView;
@property (nonatomic, strong) SCScrollJoinNow          *joinNowScrollView;
@property (nonatomic, strong) UIView                *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView         *waiting;

- (void) startLoadingView;
- (void) stopLoadingView;
- (void) showAlert:(NSString*)_title withMessage:(NSString*)_message;

- (void) showViewEnterPerson;
- (void) showViewEnterCodeAuth;
- (UIImage *) getAvatar;
- (UIImage *) getThumbnail;
- (void) resetFirstFrom;
@end
