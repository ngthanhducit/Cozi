//
//  EnterPhone.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/29/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "EnterPhone.h"

@implementation EnterPhone

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
    
    self.viewEnterPhone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.viewEnterPhone setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
//    [self.viewEnterPhone setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.viewEnterPhone];
    
    UILabel *lblEnterPhone = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, (self.bounds.size.width / 3) + 10, 40)];
    [lblEnterPhone setText:@"ENTER PHONE"];
    [lblEnterPhone setBackgroundColor:[UIColor whiteColor]];
    [lblEnterPhone setTextAlignment:NSTextAlignmentCenter];
    [lblEnterPhone setFont:[helperIns getFontThin:15.0f]];
    [self.viewEnterPhone addSubview:lblEnterPhone];
    
    self.txtEnterPhone = [[SCTextField alloc] initWithdata:10 withPaddingRight:10 withIcon:nil withFont:[helperIns getFontThin:14] withTextColor:nil withFrame:CGRectMake((self.bounds.size.width / 3) + 10,50, self.bounds.size.width - (self.bounds.size.width / 3) - 10, 40)];
    [self.txtEnterPhone setPlaceholder:@"ENTER PHONE NUMBER"];
    [self.txtEnterPhone setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtEnterPhone setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtEnterPhone setKeyboardType:UIKeyboardTypeNumberPad];
    [self.txtEnterPhone setBackgroundColor:[UIColor whiteColor]];
    [self.viewEnterPhone addSubview:self.txtEnterPhone];
    
//    CALayer *bottomPhoneNumber = [CALayer layer];
//    [bottomPhoneNumber setFrame:CGRectMake(0.0f, 91, sizeScreen.width, 0.5f)];
//    [bottomPhoneNumber setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
//    [self.viewEnterPhone.layer addSublayer:bottomPhoneNumber];
    
    TriangleView *triangleSignIn = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
    [triangleSignIn setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1]];
    [triangleSignIn drawTriangleSignIn];
    UIImage *imgSignIn = [helperIns imageWithView:triangleSignIn];
    
    self.btnSendPhoneNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSendPhoneNumber setFrame:CGRectMake(0, self.bounds.size.height - 100, sizeScreen.width, 100)];
    [self.btnSendPhoneNumber setTitle:@"SEND PHONE" forState:UIControlStateNormal];
    [self.btnSendPhoneNumber setImage:imgSignIn forState:UIControlStateNormal];
    
    CGSize sizeTitleLable = [self.btnSendPhoneNumber.titleLabel.text sizeWithFont:[helperIns getFontThin:15.0f] constrainedToSize:sizeScreen lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.btnSendPhoneNumber.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnSendPhoneNumber setContentMode:UIViewContentModeCenter];
    
    [self.btnSendPhoneNumber setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgSignIn.size.width, 0, imgSignIn.size.width)];
    self.btnSendPhoneNumber.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgSignIn.size.width, 0, -((sizeTitleLable.width) + imgSignIn.size.width));
    
    [self.btnSendPhoneNumber setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSendPhoneNumber.titleLabel setFont:[helperIns getFontThin:15.0f]];
    UIColor *colorSignInNormal = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"BlueColor1"]];
    UIColor *colorSignInHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"BlueColor1"] withAlpha:0.8f];
    [self.btnSendPhoneNumber setBackgroundImage:[helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [self.btnSendPhoneNumber setBackgroundImage:[helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted];
    
    [self addSubview:self.btnSendPhoneNumber];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.txtEnterPhone resignFirstResponder];
}

//- (BOOL) textFieldShouldReturn:(UITextField *)textField{
//    [self.txtEnterPhone resignFirstResponder];
//    
//    return YES;
//}
@end

