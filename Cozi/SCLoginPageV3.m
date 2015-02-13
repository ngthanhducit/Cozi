//
//  SCLoginPageV3.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCLoginPageV3.h"

@implementation SCLoginPageV3

// for ios 6
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initVariable];
        [self initNotification];
        [self setup];
    }
    
    return self;
}

- (void) initVariable{
    
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    dataMapIns = [DataMap shareInstance];
    
    netIns = [NetworkController shareInstance];
    [netIns addListener:self];
    
    cPage = 0;
    pPage = -1;
    totalPage = 7;
    hHeader = 40;
    hButton = 50.0f;
    hStartPage = 100.0f;
    hDisplayPhone = 60.0f;
    hKeyboard = 216;
    
    statusFlash = 0;
    
    hTool = self.view.bounds.size.height - (self.view.bounds.size.width + hHeader);
    sizeText = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    borderColor = [UIColor colorWithRed:110.0f/255.0f green:110.0f/255.0f blue:110.0f/255.0f alpha:1];
}

- (void) initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nsCompleteCapture) name:@"SC_CompleteCaptureCamera" object:nil];
}

- (void) setup{
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
    [self.vHeader setBackgroundColor:[UIColor orangeColor]];
    [self.vHeader setAlpha:0.5];
//    [self.view addSubview:self.vHeader];
    
    self.btnPrevious = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPrevious setBackgroundColor:[UIColor blackColor]];
    [self.btnPrevious setAlpha:0.3];
    [self.btnPrevious setHidden:YES];
//    [self.btnPrevious setTitle:@"<" forState:UIControlStateNormal];
    [self.btnPrevious setImage:[helperIns getImageFromSVGName:@"icon-backarrow-25px-V2.svg"] forState:UIControlStateNormal];
    [self.btnPrevious setTitleColor:borderColor forState:UIControlStateNormal];
    [self.btnPrevious setFrame:CGRectMake(0, 0, hHeader, hHeader)];
    [self.btnPrevious addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.btnPrevious];
//    [self.vHeader addSubview:self.btnPrevious];
    
    self.imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2) - 40, hHeader, 80, 80)];
    [self.imgLogo setImage:[helperIns getImageFromSVGName:@"header-4-white.svg"]];
    [self.view addSubview:self.imgLogo];
    
    self.lblCozi = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2) - 50, hHeader * 2, 100, 100)];
    [self.lblCozi setText:@"COZI"];
    [self.lblCozi setTextAlignment:NSTextAlignmentCenter];
    [self.lblCozi setTextColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.lblCozi setFont:[helperIns getFontLight:20.0f]];
    [self.view addSubview:self.lblCozi];
    
    self.vParentPage = [[UIView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width * totalPage, self.view.bounds.size.height - hHeader)];
    [self.vParentPage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.vParentPage];
    
    [self initStartPage];
    
    [self initPhoneNumber];
    
    [self initLoginPage];
    
    [self initPopup];
    
    [self initPopupWarning];
    
    [self initPopupProgress];
    
    [self initEmail];
    
    [self initPassword];
    
    [self initName];
    
    [self initCamera];
    
    [self initEditPhoto];

}

- (void) initStartPage{
    self.vStartPage = [[UIView alloc] initWithFrame:CGRectMake(0, self.vParentPage.bounds.size.height - hStartPage, self.view.bounds.size.width, hStartPage)];
    [self.vParentPage addSubview:self.vStartPage];
    
    TriangleView *triangle = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangle setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [triangle drawTriangleSignIn];
    UIImage *imgTriangle = [helperIns imageWithView:triangle];
    
    self.btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnRegister setFrame:CGRectMake(0, 0, self.view.bounds.size.width / 2, hButton)];
    [self.btnRegister setBackgroundColor:[UIColor clearColor]];
    [self.btnRegister setImage:imgTriangle forState:UIControlStateNormal];
    [self.btnRegister.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnRegister setContentMode:UIViewContentModeCenter];
    [self.btnRegister setTitle:@"REGISTER" forState:UIControlStateNormal];
    [self.btnRegister addTarget:self action:@selector(btnRegisterClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRegister.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnRegister.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnRegister setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgTriangle.size.width, 0, imgTriangle.size.width)];
    self.btnRegister.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgTriangle.size.width, 0, -((sizeTitleLable.width) + imgTriangle.size.width));
    
    [self.btnRegister setTitleColor:[UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    UIColor *colorJoinNowNormal = [UIColor whiteColor];
    UIColor *colorJoinNowHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:0.8f];
    [self.btnRegister setBackgroundImage:[helperIns imageWithColor:colorJoinNowNormal] forState:UIControlStateNormal];
    [self.btnRegister setBackgroundImage:[helperIns imageWithColor:colorJoinNowHighLight] forState:UIControlStateHighlighted];
    [self.vStartPage addSubview:self.btnRegister];
    
    //init button login
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLogin setFrame:CGRectMake((self.vStartPage.bounds.size.width / 2) + 1, 0, (self.view.bounds.size.width / 2) - 1, hButton)];
    [self.btnLogin setBackgroundColor:[UIColor clearColor]];
    [self.btnLogin setImage:imgTriangle forState:UIControlStateNormal];
    [self.btnLogin.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnLogin setContentMode:UIViewContentModeCenter];
    [self.btnLogin setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.btnLogin addTarget:self action:@selector(btnLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogin.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLogin = [self.btnLogin.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnLogin setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgTriangle.size.width, 0, imgTriangle.size.width)];
    self.btnLogin.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLogin.width) + imgTriangle.size.width, 0, -((sizeTitleLogin.width) + imgTriangle.size.width));
    
    [self.btnLogin setTitleColor:[UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [self.btnLogin setBackgroundImage:[helperIns imageWithColor:colorJoinNowNormal] forState:UIControlStateNormal];
    [self.btnLogin setBackgroundImage:[helperIns imageWithColor:colorJoinNowHighLight] forState:UIControlStateHighlighted];
    [self.vStartPage addSubview:self.btnLogin];
    
    //init button register facebook
    self.vRegisterFB = [[UIView alloc] initWithFrame:CGRectMake(0, hStartPage - hButton, self.view.bounds.size.width, hButton)];
    [self.vRegisterFB setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.vStartPage addSubview:self.vRegisterFB];
}

- (void) initPhoneNumber{
    self.vVerify = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 1, self.vParentPage.bounds.size.height - ((hButton * 2) + 20), self.view.bounds.size.width, (hButton * 2) + 20)];
    [self.vVerify setBackgroundColor:[UIColor blackColor]];
    [self.vParentPage addSubview:self.vVerify];

    self.vDisplayPhone = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width - 40, hButton)];
    self.vDisplayPhone.layer.borderColor = borderColor.CGColor;
    self.vDisplayPhone.layer.borderWidth = 0.5f;
    [self.vVerify addSubview:self.vDisplayPhone];
    
    self.txtPhoneNumber = [[SCTextField alloc] initWithdata:20 withPaddingRight:20 withIcon:nil withFont:[helperIns getFontLight:14] withTextColor:borderColor withFrame:CGRectMake(0, 0, self.vDisplayPhone.bounds.size.width, self.vDisplayPhone.bounds.size.height)];
