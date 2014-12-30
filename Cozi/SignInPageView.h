//
//  SignInPageView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "TriangleView.h"
#import "SCTextField.h"

@interface SignInPageView : UIView <UITextFieldDelegate>
{
     CGSize                  sizeScreen;
}

@property (nonatomic, strong) Helper                *helperIns;
@property (nonatomic, strong) UIButton              *btnSignInView;
@property (nonatomic, strong) UIView                *viewInSignView;
@property (nonatomic, strong) UIView                *userNameView;
@property (nonatomic, strong) UIView                *passwordView;
@property (nonatomic, strong) SCTextField           *txtUserName;
@property (nonatomic, strong) SCTextField           *txtPassword;
@end
