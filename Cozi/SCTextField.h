//
//  SCTextField.h
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/29/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SCTextField : UITextField <UITextFieldDelegate>
{
    
}

@property (nonatomic, strong) UIImageView               *iconView;
@property (nonatomic) CGFloat                           paddingLeft;
@property (nonatomic) CGFloat                           paddingRight;
@property (nonatomic) CGRect                            frameView;
@property (nonatomic, strong) UIImage                           *icon;
@property (nonatomic, strong) UIFont                    *fontName;
@property (nonatomic, assign) UIEdgeInsets            edgeInserts;
@property (nonatomic, strong) UIColor                   *colorText;

- (id) initWithdata:(CGFloat)padding withPaddingRight:(CGFloat)_paddingRight withIcon:(UIImage*)_iconImage withFont:(UIFont*)_font withTextColor:(UIColor*)_colorText withFrame:(CGRect)frame;

- (id) initWithdata:(CGFloat)padding withPaddingRight:(CGFloat)_paddingRight withFrame:(CGRect)frame;
@end