//    [self.txtPhoneNumber setTextColor:borderColor];
    [self.txtPhoneNumber setTextColor:[UIColor whiteColor]];
    [self.txtPhoneNumber setPlaceholder:@"ENTER PHONE NUMBER"];
    [self.txtPhoneNumber setAutocorrectionType:hButton];
    [self.txtPhoneNumber setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtPhoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [self.txtPhoneNumber setReturnKeyType:UIReturnKeyGo];
    [self.txtPhoneNumber setBackgroundColor:[UIColor clearColor]];
    [self.vDisplayPhone addSubview:self.txtPhoneNumber];
    
    TriangleView *triangle = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangle setBackgroundColor:[UIColor whiteColor]];
    [triangle drawTriangleSignIn];
    UIImage *imgTriangle = [helperIns imageWithView:triangle];
    
    self.btnVerifyPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnVerifyPhone setFrame:CGRectMake(0, hButton + 20, self.view.bounds.size.width, hButton)];
    [self.btnVerifyPhone setImage:imgTriangle forState:UIControlStateNormal];
    [self.btnVerifyPhone.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnVerifyPhone setContentMode:UIViewContentModeCenter];
    [self.btnVerifyPhone setTitle:@"VERIFY PHONE NUMBER" forState:UIControlStateNormal];
    [self.btnVerifyPhone.titleLabel setTextColor:[UIColor whiteColor]];
    [self.btnVerifyPhone addTarget:self action:@selector(btnVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnVerifyPhone.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnVerifyPhone.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnVerifyPhone setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgTriangle.size.width, 0, imgTriangle.size.width)];
    self.btnVerifyPhone.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgTriangle.size.width, 0, -((sizeTitleLable.width) + imgTriangle.size.width));
    
    UIColor *colorJoinNowNormal = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]];
    UIColor *colorJoinNowHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:0.8f];
    [self.btnVerifyPhone setBackgroundImage:[helperIns imageWithColor:colorJoinNowNormal] forState:UIControlStateNormal];
    [self.btnVerifyPhone setBackgroundImage:[helperIns imageWithColor:colorJoinNowHighLight] forState:UIControlStateHighlighted];
    [self.vVerify addSubview:self.btnVerifyPhone];
    
//
//    self.vFlag = [[UIView alloc] initWithFrame:CGRectMake(10, hDisplayPhone / 4, hDisplayPhone / 2, hDisplayPhone / 2)];
//    [self.vFlag setBackgroundColor:[UIColor redColor]];
//    [self.vDisplayPhone addSubview:self.vFlag];
//    
//    self.vIconFlag = [[UIView alloc] initWithFrame:CGRectMake(10 + (hDisplayPhone / 2), (hDisplayPhone / 2) - 10, 20, 20)];
//    [self.vIconFlag setBackgroundColor:[UIColor yellowColor]];
//    [self.vDisplayPhone addSubview:self.vIconFlag];
//    
//    CGSize sizeCountryCode = [@"+84 - " sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByWordWrapping];
//
//    self.lblCountryCode = [[UILabel alloc] initWithFrame:CGRectMake(30 + (hDisplayPhone / 2), (hDisplayPhone / 2) - 25, sizeCountryCode.width, 50)];
//    [self.lblCountryCode setText:@"+84 - "];
//    [self.lblCountryCode setFont:[helperIns getFontLight:15.0f]];
//    [self.lblCountryCode setTextAlignment:NSTextAlignmentCenter];
//    [self.lblCountryCode setTextColor:[UIColor whiteColor]];
//    [self.lblCountryCode setBackgroundColor:[UIColor blueColor]];
//    [self.vDisplayPhone addSubview:self.lblCountryCode];
//    
//    //txtPhoneNumber
//    self.txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(self.lblCountryCode.frame.origin.x + self.lblCountryCode.bounds.size.width, 0, self.vDisplayPhone.bounds.size.width - (60 + hDisplayPhone), hDisplayPhone)];
//    [self.txtPhoneNumber setPlaceholder:@"PHONE NUMBER"];
//    [self.txtPhoneNumber setBackgroundColor:[UIColor clearColor]];
//    [self.txtPhoneNumber setTextColor:[UIColor whiteColor]];
//    [self.txtPhoneNumber setFont:[helperIns getFontLight:15.0f]];
//    [self.vDisplayPhone addSubview:self.txtPhoneNumber];
//    

//    
//    self.vKeyboard = [[UIView alloc] initWithFrame:CGRectMake(0, self.vParentPage.bounds.size.height - (hKeyboard + hButton), self.view.bounds.size.width, hKeyboard)];
//    [self.vKeyboard setBackgroundColor:[UIColor redColor]];
//    [self.vVerify addSubview:self.vKeyboard];
}

- (void) initLoginPage{
    self.vLoginPage = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 1, 0, self.view.bounds.size.width, self.vParentPage.bounds.size.height)];
    [self.vLoginPage setHidden:YES];
    [self.vParentPage addSubview:self.vLoginPage];
    
    self.vLogin = [[UIView alloc] initWithFrame:CGRectMake(0, self.vLoginPage.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];
    [self.vLogin setBackgroundColor:[UIColor blackColor]];
    [self.vLoginPage addSubview:self.vLogin];
    
    TriangleView *triangle = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangle setBackgroundColor:[UIColor whiteColor]];
    [triangle drawTriangleSignIn];
    UIImage *imgTriangle = [helperIns imageWithView:triangle];
    
    self.btnSignIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSignIn setFrame:CGRectMake(0, self.vLogin.bounds.size.height - hButton, self.vLogin.bounds.size.width, hButton)];
    [self.btnSignIn setImage:imgTriangle forState:UIControlStateNormal];
    [self.btnSignIn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnSignIn setContentMode:UIViewContentModeCenter];
    [self.btnSignIn setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.btnSignIn.titleLabel setFont:[helperIns getFontLight:15.0f]];
    [self.btnSignIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGSize sizeTitleLable = [self.btnSignIn.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnSignIn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgTriangle.size.width, 0, imgTriangle.size.width)];
    self.btnSignIn.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgTriangle.size.width, 0, -((sizeTitleLable.width) + imgTriangle.size.width));
    
    UIColor *colorJoinNowNormal = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]];
    UIColor *colorJoinNowHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:0.8f];
    [self.btnSignIn setBackgroundImage:[helperIns imageWithColor:colorJoinNowNormal] forState:UIControlStateNormal];
    [self.btnSignIn setBackgroundImage:[helperIns imageWithColor:colorJoinNowHighLight] forState:UIControlStateHighlighted];
//    [self.vLogin addSubview:self.btnSignIn];
    
    self.txtUserNameSignIn = [[SCTextField alloc] initWithdata:20 withPaddingRight:20 withIcon:nil withFont:[helperIns getFontLight:14] withTextColor:borderColor withFrame:CGRectMake(20, 0, self.view.bounds.size.width - 40, hButton)];
    [self.txtUserNameSignIn setDelegate:self];
    [self.txtUserNameSignIn setTextColor:borderColor];
    [self.txtUserNameSignIn setPlaceholder:@"USERNAME"];
    [self.txtUserNameSignIn setText:@"duc@sycomore.vn"];
    [self.txtUserNameSignIn setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtUserNameSignIn setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtUserNameSignIn setReturnKeyType:UIReturnKeyNext];
    [self.txtUserNameSignIn setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.txtUserNameSignIn setBackgroundColor:[UIColor clearColor]];
    self.txtUserNameSignIn.layer.borderColor = borderColor.CGColor;
    self.txtUserNameSignIn.layer.borderWidth = 0.5f;
    [self.vLogin addSubview:self.txtUserNameSignIn];
    
    UIView *vTempPassword = [[UIView alloc] initWithFrame:CGRectMake(20, self.vLogin.bounds.size.height - ((hButton)), self.view.bounds.size.width - 40, hButton)];
    vTempPassword.layer.borderColor = borderColor.CGColor;
    vTempPassword.layer.borderWidth = 0.5f;
    
    [self.vLogin addSubview:vTempPassword];
    
    self.txtPasswordSignIn = [[SCTextField alloc] initWithdata:20 withPaddingRight:20 withIcon:nil withFont:[helperIns getFontLight:14] withTextColor:borderColor withFrame:CGRectMake(0, 0, vTempPassword.bounds.size.width - 40, hButton)];
    [self.txtPasswordSignIn setDelegate:self];
    [self.txtPasswordSignIn setSecureTextEntry:YES];
    [self.txtPasswordSignIn setTextColor:borderColor];
    [self.txtPasswordSignIn setPlaceholder:@"PASSWORD"];
    [self.txtPasswordSignIn setText:@"abc123"];
    [self.txtPasswordSignIn setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtPasswordSignIn setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtPasswordSignIn setReturnKeyType:UIReturnKeyGo];
    [self.txtPasswordSignIn setBackgroundColor:[UIColor clearColor]];
