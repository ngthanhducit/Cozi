//
//  SCUIButton.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/13/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCUIButton.h"

@implementation SCUIButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    SCUIButton *button = [super buttonWithType:buttonType];
    [button postButtonWithTypeInit];
    
    return button;
}

- (void)postButtonWithTypeInit {
    
    Helper *helperIns = [Helper shareInstance];
    
    UIImage *imgHighlight = [helperIns imageWithColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] size:CGSizeMake(100, self.bounds.size.height - 10)];
    
    [self setBackgroundImage:imgHighlight forState:UIControlStateHighlighted | UIControlStateSelected];
    [self setClipsToBounds:YES];
    self.layer.cornerRadius = 3.0f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self setTitle:@"ADD" forState:UIControlStateNormal];
    [self.titleLabel setFont:[helperIns getFontLight:15.0f]];
}

- (void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
}

@end
