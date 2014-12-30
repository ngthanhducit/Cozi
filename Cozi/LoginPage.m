//
//  LoginPage.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "LoginPage.h"

@implementation LoginPage

@synthesize logoView;
@synthesize btnJoinNow;
@synthesize btnSignIn;
@synthesize signInView;
@synthesize txtUserName;
@synthesize txtPassword;
@synthesize viewSignIn;
@synthesize helperIns;
@synthesize viewJoinNow;
@synthesize buttonView;
@synthesize btnForget;
@synthesize waiting;
@synthesize loadingView;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVariable];
        
        [self setupUI];
        
    }
    
    return self;
}

- (void) setupVariable{
    self.helperIns = [Helper shareInstance];
}

- (void) setupUI{
    
    CGSize size = { self.bounds.size.width, self.bounds.size.height };
    
    [self setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]]];
    
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - (size.height / 5), size.width, size.height / 5)];
    
    UIImage *imgLogo = [UIImage imageNamed:@"logo-loading"];
    
    self.logoView = [[UIImageView alloc] initWithImage:imgLogo];
    [self.logoView setFrame:CGRectMake(self.center.x - imgLogo.size.width / 2, self.center.y - imgLogo.size.height, imgLogo.size.width, imgLogo.size.height)];
    [self addSubview:self.logoView];
    
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor colorWithRed:117.0/255.0f green:117.0/255.0f blue:117.0/255.0f alpha:1]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [self.helperIns imageWithView:triangleJoinNow];
    
    self.btnJoinNow = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnJoinNow setBackgroundColor:[UIColor clearColor]];
    [self.btnJoinNow setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnJoinNow.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnJoinNow setContentMode:UIViewContentModeCenter];
    [self.btnJoinNow setFrame:CGRectMake(0, 0, size.width / 2, size.height / 5)];
    [self.btnJoinNow setTitle:@"JOIN NOW" forState:UIControlStateNormal];
    [self.btnJoinNow addTarget:self action:@selector(btnJoinNowClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnJoinNow.titleLabel setFont:[self.helperIns getFontThin:15.0f]];
    
    CGSize sizeTitleLable = [self.btnJoinNow.titleLabel.text sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnJoinNow setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnJoinNow.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.btnJoinNow setTitleColor:[UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    UIColor *colorJoinNowNormal = [self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"BlueColor"]];
    UIColor *colorJoinNowHighLight = [self.helperIns colorFromRGBWithAlpha:[self.helperIns getHexIntColorWithKey:@"BlueColor"] withAlpha:0.8f];
    [self.btnJoinNow setBackgroundImage:[self.helperIns imageWithColor:colorJoinNowNormal] forState:UIControlStateNormal];
    [self.btnJoinNow setBackgroundImage:[self.helperIns imageWithColor:colorJoinNowHighLight] forState:UIControlStateHighlighted];
    [self.buttonView addSubview:self.btnJoinNow];
    
    //-----SignIn------
    
    TriangleView *triangleSignIn = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleSignIn setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1]];
    [triangleSignIn drawTriangleSignIn];
    
    UIImage *imgSignIn = [self.helperIns imageWithView:triangleSignIn];
    
    self.btnSignIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSignIn addTarget:self action:@selector(btnsignInClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSignIn setImage:imgSignIn forState:UIControlStateNormal];
    [self.btnSignIn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnSignIn setContentMode:UIViewContentModeCenter];
    [self.btnSignIn setFrame:CGRectMake((size.width / 2), 0, (size.width / 2), (size.height / 5) - 30)];
    [self.btnSignIn setTitle:@"SIGN IN" forState:UIControlStateNormal];
    [self.btnSignIn setContentEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.btnSignIn.titleLabel setFont:[self.helperIns getFontThin:15.0f]];
    [self.btnSignIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGSize sizeTitleLableSignIn = [self.btnSignIn.titleLabel.text sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnSignIn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgSignIn.size.width, 0, imgSignIn.size.width)];
    self.btnSignIn.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLableSignIn.width) + imgSignIn.size.width, 0, -((sizeTitleLableSignIn.width) + imgSignIn.size.width));
    
    UIColor *colorSignInNormal = [self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"BlueColor1"]];
    UIColor *colorSignInHighLight = [self.helperIns colorFromRGBWithAlpha:[self.helperIns getHexIntColorWithKey:@"BlueColor1"] withAlpha:0.8f];
    [self.btnSignIn setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [self.btnSignIn setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    [self.buttonView addSubview:self.btnSignIn];
    
    CGFloat yForget = self.btnSignIn.bounds.size.height;
    self.btnForget = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnForget setFrame:CGRectMake((size.width / 2), yForget, (size.width / 2), 30)];
    [self.btnForget setTitle:@"FORGOT PASSWORD?" forState:UIControlStateNormal];
    [self.btnForget setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnForget.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.btnForget.titleLabel setFont:[self.helperIns getFontThin:13]];
    
    UIColor *colorForgetNormal = [UIColor colorWithRed:0/255.0 green:166.0/255.0 blue:170.0/255.0 alpha:1.0];
    UIColor *colorForgetHighLight = [UIColor colorWithRed:0/255.0 green:166.0/255.0 blue:170.0/255.0 alpha:0.8f];
    [self.btnForget setBackgroundImage:[self.helperIns imageWithColor:colorForgetNormal] forState:UIControlStateNormal];
    [self.btnForget setBackgroundImage:[self.helperIns imageWithColor:colorForgetHighLight] forState:UIControlStateHighlighted];
    
    [self.buttonView addSubview:self.btnForget];
    
    [self addSubview:self.buttonView];
    
    self.signInView = [[SignInPageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
    [self.signInView setUserInteractionEnabled:YES];
    
    [self addSubview:self.signInView];
    
    self.joinNowScrollView =[[SCScrollJoinNow alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.joinNowScrollView setContentSize:CGSizeMake(self.bounds.size.width,self.bounds.size.height+ self.bounds.size.height - ((self.bounds.size.height / 3) * 2))];
    [self.joinNowScrollView setBackgroundColor:[UIColor clearColor]];
    [self.joinNowScrollView setShowsHorizontalScrollIndicator:NO];
    [self.joinNowScrollView setShowsVerticalScrollIndicator:NO];
    [self.joinNowScrollView setHidden:YES];
    
    self.joinNowView = [[JoinNowPageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - ((self.bounds.size.height / 3) * 2), size.width, size.height)];
    [self.joinNowView.btnBack addTarget:self action:@selector(btnBackTouches) forControlEvents:UIControlEventTouchUpInside];
    [self.joinNowScrollView addSubview:self.joinNowView];
    [self addSubview:self.joinNowScrollView];
    
    [self initLoadingView];
    
    //init enter phone view
    self.enterPhoneView = [[EnterPhone alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
    [self.enterPhoneView setUserInteractionEnabled:YES];
    
    [self addSubview:self.enterPhoneView];
    
    
    //init enter code view
    self.enterCodeView = [[EnterAuthCodeView alloc] initWithFrame:CGRectMake(self.bounds.size.width, self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
    [self.enterCodeView setUserInteractionEnabled:YES];
    [self.enterCodeView.btnSendCodeBack addTarget:self action:@selector(btnBackAuthCodeTouches) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.enterCodeView];
}

- (void) showViewEnterPerson{
    [self endEditing:YES];
    [self.joinNowScrollView setHidden:NO];
    [UIView animateWithDuration:0.5f animations:^{
        [self.enterCodeView setFrame:CGRectMake(-(self.bounds.size.width), self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
        
        [self.joinNowScrollView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) showViewEnterCodeAuth{
    [self endEditing:YES];
    [UIView animateWithDuration:0.5f animations:^{
        [self.enterPhoneView setFrame:CGRectMake(-(self.bounds.size.width), self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
        
        [self.enterCodeView setFrame:CGRectMake(0, self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) initLoadingView{
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(self.center.x - 100, self.center.y - 100, 200, 150)];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.cornerRadius = 10.0f;
    [self.loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    waiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [waiting setHidesWhenStopped:YES];
    [waiting setBackgroundColor:[UIColor clearColor]];
    [waiting setAlpha:0.8];
    [waiting setFrame:CGRectMake(0, 0, 200, 100)];
    
    [self.loadingView addSubview:waiting];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 50)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [loadingLabel setFont:[self.helperIns getFontThin:15.0f]];
    loadingLabel.text = @"Loading...";
    [loadingView addSubview:loadingLabel];
}

- (void) startLoadingView{
    [self.loadingView removeFromSuperview];
    [self addSubview:self.loadingView];
    [self.loadingView bringSubviewToFront:self];
    
    [self.waiting startAnimating];
    _isShowLoading = YES;
}

- (void) stopLoadingView{
    _isShowLoading = NO;
    [self.waiting stopAnimating];
    
    [self.loadingView removeFromSuperview];
}

- (void) showAlert:(NSString*)_title withMessage:(NSString*)_message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title message:_message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - Event Button
- (void) btnsignInClick{
    
    if (_isShowLoading) {
        return;
    }
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.buttonView setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width / 2, self.btnJoinNow.bounds.size.height)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.signInView setFrame:CGRectMake(0, self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height -  (self.bounds.size.height / 3))];
            
            [self.logoView setFrame:CGRectMake(self.center.x - self.logoView.image.size.width / 2, 10, self.logoView.bounds.size.width, self.logoView.bounds.size.height)];
        } completion:^(BOOL finished) {
            _isShowView = YES;
        }];
    }];
}

- (void) btnJoinNowClick{
    if (_isShowLoading) {
        return;
    }
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.buttonView setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width / 2, self.btnJoinNow.bounds.size.height)];

    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.enterPhoneView setFrame:CGRectMake(0, self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
            
            [self.logoView setFrame:CGRectMake(self.center.x - self.logoView.image.size.width / 2, 10, self.logoView.bounds.size.width, self.logoView.bounds.size.height)];
        } completion:^(BOOL finished) {
            _isShowView = YES;
        }];
    }];
}

#pragma mark - Touches View
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (_isShowLoading) {
        return;
    }
    
    [self endEditing:YES];
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] != self.enterPhoneView && [touch view] != self.signInView) {

        [self resetFirstFrom];
        
    }
    
    [self.signInView.txtUserName resignFirstResponder];
    [self.signInView.txtPassword resignFirstResponder];
    
}

- (void) resetFirstFrom{
    if (_isShowLoading) {
        return;
    }
    
    [self endEditing:YES];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.signInView setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height / 3)];
        [self.enterPhoneView setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height / 3)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.buttonView setFrame:CGRectMake(0, self.bounds.size.height - (self.bounds.size.height / 5), self.bounds.size.width, self.bounds.size.height / 5)];
            
            [self.logoView setFrame:CGRectMake(self.center.x - self.logoView.image.size.width / 2, self.center.y - self.logoView.image.size.height, self.logoView.bounds.size.width, self.logoView.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            
        }];
    }];

    
    [self.signInView.txtUserName resignFirstResponder];
    [self.signInView.txtPassword resignFirstResponder];
}

- (void) btnBackTouches{
    if (_isShowLoading) {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.enterCodeView setFrame:CGRectMake(0, self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
        
        [self.joinNowScrollView setFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];

    } completion:^(BOOL finished) {
        [self.joinNowScrollView setHidden:YES];
    }];
}

- (void) btnBackAuthCodeTouches{
    if (_isShowLoading) {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.enterPhoneView setFrame:CGRectMake(0, self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
        
        [self.enterCodeView setFrame:CGRectMake(self.bounds.size.width, self.bounds.size.height / 3, self.bounds.size.width, self.bounds.size.height - (self.bounds.size.height / 3))];
        
    } completion:^(BOOL finished) {
        [self.joinNowScrollView setHidden:YES];
    }];
}

- (UIImage *) getAvatar{
    return self.joinNowView.avatar;
}

- (UIImage *) getThumbnail{
    return self.joinNowView.thumbnail;
}

@end