//    self.txtPasswordSignIn.layer.borderColor = borderColor.CGColor;
//    self.txtPasswordSignIn.layer.borderWidth = 0.5f;
//    [self.vLogin addSubview:self.txtPasswordSignIn];
    [vTempPassword addSubview:self.txtPasswordSignIn];
    
    UIImage *imgEye = [helperIns getImageFromSVGName:@"icon-EyeGrey-v2.svg"];
    
    self.btnShowPasswordSignIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnShowPasswordSignIn setImage:imgEye forState:UIControlStateNormal];
    [self.btnShowPasswordSignIn setAlpha:0.3];
    [self.btnShowPasswordSignIn setFrame:CGRectMake(vTempPassword.bounds.size.width - hButton, 0, hButton, hButton)];
    [self.btnShowPasswordSignIn addTarget:self action:@selector(showPasswordSiginClick:) forControlEvents:UIControlEventTouchUpInside];
    [vTempPassword addSubview:self.btnShowPasswordSignIn];

}

- (void) initPopup{
    self.vBlurPopup = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.vBlurPopup setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.78]];
    [self.vBlurPopup setHidden:YES];
    [self.view addSubview:self.vBlurPopup];
    
    self.vPopup = [[UIView alloc] initWithFrame:CGRectMake(10, (self.view.bounds.size.height / 2) - (self.view.bounds.size.width / 2) / 2, self.view.bounds.size.width - 20, self.view.bounds.size.width / 2)];
    [self.vPopup setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.vBlurPopup addSubview:self.vPopup];
    
    CGSize sizeTextConfirm = { self.vPopup.bounds.size.width , self.vPopup.bounds.size.width };
    CGSize sizeLblConfirm = [@"CONFIRM THIS IS YOUR PHONE NUMBER" sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeTextConfirm lineBreakMode:NSLineBreakByWordWrapping];
    
    self.lblConfirm = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.vPopup.bounds.size.width, sizeLblConfirm.height + 10)];
    [self.lblConfirm setNumberOfLines:0];
    [self.lblConfirm setText:@"CONFIRM THIS IS YOUR PHONE NUMBER"];
    [self.lblConfirm setTextColor:[UIColor blackColor]];
    [self.lblConfirm setTextAlignment:NSTextAlignmentCenter];
    [self.lblConfirm setFont:[helperIns getFontLight:13.0f]];
    [self.vPopup addSubview:self.lblConfirm];
    
    self.lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lblConfirm.bounds.size.height, self.vPopup.bounds.size.width, self.vPopup.bounds.size.height - (self.lblConfirm.bounds.size.height + hButton))];
    [self.lblPhoneNumber setText:[NSString stringWithFormat:@"+84 - %@", @"949797071"]];
    [self.lblPhoneNumber setTextAlignment:NSTextAlignmentCenter];
    [self.lblPhoneNumber setTextColor:[UIColor whiteColor]];
    [self.lblPhoneNumber setFont:[helperIns getFontLight:28.0f]];
    [self.vPopup addSubview:self.lblPhoneNumber];
    
    //
    TriangleView *triangle = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangle setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [triangle drawTrianglePre];
    UIImage *imgTriangle = [helperIns imageWithView:triangle];
    
    self.btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnEdit setFrame:CGRectMake(0, self.vPopup.bounds.size.height - hButton - 1, self.vPopup.bounds.size.width / 2, hButton)];
    [self.btnEdit setImage:imgTriangle forState:UIControlStateNormal];
    [self.btnEdit.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnEdit setContentMode:UIViewContentModeCenter];
    [self.btnEdit setTitle:@"EDIT" forState:UIControlStateNormal];
    [self.btnEdit addTarget:self action:@selector(btnVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEdit.titleLabel setFont:[helperIns getFontLight:15.0f]];
    [self.btnEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnEdit addTarget:self action:@selector(btnEditClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnEdit.imageEdgeInsets = UIEdgeInsetsMake(0, -imgTriangle.size.width, 0, imgTriangle.size.width);
    
    UIColor *colorJoinNowNormal = [UIColor whiteColor];
    UIColor *colorJoinNowHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:0.8f];
    [self.btnEdit setBackgroundImage:[helperIns imageWithColor:colorJoinNowNormal] forState:UIControlStateNormal];
    [self.btnEdit setBackgroundImage:[helperIns imageWithColor:colorJoinNowHighLight] forState:UIControlStateHighlighted];
    [self.vPopup addSubview:self.btnEdit];
    
    TriangleView *triangleCon = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleCon setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [triangleCon drawTriangleSignIn];
    UIImage *imgTriangleContinue = [helperIns imageWithView:triangleCon];
    
    //Next
    self.btnContinue = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnContinue setFrame:CGRectMake((self.vPopup.bounds.size.width / 2) + 1, self.vPopup.bounds.size.height - hButton - 1, (self.vPopup.bounds.size.width / 2) - 1, hButton)];
    [self.btnContinue setImage:imgTriangleContinue forState:UIControlStateNormal];
    [self.btnContinue.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnContinue setContentMode:UIViewContentModeCenter];
    [self.btnContinue setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [self.btnContinue addTarget:self action:@selector(btnVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnContinue.titleLabel setFont:[helperIns getFontLight:15.0f]];
    [self.btnContinue setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnContinue addTarget:self action:@selector(btnContinueClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize sizeTitleLable = [self.btnContinue.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnContinue setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgTriangleContinue.size.width, 0, imgTriangleContinue.size.width)];
    self.btnContinue.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgTriangleContinue.size.width, 0, -((sizeTitleLable.width) + imgTriangleContinue.size.width));
    
    [self.btnContinue setBackgroundImage:[helperIns imageWithColor:colorJoinNowNormal] forState:UIControlStateNormal];
    [self.btnContinue setBackgroundImage:[helperIns imageWithColor:colorJoinNowHighLight] forState:UIControlStateHighlighted];
    [self.vPopup addSubview:self.btnContinue];
}

- (void) initPopupWarning{
    self.vBlurPopupWarning = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.vBlurPopupWarning setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.78]];
    [self.vBlurPopupWarning setHidden:YES];
    [self.view addSubview:self.vBlurPopupWarning];
    
    self.vPopupWaring = [[UIView alloc] initWithFrame:CGRectMake(10, (self.view.bounds.size.height / 2) - (self.view.bounds.size.width / 2) / 2, self.view.bounds.size.width - 20, self.view.bounds.size.width / 2)];
    [self.vPopupWaring setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.vBlurPopupWarning addSubview:self.vPopupWaring];
    
    CGSize sizeTextConfirm = { self.vPopupWaring.bounds.size.width , self.vPopupWaring.bounds.size.width };
    CGSize sizeLblConfirm = [@"WARNING" sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeTextConfirm lineBreakMode:NSLineBreakByWordWrapping];
    
    self.lblConfirmWaring = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.vPopupWaring.bounds.size.width, sizeLblConfirm.height + 10)];
    [self.lblConfirmWaring setNumberOfLines:0];
    [self.lblConfirmWaring setText:@"WARNING"];
    [self.lblConfirmWaring setTextColor:[UIColor blackColor]];
    [self.lblConfirmWaring setTextAlignment:NSTextAlignmentCenter];
    [self.lblConfirmWaring setFont:[helperIns getFontLight:13.0f]];
    [self.vPopupWaring addSubview:self.lblConfirmWaring];
    
    self.lblPhoneNumberWaring = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lblConfirm.bounds.size.height, self.vPopupWaring.bounds.size.width, self.vPopupWaring.bounds.size.height - (self.lblConfirm.bounds.size.height + hButton))];
    [self.lblPhoneNumberWaring setText:[NSString stringWithFormat:@"+84 - %@", @"949797071"]];
    [self.lblPhoneNumberWaring setTextAlignment:NSTextAlignmentCenter];
    [self.lblPhoneNumberWaring setTextColor:[UIColor whiteColor]];
    [self.lblPhoneNumberWaring setFont:[helperIns getFontLight:18.0f]];
    [self.lblPhoneNumberWaring setLineBreakMode:0];
    [self.vPopupWaring addSubview:self.lblPhoneNumberWaring];
    
    TriangleView *triangleCon = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleCon setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [triangleCon drawTriangleSignIn];
    UIImage *imgTriangleContinue = [helperIns imageWithView:triangleCon];
    
    //Next
    self.btnContinueWaring = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnContinueWaring setFrame:CGRectMake(1, self.vPopupWaring.bounds.size.height - hButton - 1, (self.vPopupWaring.bounds.size.width) - 1, hButton)];
    [self.btnContinueWaring setImage:imgTriangleContinue forState:UIControlStateNormal];
    [self.btnContinueWaring.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnContinueWaring setContentMode:UIViewContentModeCenter];
    [self.btnContinueWaring setTitle:@"OK" forState:UIControlStateNormal];
    [self.btnContinueWaring addTarget:self action:@selector(btnWaring:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnContinueWaring.titleLabel setFont:[helperIns getFontLight:15.0f]];
    [self.btnContinueWaring setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGSize sizeTitleLable = [self.btnContinueWaring.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnContinueWaring setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgTriangleContinue.size.width, 0, imgTriangleContinue.size.width)];
    self.btnContinueWaring.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgTriangleContinue.size.width, 0, -((sizeTitleLable.width) + imgTriangleContinue.size.width));
    
    UIColor *colorJoinNowNormal = [UIColor whiteColor];
    UIColor *colorJoinNowHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:0.8f];

    [self.btnContinueWaring setBackgroundImage:[helperIns imageWithColor:colorJoinNowNormal] forState:UIControlStateNormal];
    [self.btnContinueWaring setBackgroundImage:[helperIns imageWithColor:colorJoinNowHighLight] forState:UIControlStateHighlighted];
    [self.vPopupWaring addSubview:self.btnContinueWaring];
}

