//
//  JoinNowPageView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTextField.h"
#import "Helper.h"
#import "GenderView.h"
#import "AvatarButton.h"
#import "TriangleView.h"
#import "CameraCaptureV6.h"
#import "AvatarPreview.h"

@interface JoinNowPageView : UIView <UIActionSheetDelegate>
{

}

@property (nonatomic, strong) SCTextField           *txtUserNameJoin;
@property (nonatomic, strong) SCTextField           *txtPasswordJoin;
@property (nonatomic, strong) SCTextField           *txtRePasswordJoin;
@property (nonatomic, strong) SCTextField           *txtBirthDayJoin;
@property (nonatomic, strong) SCTextField           *txtPhone;
@property (nonatomic, strong) SCTextField           *txtEmail;
@property (nonatomic, strong) SCTextField           *txtFirstN;
@property (nonatomic, strong) SCTextField           *txtLastN;

@property (nonatomic, strong) UIImage               *imgAvatar;
@property (nonatomic, strong) CameraCaptureV6         *cameraCapture;
@property (nonatomic, strong) AvatarPreview         *avatarPreview;
@property (nonatomic, strong) AvatarButton              *btnProfile;
@property (nonatomic, strong) Helper                *helperIns;
@property (nonatomic, strong) UIButton              *btnJoinNow;
@property (nonatomic, strong) UIButton              *btnBack;
@property (nonatomic, strong) GenderView            *btnGender;
@property (nonatomic, strong) UIView                *mainJoinView;

@property (nonatomic, strong) UIImage               *thumbnail;
@property (nonatomic, strong) UIImage               *avatar;

- (void) setAvatar:(UIImage *)_imgAvatar withThumbnail:(UIImage *)_imgThumbnail;
@end
