//
//  SCTextField.m
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/29/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "SCTextField.h"

@implementation SCTextField

@synthesize edgeInserts;
@synthesize iconView;
@synthesize paddingLeft;
@synthesize paddingRight;
@synthesize colorText;

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

    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *_tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"V-ICONS-logo"];
    [_tempView addSubview:imageView];
    
//    self.leftView = _tempView;
    
    return self;
}

- (id) initWithdata:(CGFloat)padding withPaddingRight:(CGFloat)_paddingRight withIcon:(UIImage*)_iconImage withFont:(UIFont*)_font withTextColor:(UIColor*)_colorText withFrame:(CGRect)frame{
    self.paddingLeft = padding;
    self.paddingRight = _paddingRight;
    self.frameView = frame;
    self.icon = _iconImage;
    self.fontName = _font;
    self.colorText = _colorText;
    self = [super init];
    if (self) {
        [self setFrame:frame];
        [self setup];
    }
    
    return self;
}

- (id) initWithdata:(CGFloat)padding withPaddingRight:(CGFloat)_paddingRight withFrame:(CGRect)frame{
    self.paddingLeft = padding;
    self.paddingRight = _paddingRight;
    self.frameView = frame;
    self.fontName = [UIFont fontWithName:@"FSJoey-Light" size:16];
    self = [super init];
    if (self) {
        [self setFrame:frame];
        [self setup];
    }
    
    return self;
}

- (void) setup{
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *_tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    imageView.image = self.icon;
    [_tempView addSubview:imageView];
    
    self.leftView = _tempView;
    
    [self setFont:self.fontName];
    [self setDelegate:self];
}

- (CGRect) placeholderRectForBounds:(CGRect)bounds{
    CGSize size = [self.placeholder sizeWithFont:self.fontName];
    CGFloat sizeTextField = self.bounds.size.height / 2;
    
    return CGRectMake(self.paddingLeft, sizeTextField - (size.height / 2), self.bounds.size.width, self.bounds.size.height);
}

- (void) drawPlaceholderInRect:(CGRect)rect{

    if (self.colorText != nil) {
        [self.colorText setFill];
    }else{
        [[UIColor colorWithRed:202/255.0f green:202/255.0f blue:202/255.0f alpha:1.0] setFill];
    }

    [[self placeholder] drawInRect:rect withFont:self.fontName];
}

- (CGRect) textRectForBounds:(CGRect)bounds{
    bounds.origin.x += self.paddingLeft;
    bounds.size.width -= self.paddingRight;
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    bounds.origin.x += self.paddingLeft;
    bounds.size.width -= self.paddingRight;
    return bounds;
}

@end