- (void) initPopupProgress{
    self.vProgressBlur = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.vProgressBlur setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    [self.vProgressBlur setHidden:YES];
    [self.view addSubview:self.vProgressBlur];
    
    self.vProgress = [[UIView alloc] initWithFrame:CGRectMake(10, (self.view.bounds.size.height / 2) - (self.view.bounds.size.width / 2) / 2, self.view.bounds.size.width - 20, self.view.bounds.size.width / 2)];
    [self.vProgress setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.vProgressBlur addSubview:self.vProgress];
    
//    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake((self.vProgress.bounds.size.width / 2) - 40, hHeader / 2, 80, 80)];
//    [imgLogo setImage:[helperIns getImageFromSVGName:@"header-4-white.svg"]];
//    [self.vProgress addSubview:imgLogo];
    
    UIActivityIndicatorView *waiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [waiting setFrame:CGRectMake((self.vProgress.bounds.size.width / 2) - 40, hHeader / 2, 80, 80)];
    [waiting startAnimating];
    [self.vProgress addSubview:waiting];
    
    self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(0, self.vProgress.bounds.size.height - 60, self.vProgress.bounds.size.width, 60)];
    [self.lblContent setText:@"LOADING..."];
    [self.lblContent setTextAlignment:NSTextAlignmentCenter];
    [self.lblContent setTextColor:[UIColor whiteColor]];
    [self.lblContent setFont:[helperIns getFontLight:18.0f]];
    [self.lblContent setLineBreakMode:0];
    [self.vProgress addSubview:self.lblContent];
}

- (void) initEmail{
    self.vEmail = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 2, 0, self.view.bounds.size.width, self.vParentPage.bounds.size.height)];
    [self.vParentPage addSubview:self.vEmail];
    
    self.txtEmail = [[SCTextField alloc] initWithdata:20 withPaddingRight:20 withIcon:nil withFont:[helperIns getFontLight:14] withTextColor:borderColor withFrame:CGRectMake(20, self.vEmail.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
    [self.txtEmail setDelegate:self];
    [self.txtEmail setTextColor:borderColor];
    [self.txtEmail setPlaceholder:@"ENTER EMAIL"];
    [self.txtEmail setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtEmail setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtEmail setReturnKeyType:UIReturnKeyGo];
    [self.txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.txtEmail setBackgroundColor:[UIColor clearColor]];
    self.txtEmail.layer.borderColor = borderColor.CGColor;
    self.txtEmail.layer.borderWidth = 0.5f;
    [self.vEmail addSubview:self.txtEmail];
}

- (void) initPassword{
    self.vPassword = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 3, 0, self.view.bounds.size.width, self.vParentPage.bounds.size.height)];
    [self.vParentPage addSubview:self.vPassword];
    
    self.vPasswordField = [[UIView alloc] initWithFrame:CGRectMake(20, self.vPassword.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
    self.vPasswordField.layer.borderColor = borderColor.CGColor;
    self.vPasswordField.layer.borderWidth = 0.5f;
    [self.vPassword addSubview:self.vPasswordField];
    
    self.txtPassword = [[SCTextField alloc] initWithdata:20 withPaddingRight:20 withIcon:nil withFont:[helperIns getFontLight:14] withTextColor:borderColor withFrame:CGRectMake(0, 0, self.vPasswordField.bounds.size.width - hButton, hButton)];
    [self.txtPassword setDelegate:self];
    [self.txtPassword setSecureTextEntry:YES];
    [self.txtPassword setTextColor:borderColor];
    [self.txtPassword setPlaceholder:@"PASSWORD"];
    [self.txtPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtPassword setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtPassword setReturnKeyType:UIReturnKeyGo];
    [self.txtPassword setBackgroundColor:[UIColor clearColor]];
    [self.vPasswordField addSubview:self.txtPassword];
    
    UIImage *imgEye = [helperIns getImageFromSVGName:@"icon-EyeGrey-v2.svg"];
    
    self.btnShowPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnShowPassword setImage:imgEye forState:UIControlStateNormal];
    [self.btnShowPassword setAlpha:0.3];
    [self.btnShowPassword setFrame:CGRectMake(self.vPasswordField.bounds.size.width - hButton, 0, hButton, hButton)];
    [self.btnShowPassword addTarget:self action:@selector(showPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.vPasswordField addSubview:self.btnShowPassword];
}

- (void) initName{
    self.vName = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 4, 0, self.view.bounds.size.width, self.vParentPage.bounds.size.height)];
    [self.vParentPage addSubview:self.vName];
    
    self.vFullName = [[UIView alloc] initWithFrame:CGRectMake(0, self.vName.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];
    [self.vFullName setBackgroundColor:[UIColor blackColor]];
    [self.vName addSubview:self.vFullName];
    
    self.txtFirstName = [[SCTextField alloc] initWithdata:20 withPaddingRight:20 withIcon:nil withFont:[helperIns getFontLight:14] withTextColor:borderColor withFrame:CGRectMake(20, 0, self.vFullName.bounds.size.width - 40, hButton)];
    [self.txtFirstName setDelegate:self];
    [self.txtFirstName setTextColor:borderColor];
    [self.txtFirstName setPlaceholder:@"FIRST NAME"];
    [self.txtFirstName setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtFirstName setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtFirstName setReturnKeyType:UIReturnKeyNext];
    [self.txtFirstName setBackgroundColor:[UIColor clearColor]];
    self.txtFirstName.layer.borderColor = borderColor.CGColor;
    self.txtFirstName.layer.borderWidth = 0.5f;
    [self.vFullName addSubview:self.txtFirstName];

    self.txtLastName = [[SCTextField alloc] initWithdata:20 withPaddingRight:20 withIcon:nil withFont:[helperIns getFontLight:14] withTextColor:borderColor withFrame:CGRectMake(20, hButton + 10, self.vFullName.bounds.size.width - 40, hButton)];
    [self.txtLastName setDelegate:self];
    [self.txtLastName setTextColor:borderColor];
    [self.txtLastName setPlaceholder:@"LAST NAME"];
    [self.txtLastName setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtLastName setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtLastName setReturnKeyType:UIReturnKeyGo];
    [self.txtLastName setBackgroundColor:[UIColor clearColor]];
    self.txtLastName.layer.borderColor = borderColor.CGColor;
    self.txtLastName.layer.borderWidth = 0.5f;
    [self.vFullName addSubview:self.txtLastName];
}

