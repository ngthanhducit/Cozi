//
//  SignInPageView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SignInPageView.h"

@implementation SignInPageView

@synthesize btnSignInView;
@synthesize viewInSignView;
@synthesize userNameView;
@synthesize passwordView;
@synthesize helperIns;
@synthesize txtUserName;
@synthesize txtPassword;


- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVariable];
        
        [self setup];
    }
    
    return self;
}

- (void) setupVariable{
    self.helperIns = [Helper shareInstance];
    
    sizeScreen = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) setup{
    
    sizeScreen = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    
    TriangleView *triangleSignIn = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
    [triangleSignIn setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1]];
    [triangleSignIn drawTriangleSignIn];
    UIImage *imgSignIn = [self.helperIns imageWithView:triangleSignIn];
    
    self.btnSignInView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSignInView setFrame:CGRectMake(0, (sizeScreen.height) - (sizeScreen.height / 4), sizeScreen.width, sizeScreen.height / 4)];
    [self.btnSignInView setTitle:@"SIGN IN" forState:UIControlStateNormal];
    [self.btnSignInView setImage:imgSignIn forState:UIControlStateNormal];
    
    CGSize sizeTitleLable = [self.btnSignInView.titleLabel.text sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:sizeScreen lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.btnSignInView.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnSignInView setContentMode:UIViewContentModeCenter];
    
    [self.btnSignInView setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgSignIn.size.width, 0, imgSignIn.size.width)];
    self.btnSignInView.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgSignIn.size.width, 0, -((sizeTitleLable.width) + imgSignIn.size.width));
    
    [self.btnSignInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSignInView.titleLabel setFont:[self.helperIns getFontThin:15.0f]];
    UIColor *colorSignInNormal = [self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"BlueColor1"]];
    UIColor *colorSignInHighLight = [self.helperIns colorFromRGBWithAlpha:[self.helperIns getHexIntColorWithKey:@"BlueColor1"] withAlpha:0.8f];
    [self.btnSignInView setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [self.btnSignInView setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [self addSubview:self.btnSignInView];
    
    self.viewInSignView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeScreen.width, sizeScreen.height - (sizeScreen.height / 4))];
    [self.viewInSignView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:viewInSignView];
    
    self.userNameView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height / 7, self.bounds.size.width, self.bounds.size.height / 5)];
    [self.userNameView setBackgroundColor:[UIColor whiteColor]];
    [self.viewInSignView addSubview:userNameView];
    
    UIImage *imgUserName = [self.helperIns getImageFromSVGName:@"form-icon-username.svg"];
    
    CGSize sizeRoundUserName = { (self.userNameView.bounds.size.height / 3), (self.userNameView.bounds.size.height / 3) };
    UIImageView *viewRoundUserName = [[UIImageView alloc] initWithFrame:CGRectMake(sizeRoundUserName.width / 2, sizeRoundUserName.height / 4, sizeRoundUserName.width, sizeRoundUserName.height)];
    viewRoundUserName.layer.cornerRadius = viewRoundUserName.bounds.size.height / 2;
    [viewRoundUserName setBackgroundColor:[self.helperIns colorWithHex:0x00cdd2]];
    [viewRoundUserName setImage:imgUserName];
    [self.userNameView addSubview:viewRoundUserName];
    
    CGRect userNamePos = CGRectMake(viewRoundUserName.bounds.origin.x + viewRoundUserName.bounds.size.width + 30, -0.5, sizeScreen.width / 4, self.userNameView.bounds.size.height / 2);
    UILabel *lblUserName = [[UILabel alloc] initWithFrame:userNamePos];
    [lblUserName setText:@"USERNAME"];
    [lblUserName setTextAlignment:NSTextAlignmentLeft];
    [lblUserName setTextColor:[UIColor grayColor]];
    [lblUserName setFont:[self.helperIns getFontThin:15]];
    [self.userNameView addSubview:lblUserName];
    
    CGFloat marginLeft = userNamePos.origin.x + userNamePos.size.width;
    self.txtUserName = [[SCTextField alloc] initWithdata:0.0f withPaddingRight:10.0f withIcon:nil withFont:[self.helperIns getFontThin:12.0f] withTextColor:nil withFrame:CGRectMake(marginLeft + 10, 0, (sizeScreen.width - (userNamePos.size.width + userNamePos.origin.x)), self.userNameView.bounds.size.height / 2)];
    [self.txtUserName setPlaceholder:@"PLEASE ENTER USERNAME"];
    [self.txtUserName setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtUserName setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtUserName setText:@"duc@sycomore.vn"];
    [self.userNameView addSubview:self.txtUserName];
    
    CALayer *bottomUserName = [CALayer layer];
    [bottomUserName setFrame:CGRectMake(0.0f, self.userNameView.bounds.size.height / 2, sizeScreen.width, 0.5f)];
    [bottomUserName setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.userNameView.layer addSublayer:bottomUserName];
    
    //form-icon-password
    UIImage *imgPassword = [SVGKImage imageNamed:@"form-icon-password.svg"].UIImage;
    
    CGSize sizeRoundPassword = { (self.userNameView.bounds.size.height / 3), (self.userNameView.bounds.size.height / 3)};
    UIImageView *viewRoundPassword = [[UIImageView alloc] initWithFrame:CGRectMake(sizeRoundPassword.width / 2, (self.userNameView.bounds.size.height / 2) + (sizeRoundPassword.height / 4), sizeRoundPassword.width, sizeRoundPassword.height)];
    viewRoundPassword.layer.cornerRadius = viewRoundPassword.bounds.size.width / 2;
    [viewRoundPassword setImage:imgPassword];
    [viewRoundPassword setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"OrangeColor"]]];
    
    [self.userNameView addSubview:viewRoundPassword];
    
    CGRect lblPasswordPos = CGRectMake(viewRoundUserName.bounds.origin.x + viewRoundUserName.bounds.size.width + 30, self.userNameView.bounds.size.height / 2, sizeScreen.width / 4, self.userNameView.bounds.size.height / 2);
    UILabel *lblPassword = [[UILabel alloc] initWithFrame:lblPasswordPos];
    [lblPassword setText:@"PASSWORD"];
    [lblPassword setFont:[self.helperIns getFontThin:15]];
    [lblPassword setTextColor:[UIColor grayColor]];
    [self.userNameView addSubview:lblPassword];
    
    self.txtPassword = [[SCTextField alloc] initWithdata:0.0f withPaddingRight:10.0f withIcon:nil withFont:[self.helperIns getFontThin:12.0f] withTextColor:nil withFrame:CGRectMake(marginLeft + 10, (self.userNameView.bounds.size.height / 2), (sizeScreen.width - (userNamePos.size.width + userNamePos.origin.x)), self.userNameView.bounds.size.height / 2)];
    [self.txtPassword setPlaceholder:@"PLEASE ENTER PASSWORD"];
    [self.txtPassword setSecureTextEntry:YES];
    [self.txtPassword setDelegate:self];
    [self.txtPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtPassword setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtPassword setText:@"abc123"];
    [self.userNameView addSubview:self.txtPassword];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    return YES;
}

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"heigth keyboard: %f", kbSize.height);
//    CGRect frame = self.signInScroll.frame;
    
//    CGFloat posI = frame.size.height -= kbSize.height;
    
//    if (posI > 0) {
//        frame.size.height = posI;
//        
//        [UIView animateWithDuration:0.1 animations:^{
//            [self.signInScroll setFrame:frame];
//        }];
//    }
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"Will be hidden: %f", kbSize.height);
    
    [UIView animateWithDuration:0.0 animations:^{
//        [self.signInScroll setFrame:CGRectMake(0, 0, sizeScreen.width, sizeScreen.height)];
    }];
}

@end
