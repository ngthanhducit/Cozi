//
//  EnterAuthCodeView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/29/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "EnterAuthCodeView.h"

@implementation EnterAuthCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{
    Helper *helperIns = [Helper shareInstance];
    
    CGSize sizeScreen = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    
    self.viewEnterCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.viewEnterCode setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    //    [self.viewEnterPhone setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.viewEnterCode];
    
    UILabel *lblEnterCode = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, (self.bounds.size.width / 3) + 10, 40)];
    [lblEnterCode setText:@"ENTER AUTH CODE"];
    [lblEnterCode setBackgroundColor:[UIColor whiteColor]];
    [lblEnterCode setTextAlignment:NSTextAlignmentCenter];
    [lblEnterCode setFont:[helperIns getFontThin:15.0f]];
    [self.viewEnterCode addSubview:lblEnterCode];
    
    self.txtEnterCode = [[SCTextField alloc] initWithdata:10 withPaddingRight:10 withIcon:nil withFont:[helperIns getFontThin:14] withTextColor:nil withFrame:CGRectMake((self.bounds.size.width / 3) + 10,50, self.bounds.size.width - (self.bounds.size.width / 3) - 10, 40)];
    [self.txtEnterCode setPlaceholder:@"ENTER AUTH CODE:"];
    [self.txtEnterCode setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtEnterCode setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtEnterCode setKeyboardType:UIKeyboardTypeNumberPad];
    [self.txtEnterCode setBackgroundColor:[UIColor whiteColor]];
    [self.viewEnterCode addSubview:self.txtEnterCode];
    
    TriangleView *triangleEnterCode = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
    [triangleEnterCode setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1]];
    [triangleEnterCode drawTriangleSignIn];
    UIImage *imgEnterCode = [helperIns imageWithView:triangleEnterCode];
    
    self.btnSendCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSendCode setFrame:CGRectMake(0, self.bounds.size.height - 200, sizeScreen.width, 100)];
    [self.btnSendCode setTitle:@"SEND CODE" forState:UIControlStateNormal];
    [self.btnSendCode setImage:imgEnterCode forState:UIControlStateNormal];
    
    CGSize sizeTitleLable = [self.btnSendCode.titleLabel.text sizeWithFont:[helperIns getFontThin:15.0f] constrainedToSize:sizeScreen lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.btnSendCode.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnSendCode setContentMode:UIViewContentModeCenter];
    
    [self.btnSendCode setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgEnterCode.size.width, 0, imgEnterCode.size.width)];
    self.btnSendCode.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgEnterCode.size.width, 0, -((sizeTitleLable.width) + imgEnterCode.size.width));
    
    [self.btnSendCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSendCode.titleLabel setFont:[helperIns getFontThin:15.0f]];
    UIColor *colorSignInNormal = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"BlueColor1"]];
    UIColor *colorSignInHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"BlueColor1"] withAlpha:0.8f];
    [self.btnSendCode setBackgroundImage:[helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [self.btnSendCode setBackgroundImage:[helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [self addSubview:self.btnSendCode];
    
    //Add Back Button
    TriangleView *triangleBack = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
    [triangleBack setBackgroundColor:[UIColor colorWithRed:117.0/255.0f green:117.0/255.0f blue:117.0/255.0f alpha:1]];
    [triangleBack drawTriangleSignIn];
    UIImage *imgBack = [helperIns imageWithView:triangleBack];
    
    self.btnSendCodeBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSendCodeBack setFrame:CGRectMake(0, self.bounds.size.height - 100, sizeScreen.width, 100)];
    [self.btnSendCodeBack setTitle:@"BACK" forState:UIControlStateNormal];
    [self.btnSendCodeBack setImage:imgBack forState:UIControlStateNormal];
    
    CGSize sizeTitleLableBack = [self.btnSendCodeBack.titleLabel.text sizeWithFont:[helperIns getFontThin:15.0f] constrainedToSize:sizeScreen lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.btnSendCodeBack.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnSendCodeBack setContentMode:UIViewContentModeCenter];
    
    [self.btnSendCodeBack setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgBack.size.width, 0, imgBack.size.width)];
    self.btnSendCodeBack.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLableBack.width) + imgBack.size.width, 0, -((sizeTitleLableBack.width) + imgBack.size.width));
    
    [self.btnSendCodeBack setTitleColor:[UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnSendCodeBack.titleLabel setFont:[helperIns getFontThin:15.0f]];
    UIColor *colorBackNormal = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"BlueColor"]];
    UIColor *colorBackHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"BlueColor"] withAlpha:0.8f];
    [self.btnSendCodeBack setBackgroundImage:[helperIns imageWithColor:colorBackNormal] forState:UIControlStateNormal];
    [self.btnSendCodeBack setBackgroundImage:[helperIns imageWithColor:colorBackHighLight] forState:UIControlStateHighlighted];
    
    [self addSubview:self.btnSendCodeBack];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.txtEnterCode resignFirstResponder];
}

@end