- (void) initCamera{
    self.vCamera = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 5, 0, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [self.vParentPage addSubview:self.vCamera];
    
    self.cameraCapture = [[SCCameraCaptureV7 alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [self.vCamera addSubview:self.cameraCapture];
    
    self.vTool = [[UIView alloc] initWithFrame:CGRectMake(0, self.vCamera.bounds.size.height - hTool, self.view.bounds.size.width, hTool)];
    [self.vTool setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    [self.vCamera addSubview:self.vTool];
    
    yLineTool = (self.vTool.bounds.size.height / 5)  * 2;

    CALayer *likeTool = [CALayer layer];
    [likeTool setFrame:CGRectMake(0.0f, yLineTool, self.view.bounds.size.width, 0.5f)];
//    [likeTool setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [likeTool setBackgroundColor:[UIColor colorWithRed:77.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1].CGColor];
    [self.vTool.layer addSublayer:likeTool];
    
    CGFloat hButtonTool = 40;
//    if ([[UIScreen mainScreen] bounds].size.height == 568)
//    {
//        hButtonTool = 45;
//        //iphone 5
//    }
//    else
//    {
//        hButtonTool = 35;
//        //iphone 3.5 inch screen iphone 3g,4s
//    }
    
    UIView *vLibrary = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 4, yLineTool)];
    [vLibrary setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vLibrary];
    
    self.btnLibrary = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLibrary setBackgroundColor:[UIColor blackColor]];
    [self.btnLibrary setFrame:CGRectMake((vLibrary.bounds.size.width / 2) - (hButtonTool / 2), (vLibrary.bounds.size.height / 2) - (hButtonTool / 2), hButtonTool, hButtonTool)];
    [self.btnLibrary setClipsToBounds:YES];
    [self.btnLibrary setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnLibrary setAutoresizingMask:UIViewAutoresizingNone];
    self.btnLibrary.layer.cornerRadius = self.btnLibrary.bounds.size.height / 2;
    self.btnLibrary.layer.borderWidth = 1.0f;
    self.btnLibrary.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnLibrary setImage:[helperIns getImageFromSVGName:@"icon-LibraryWhite-25px-V2.svg"] forState:UIControlStateNormal];
    [self.btnLibrary addTarget:self action:@selector(btnShowLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [vLibrary addSubview:self.btnLibrary];

    UIView  *vGrid = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, 0, self.view.bounds.size.width / 4, yLineTool)];
    [vGrid setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vGrid];
    
    self.btnGrid = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnGrid setBackgroundColor:[UIColor blackColor]];
    [self.btnGrid setFrame:CGRectMake((vGrid.bounds.size.width / 2) - (hButtonTool / 2), (vGrid.bounds.size.height / 2) - (hButtonTool / 2), hButtonTool, hButtonTool)];
    [self.btnGrid setClipsToBounds:YES];
    [self.btnGrid setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnGrid setAutoresizingMask:UIViewAutoresizingNone];
    self.btnGrid.layer.cornerRadius = self.btnGrid.bounds.size.height / 2;
    self.btnGrid.layer.borderWidth = 1.0f;
    self.btnGrid.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnGrid setImage:[helperIns getImageFromSVGName:@"icon-GridWhite-25px-V4.svg"] forState:UIControlStateNormal];
    [self.btnGrid addTarget:self action:@selector(btnShowHiddenGridTap:) forControlEvents:UIControlEventTouchUpInside];
    [vGrid addSubview:self.btnGrid];
    
    UIView *vSwithCamera = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 4) * 2, 0, self.view.bounds.size.width / 4, yLineTool)];
    [vSwithCamera setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vSwithCamera];
    
    self.btnSwithCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSwithCamera setBackgroundColor:[UIColor blackColor]];
    [self.btnSwithCamera setFrame:CGRectMake((vSwithCamera.bounds.size.width / 2) - (hButtonTool / 2), (vSwithCamera.bounds.size.height / 2) - (hButtonTool / 2), hButtonTool, hButtonTool)];
    [self.btnSwithCamera setClipsToBounds:YES];
    [self.btnSwithCamera setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnSwithCamera setAutoresizingMask:UIViewAutoresizingNone];
    self.btnSwithCamera.layer.cornerRadius = self.btnGrid.bounds.size.height / 2;
    self.btnSwithCamera.layer.borderWidth = 1.0f;
    self.btnSwithCamera.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnSwithCamera setImage:[helperIns getImageFromSVGName:@"icon-CameraWhite-25px.svg"] forState:UIControlStateNormal];
    [self.btnSwithCamera addTarget:self action:@selector(btnSwitchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [vSwithCamera addSubview:self.btnSwithCamera];
    
    UIView *vFlash = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 4) * 3, 0, self.view.bounds.size.width / 4, yLineTool)];
    [vFlash setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vFlash];
    
    self.btnFlash = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnFlash.titleLabel setFont:[helperIns getFontLight:8.0f]];
    [self.btnFlash setBackgroundColor:[UIColor blackColor]];
    [self.btnFlash setFrame:CGRectMake((vFlash.bounds.size.width / 2) - (hButtonTool / 2), (vFlash.bounds.size.height / 2) - (hButtonTool / 2), hButtonTool, hButtonTool)];
    [self.btnFlash setClipsToBounds:YES];
    [self.btnFlash setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnFlash setAutoresizingMask:UIViewAutoresizingNone];
    self.btnFlash.layer.cornerRadius = self.btnFlash.bounds.size.height / 2;
    self.btnFlash.layer.borderWidth = 1.0f;
    self.btnFlash.layer.borderColor = [UIColor whiteColor].CGColor;
//    [self.btnFlash setImage:[helperIns getImageFromSVGName:@"icon-camera-flash-off-25px.svg"] forState:UIControlStateNormal];
    [self.btnFlash addTarget:self action:@selector(btnChangeFlash:) forControlEvents:UIControlEventTouchUpInside];
    [vFlash addSubview:self.btnFlash];
    
    [self centerVerticalWithPading:0 withButton:self.btnFlash];
    
    UIView *vTakePhoto = [[UIView alloc] initWithFrame:CGRectMake(0, yLineTool, self.view.bounds.size.width, (self.vTool.bounds.size.height / 5)  * 3)];
    [vTakePhoto setUserInteractionEnabled:YES];
    [vTakePhoto setBackgroundColor:[UIColor clearColor]];
    [vTakePhoto setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vTakePhoto];
    
//    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    
//    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
//    [triangleJoinNow setBackgroundColor:[UIColor colorWithRed:117.0/255.0f green:117.0/255.0f blue:117.0/255.0f alpha:1]];
//    [triangleJoinNow drawTriangleSignIn];
//    UIImage *imgJoinNow = [helperIns imageWithView:triangleJoinNow];
//    
//    self.btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btnTakePhoto setBackgroundColor:[UIColor blackColor]];
//    [self.btnTakePhoto setImage:imgJoinNow forState:UIControlStateNormal];
//    [self.btnTakePhoto.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.btnTakePhoto setContentMode:UIViewContentModeCenter];
//    [self.btnTakePhoto setFrame:CGRectMake(0, 0, self.view.bounds.size.width, vTakePhoto.bounds.size.height)];
//    [self.btnTakePhoto setTitle:@"TAKE A SHOT" forState:UIControlStateNormal];
//    [self.btnTakePhoto addTarget:self action:@selector(btnTakePhotoTapRegister:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btnTakePhoto.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    UIView *vBorder = [[UIView alloc] initWithFrame:CGRectMake((vTakePhoto.bounds.size.width / 2) - ((vTakePhoto.bounds.size.height / 2) - 10), 10, vTakePhoto.bounds.size.height - 20, vTakePhoto.bounds.size.height - 20)];
    vBorder.clipsToBounds = YES;
    vBorder.layer.borderColor = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]].CGColor;
    vBorder.layer.borderWidth = 1.0f;
    [vBorder setBackgroundColor:[UIColor clearColor]];
    vBorder.layer.cornerRadius = vBorder.bounds.size.width / 2;
    vBorder.contentMode = UIViewContentModeScaleAspectFill;
    [vTakePhoto addSubview:vBorder];

    self.btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnTakePhoto setBackgroundColor:[UIColor whiteColor]];
    [self.btnTakePhoto.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnTakePhoto setFrame:CGRectMake((vTakePhoto.bounds.size.width / 2) - ((vTakePhoto.bounds.size.height / 2) - 15), 15, vTakePhoto.bounds.size.height - 30, vTakePhoto.bounds.size.height - 30)];
    self.btnTakePhoto.layer.cornerRadius = self.btnTakePhoto.bounds.size.width / 2;
    self.btnTakePhoto.clipsToBounds = YES;
    self.btnTakePhoto.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnTakePhoto setTitle:@"TAKE A SHOT" forState:UIControlStateNormal];
    [self.btnTakePhoto addTarget:self action:@selector(btnTakePhotoTapRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTakePhoto.titleLabel setFont:[helperIns getFontLight:15.0f]];
    [vTakePhoto addSubview:self.btnTakePhoto];
    
//Skip Button
    TriangleView *triangleSkip = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleSkip setBackgroundColor:[UIColor whiteColor]];
    [triangleSkip drawTriangleSignIn];
    UIImage *imgTriangleSkip = [helperIns imageWithView:triangleSkip];
    
    //Next
    self.btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSkip setFrame:CGRectMake(vTakePhoto.bounds.size.width - 100, (vTakePhoto.bounds.size.height / 2) - (hButton / 2), 100, hButton)];
    [self.btnSkip setBackgroundColor:[UIColor clearColor]];
    [self.btnSkip setImage:imgTriangleSkip forState:UIControlStateNormal];
    [self.btnSkip.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnSkip setContentMode:UIViewContentModeCenter];
    [self.btnSkip setTitle:@"SKIP" forState:UIControlStateNormal];
    [self.btnSkip addTarget:self action:@selector(btnVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSkip.titleLabel setFont:[helperIns getFontLight:15.0f]];
    [self.btnSkip setTitleColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] forState:UIControlStateNormal];
    [self.btnSkip addTarget:self action:@selector(btnSkipClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize sizeTitleLable = [self.btnSkip.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnSkip setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgTriangleSkip.size.width, 0, imgTriangleSkip.size.width)];
    self.btnSkip.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgTriangleSkip.size.width, 0, -((sizeTitleLable.width) + imgTriangleSkip.size.width));

    [vTakePhoto addSubview:self.btnSkip];
    
    self.vGridLine = [[SCGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.vGridLine setBackgroundColor:[UIColor clearColor]];
    [self.vGridLine setHidden:YES];
    [self.vGridLine setUserInteractionEnabled:NO];
    [self.vCamera addSubview:self.vGridLine];
}

- (void) initEditPhoto{
    self.vEditPhoto = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 6, 0, self.view.bounds.size.width, self.vParentPage.bounds.size.height)];
    [self.vParentPage addSubview:self.vEditPhoto];
    
    self.vPreviewPhoto = [[SCPhotoPreview alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.vEditPhoto addSubview:self.vPreviewPhoto];
    
    self.vGridLineEditPhoto = [[SCGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.vGridLineEditPhoto setBackgroundColor:[UIColor clearColor]];
    [self.vGridLineEditPhoto setUserInteractionEnabled:NO];
    [self.vEditPhoto addSubview:self.vGridLineEditPhoto];
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor whiteColor]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [helperIns imageWithView:triangleJoinNow];
    
    self.btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnDone setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.btnDone setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnDone.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnDone setContentMode:UIViewContentModeCenter];
    [self.btnDone setFrame:CGRectMake(0, self.vEditPhoto.bounds.size.height - hButton, self.view.bounds.size.width, hButton)];
    [self.btnDone setTitle:@"DONE" forState:UIControlStateNormal];
    [self.btnDone addTarget:self action:@selector(btnDoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDone.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnDone.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnDone setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnDone.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.btnDone setAlpha:0.8];
    [self.vEditPhoto addSubview:self.btnDone];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType == UIReturnKeyGo) {
        if (!self.vLoginPage.hidden) {
            //Call login
            if ([self.txtUserNameSignIn.text isEqualToString:@""] || [self.txtPasswordSignIn.text isEqualToString:@""]) {
                [self.view endEditing:YES];
                [self showHiddenPopupWarning:YES withWarning:@"Please enter username or password"];
                
                [self.vLogin setFrame:CGRectMake(0, self.vLoginPage.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];
                
                return NO;
            }
            
            [self.view endEditing:YES];
            
            [self.vProgressBlur setHidden:NO];
            
            [netIns login:self.txtUserNameSignIn.text withPassword:self.txtPasswordSignIn.text];
            
        }else{
        
            //check login
            if (cPage == 2) {
                if ([self.txtEmail.text isEqualToString:@""]) {
                    [self.txtEmail setFrame:CGRectMake(20, self.vEmail.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
                    [self.view endEditing:YES];
                    [self showHiddenPopupWarning:YES withWarning:@"Please enter email"];
                    
                    return NO;
                }
            
            }
            
            if (cPage == 3) {
                if ([self.txtPassword.text isEqualToString:@""]) {
                    
                    [self.vPasswordField setFrame:CGRectMake(20, self.vPassword.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
                    
                    [self.view endEditing:YES];
                    [self showHiddenPopupWarning:YES withWarning:@"Please enter password"];
                    
                    return NO;
                }
            }
            
            if (cPage == 4) {
                if ([self.txtFirstName.text isEqualToString:@""] || [self.txtLastName.text isEqualToString:@""]) {
                    [self.vFullName setFrame:CGRectMake(0, self.vName.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];
                    
                    [self.view endEditing:YES];
                    [self showHiddenPopupWarning:YES withWarning:@"Please Enter Name"];
                    
                    return NO;
                }
            }
            
            [self next];
        }

    }
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (cPage == 1) {
            [self.txtPasswordSignIn becomeFirstResponder];
        }
        
        if (cPage == 4) {
            [self.txtLastName becomeFirstResponder];
        }
    }
    
    return YES;
}

- (void) next{
    cPage++;
    if (self.btnPrevious.isHidden) {
        self.btnPrevious.hidden = NO;
    }

    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{

        [self.vParentPage setFrame:CGRectMake(-(self.view.bounds.size.width * cPage), hHeader, self.vParentPage.bounds.size.width, self.vParentPage.bounds.size.height)];
        
        if (cPage == 2 && self.vLoginPage.isHidden) {
            
            [self.vVerify setFrame:CGRectMake(self.view.bounds.size.width * 1, self.vParentPage.bounds.size.height - (hDisplayPhone + hButton + 10), self.view.bounds.size.width, hDisplayPhone + hButton + 10)];
        }
        
        if (cPage == 3) {
            [self.view endEditing:YES];
            [self.txtEmail setFrame:CGRectMake(20, self.vEmail.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
        }
        
        if (cPage == 4) {
            [self.view endEditing:YES];
            
            [self.vPasswordField setFrame:CGRectMake(20, self.vPassword.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
        }
        
        if (cPage == 5) {
            [self.view endEditing:YES];
            
            [self.vFullName setFrame:CGRectMake(0, self.vName.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];
        }
    } completion:^(BOOL finished) {
        
        if (cPage == 1 && !self.vLoginPage.isHidden) {
            [self.txtUserNameSignIn becomeFirstResponder];
        }
        
        if (cPage == 1 && self.vLoginPage.isHidden) {
            [self.txtPhoneNumber becomeFirstResponder];
        }
        
        //check page and action with page
        if (cPage == 2) {
            [self.txtEmail becomeFirstResponder];
        }
        
        if (cPage == 3) {
            [self.txtPassword becomeFirstResponder];
        }
        
        if (cPage == 4) {
            [self.txtFirstName becomeFirstResponder];
        }
    
    }];
    
}

- (void) previous{
    cPage--;
    [self.view endEditing:YES];

    if (cPage < 0) {
        cPage = 0;
        return;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.vParentPage setFrame:CGRectMake(-(self.view.bounds.size.width * cPage), hHeader, self.vParentPage.bounds.size.width, self.vParentPage.bounds.size.height)];
        
        if (cPage == 0 && !self.vLoginPage.isHidden) {

            [self.btnPrevious setHidden:YES];
            
            [self.vLogin setFrame:CGRectMake(0, self.vLoginPage.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];
        }
        
        if (cPage == 0 && self.vLoginPage.isHidden) {
            [self.btnPrevious setHidden:YES];
            
            [self.vVerify setFrame:CGRectMake(self.view.bounds.size.width * 1, self.vParentPage.bounds.size.height - (hDisplayPhone + hButton + 10), self.view.bounds.size.width, hDisplayPhone + hButton + 10)];
        }
        
        if (cPage == 1) {
            [self.txtEmail setFrame:CGRectMake(20, self.vEmail.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
        }
        
        if (cPage == 2) {
            [self.vPasswordField setFrame:CGRectMake(20, self.vPassword.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
        }
        
        if (cPage == 3) {
            [self.vFullName setFrame:CGRectMake(0, self.vName.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];
        }

    } completion:^(BOOL finished) {
        
        if (!self.vLoginPage.isHidden) {
            self.vLoginPage.hidden = YES;
            [self.vVerify setHidden:NO];
        }else{
            if (cPage == 1) {
                [self.txtPhoneNumber becomeFirstResponder];
            }

        }
        
        //check page and action with page
        if (cPage == 2) {
            [self.txtEmail becomeFirstResponder];
        }
        
        if (cPage == 3) {
            [self.txtPassword becomeFirstResponder];
        }
        
        if (cPage == 4) {
            [self.txtFirstName becomeFirstResponder];
        }

    }];
}

#pragma -mark handle event
- (void) btnRegisterClick:(id)sender{
    
    [self next];
    
}

- (void) btnVerifyClick:(id)sender{
    
    [self.view endEditing:YES];
    
    if ([self.txtPhoneNumber.text isEqualToString:@""]) {
        [self showHiddenPopupWarning:YES withWarning:@"Please enter phone number"];
        
        [self.vVerify setFrame:CGRectMake(self.view.bounds.size.width * 1, self.vParentPage.bounds.size.height - (hDisplayPhone + hButton + 10), self.view.bounds.size.width, hDisplayPhone + hButton + 10)];
    }else{
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.1 animations:^{
            
            [self.vVerify setFrame:CGRectMake(self.view.bounds.size.width * 1, self.vParentPage.bounds.size.height - (hDisplayPhone + hButton + 10), self.view.bounds.size.width, hDisplayPhone + hButton + 10)];
            
            [self.vBlurPopup setHidden:NO];
        }];
    }
    
}

- (void) showHiddenPopupWarning:(BOOL)_isShow withWarning:(NSString*)_warning{
    [self.vBlurPopupWarning setHidden:!_isShow];
    [self.lblPhoneNumberWaring setText:_warning];
}

- (void) btnWaring:(id)sender{
    
    if (cPage == 1 && !self.vLoginPage.isHidden) {
        [self.txtUserNameSignIn becomeFirstResponder];
    }
    
    if (cPage == 1 && self.vLoginPage.isHidden) {
        [self.txtPhoneNumber becomeFirstResponder];
    }
    
    if (cPage == 2) {
        [self.txtEmail becomeFirstResponder];
    }
    
    if (cPage == 3) {
        [self.txtPassword becomeFirstResponder];
    }
    
    if (cPage == 4) {
        [self.txtFirstName becomeFirstResponder];
    }
    
    [self.vBlurPopupWarning setHidden:YES];
}

- (void) btnEditClick:(id)sender{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.vBlurPopup setHidden:YES];
    } completion:^(BOOL finished) {
        [self.txtPhoneNumber becomeFirstResponder];
    }];
}

- (void) btnSkipClick:(id)sender{
    
}

- (void) btnContinueClick:(id)sender{
    NSString *phoneHash = [helperIns encoded:self.txtPhoneNumber.text];
    NSString *cmd = [NSString stringWithFormat:@"REG{%@}%@<EOF>", self.txtPhoneNumber.text, phoneHash];
    [netIns registerPhone:cmd];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.vBlurPopup setHidden:YES];
    } completion:^(BOOL finished) {
//        [self next];
    }];

}

- (void) btnDoneClick:(id)sender{
    CGRect visibleRect;
    float scale = (1.0f / self.vPreviewPhoto.scrollView.zoomScale);
    visibleRect.origin.x = (self.vPreviewPhoto.scrollView.contentOffset.x * scale);
    visibleRect.origin.y = (self.vPreviewPhoto.scrollView.contentOffset.y * scale);
    visibleRect.size.width = (self.vPreviewPhoto.scrollView.bounds.size.width * scale);
    visibleRect.size.height = (self.vPreviewPhoto.scrollView.bounds.size.height * scale);
    
    UIImage *imgCrop = self.vPreviewPhoto.imgViewCapture.image;
    
    visibleRect.origin.y = visibleRect.origin.y * [[UIScreen mainScreen] scale];
    visibleRect.origin.x = visibleRect.origin.x * [[UIScreen mainScreen] scale];
    visibleRect.size.width = visibleRect.size.width * [[UIScreen mainScreen] scale];
    visibleRect.size.height = visibleRect.size.height * [[UIScreen mainScreen] scale];
    UIImage *afterImage = [self imageFromView:imgCrop withRect:visibleRect];
    imgAvatar = [helperIns resizeImage:afterImage resizeSize:CGSizeMake(self.view.bounds.size.width * [[UIScreen mainScreen] scale], self.view.bounds.size.width * [[UIScreen mainScreen] scale])];
    imgThumb = [helperIns resizeImage:afterImage resizeSize:CGSizeMake(160, 160)];
    
    NSOperationQueue *uploadAvatarQueue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(processUpAvatar) object:nil];
    [uploadAvatarQueue addOperation:operation];
    
    [operation setCompletionBlock:^{
        
    }];
    
    [self showHiddenProgress:YES];
    
    NSString *strPassword = self.txtPasswordSignIn.text;
    
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
}


- (void) processUpAvatar{
    NSData *dataAvatar = [helperIns compressionImage:imgAvatar];
    NSData *dataThumbnail = UIImageJPEGRepresentation(imgThumb, 1);
    
    int codeAvatar = [helperIns uploadAvatarAmazon:self.amazonAvatar withImage:dataAvatar];
    int codeThumbnail = [helperIns uploadAvatarAmazon:self.amazonThumbnail withImage:dataThumbnail];

    NSString *cmd = [NSString stringWithFormat:@"RESULTUPLOADAVATAR{%i}%i<EOF>", codeAvatar, codeThumbnail];
    [netIns sendResultUploadAvatar:cmd];
}

- (void) btnLoginClick:(id)sender{
    [self.vVerify setHidden:YES];
    [self next];
    [self.vLoginPage setHidden:NO];
    [self.vLogin setHidden:NO];
    [self.view bringSubviewToFront:self.vLoginPage];
}

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{

    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (cPage == 1 && !self.vLoginPage.isHidden) {
            [self.vLogin setFrame:CGRectMake(self.vLogin.frame.origin.x, self.vLogin.frame.origin.y - kbSize.height, self.vLogin.bounds.size.width, self.vLogin.bounds.size.height)];
        }
        
        if (cPage == 1 && self.vLoginPage.isHidden) {
            [self.vVerify setFrame:CGRectMake(self.vVerify.frame.origin.x, self.vVerify.frame.origin.y - kbSize.height, self.vVerify.bounds.size.width, self.vVerify.bounds.size.height)];
        }
        
        if (cPage == 2) {
            [self.txtEmail setFrame:CGRectMake(self.txtEmail.frame.origin.x, self.txtEmail.frame.origin.y - kbSize.height, self.view.bounds.size.width - 40, self.txtEmail.bounds.size.height)];
        }

        if (cPage == 3) {
            [self.vPasswordField setFrame:CGRectMake(self.vPasswordField.frame.origin.x, self.vPasswordField.frame.origin.y - kbSize.height, self.vPasswordField.bounds.size.width, self.vPasswordField.bounds.size.height)];
        }
        
        if (cPage == 4) {
            
            [self.vFullName setFrame:CGRectMake(self.vFullName.frame.origin.x, self.vFullName.frame.origin.y - (kbSize.height), self.vFullName.bounds.size.width, self.vFullName.bounds.size.height)];
        }
    }];
    
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect frameSendView = self.txtEmail.frame;
    frameSendView.origin.y += kbSize.height;
    
}

- (void) btnShowHiddenGridTap:(id)sender{
    
    [self.vGridLine setHidden:!self.vGridLine.isHidden];
    
}

- (void) btnShowLibrary:(id)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
//    SCPhotoLibraryViewController *post = [[SCPhotoLibraryViewController alloc] init];
//    [post.view setFrame:self.view.bounds];
//    UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:post];
//    [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
//    [naviController setDelegate:self];
//    
//    [self presentViewController:naviController animated:YES completion:^{
//        
//    }];
}


// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
//    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.vPreviewPhoto setImageCycle:image];
        [self next];
    }];
}

- (void) btnSwitchCamera:(id)sender{
    if (inSwitchCamera) {
        return;
    }
    
    inSwitchCamera = YES;
    [self.cameraCapture switchCamera:YES];
    inSwitchCamera = NO;
}

- (void) btnChangeFlash:(id)sender{
    if (inChangeFlash) {
        return;
    }
    
    inChangeFlash = YES;
    statusFlash += 1;
    if (statusFlash > 2) {
        statusFlash = 0;
    }
    
    switch (statusFlash) {
        case 0:{
            UIImage *imgFlashOff = [helperIns getImageFromSVGName:@"icon-camera-flash-off-25px.svg"];
            [self.btnFlash setImage:imgFlashOff forState:UIControlStateNormal];
            [self.cameraCapture enableFlash:AVCaptureFlashModeOff];
        }
            break;
            
        case 1:{
            UIImage *imgFlashOn = [helperIns getImageFromSVGName:@"icon-camera-flash-on-25px.svg"];
            [self.btnFlash setImage:imgFlashOn forState:UIControlStateNormal];
            [self.cameraCapture enableFlash:AVCaptureFlashModeOn];
        }
            break;
            
        case 2:{
            UIImage *imgFlashAuto = [helperIns getImageFromSVGName:@"icon-camera-flash-auto-25px.svg"];
            [self.btnFlash setImage:imgFlashAuto forState:UIControlStateNormal];
            [self.cameraCapture enableFlash:AVCaptureFlashModeAuto];
        }
            break;
            
        default:
            break;
    }
    
    inChangeFlash = NO;
}

- (void) btnTakePhotoTapRegister:(id)sender{
    [self.cameraCapture captureImage:nil];
}

- (void) showHiddenProgress:(BOOL)_isShow{
    [self.vProgressBlur setHidden:!_isShow];
}

- (void) nsCompleteCapture{
    UIImage *img = [self.cameraCapture getImageCapture];

    UIImage *_newImage = [helperIns imageByScalingAndCroppingForSize:img withSize:CGSizeMake(self.view.bounds.size.width * [[UIScreen mainScreen] scale], self.view.bounds.size.width * [[UIScreen mainScreen] scale])];
    
    [self.cameraCapture closeImage];
    
    [self.vPreviewPhoto setImageCycle:_newImage];
    
    [self next];
}

- (void) showPasswordClick:(id)sender{
    if (cPage == 3) {
        BOOL isShowPassword = self.txtPassword.secureTextEntry;
        if (!isShowPassword) {
            [self.btnShowPassword setAlpha:0.3];
        }else{
            [self.btnShowPassword setAlpha:1.0f];
        }

        self.txtPassword.secureTextEntry = !self.txtPassword.secureTextEntry;
    }

}

- (void) showPasswordSiginClick:(id)sender{
    if (cPage == 1 && !self.vLoginPage.isHidden) {
        BOOL isShowPassword = self.txtPasswordSignIn.secureTextEntry;
        if (!isShowPassword) {
            [self.btnShowPasswordSignIn setAlpha:0.3];
        }else{
            [self.btnShowPasswordSignIn setAlpha:1.0f];
        }
        
        self.txtPasswordSignIn.secureTextEntry = !self.txtPasswordSignIn.secureTextEntry;
    }
    
}

- (void) centerVerticalWithPading:(float)padding withButton:(UIButton*)_btn{
    CGSize imageSize = _btn.imageView.frame.size;
    CGSize titleSize = _btn.titleLabel.frame.size;
    
    _btn.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + padding),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);
    
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - (imageSize.width),
                                            - (imageSize.height + padding),
                                            0.0f);
}

- (UIImage *)imageFromView:(UIImage *)_img withRect:(CGRect)_rect{
    CGImageRef cr = CGImageCreateWithImageInRect(_img.CGImage, _rect);
    UIImage *cropped = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    return cropped;
}

- (void) setResult:(NSString *)_strResult{
    NSString *result = [_strResult stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
    NSArray *subData = [result componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        if ([[subData objectAtIndex:0] isEqualToString:@"REG"]) {
            if ([[subData objectAtIndex:1] isEqualToString:@"0"]) {
                //send veriify code - default 9990
                [netIns sendAuthCode:[NSString stringWithFormat:@"AUTHCODE{%@<EOF>", @"9999"]];
                [self next];
            }
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"AUTHCODE"]) {
            [netIns getUploadAvatar:@"GETUPLOADAVATARURL{<EOF>"];
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"GETUPLOADAVATARURL"]) {
            //map amazon info
            NSArray *subParameter = [[subData objectAtIndex:1] componentsSeparatedByString:@"$"];
            if ([subParameter count] == 2) {
                self.amazonThumbnail = [self->dataMapIns mapAmazonUploadAvatar:[subParameter objectAtIndex:0]];
                self.amazonAvatar = [self->dataMapIns mapAmazonUploadAvatar:[subParameter objectAtIndex:1]];
            }
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"RESULTUPLOADAVATAR"]) {
            //progress upload avatar
            NSArray *subParameter = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subParameter count] == 2) {
                int resultAvatar = [[subParameter objectAtIndex:0] intValue];
                int resultThumbnail = [[subParameter objectAtIndex:1] intValue];
                
                if (resultAvatar == 0 && resultThumbnail == 0) {
                    //call function register user
                    NewUser *_newUser = [[NewUser alloc] init];
                    _newUser.nickName = [NSString stringWithFormat:@"%@ %@", self.txtFirstName.text, self.txtLastName.text];
//                    NSString *strBirthDate = self.loginPage.joinNowView.txtBirthDayJoin.text;
//                    NSArray *subBirthDate = [strBirthDate componentsSeparatedByString:@"/"];
                    _newUser.birthDay = @"20"/*[subBirthDate objectAtIndex:0]*/;
                    _newUser.birthMonth = @"04"/*[subBirthDate objectAtIndex:1]*/;
                    _newUser.birthYear = @"1984" /*[subBirthDate objectAtIndex:2]*/;
                    _newUser.gender = @"Male" /*[self.loginPage.joinNowView.btnGender getGender]*/;
                    _newUser.avatarKey = self.amazonThumbnail.key;
                    _newUser.avatarFullKey = self.amazonAvatar.key;
                    _newUser.password = self.txtPassword.text;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_newUser.password forKey:@"password"];
                    
                    NSData *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                    NSString *_deviceToken = [NSString stringWithFormat:@"%@", token];
                    _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
                    _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
                    _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
                    
                    _newUser.deviceToken = _deviceToken;
                    _newUser.longitude = [self->storeIns getLongitude];
                    _newUser.latitude = [self->storeIns getlatitude];
                    _newUser.userName = self.txtEmail.text;
                    _newUser.firstName = self.txtFirstName.text;
                    _newUser.lastName = self.txtLastName.text;
                    _newUser.leftAvatar = @"0";
                    _newUser.topAvatar = @"0";
                    _newUser.widthAvatar = @"0";
                    _newUser.heightAvatar = @"0";
                    _newUser.scaleAvatar = @"1";
//                    _newUser.contacts = contactList;
                    
                    NSString *cmd = [self->dataMapIns cmdNewUser:_newUser];
                
                    [netIns createNewUser:cmd];
                }else{
                    //alert wrong avatar
                }
            }
            
            if ([[subData objectAtIndex:0] isEqualToString:@"NEWUSER"]) {
                //check complete create new user
                NSLog(@"new user complate");
            }
            
        }
    }
}

- (void) resetFormLogin{
    cPage = -1;
    [self next];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.vLogin setFrame:CGRectMake(0, self.vLoginPage.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) resetForm{
    
    [self.view endEditing:YES];
    
    cPage = -1;
    [self next];
    
    [self.vVerify setFrame:CGRectMake(self.view.bounds.size.width * 1, self.vParentPage.bounds.size.height - (hDisplayPhone + hButton + 10), self.view.bounds.size.width, hDisplayPhone + hButton + 10)];
    
    [self.txtEmail setFrame:CGRectMake(20, self.vEmail.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];

    [self.vPasswordField setFrame:CGRectMake(20, self.vPassword.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];

    [self.vFullName setFrame:CGRectMake(0, self.vName.bounds.size.height - ((hButton * 2) + 10), self.view.bounds.size.width, (hButton * 2) + 10)];

    [self.txtEmail setFrame:CGRectMake(20, self.vEmail.bounds.size.height - hButton, self.view.bounds.size.width - 40, hButton)];
    
}
@end
