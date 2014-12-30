//
//  AvatarButton.m
//  VPix
//
//  Created by DO PHUONG TRINH on 11/12/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "AvatarButton.h"

@implementation AvatarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0].CGColor);
    CGRect rectangle = CGRectMake(5,5,70,70);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);
    
    self.btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnProfile setFrame:CGRectMake(10, 10, 60.0f, 60.0f)];
    [self.btnProfile setBackgroundColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0]];
    self.btnProfile.layer.cornerRadius = self.btnProfile.bounds.size.width / 2;
    [self.btnProfile setClipsToBounds:YES];
    self.btnProfile.userInteractionEnabled = NO;
    self.btnProfile.exclusiveTouch = NO;
//    [self.btnProfile addTarget:self action:@selector(changeAvatarGesture) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnProfile];
    
    self.imgArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40.0f, 40.0f)];
    self.imgArrowView.image = [SVGKImage imageNamed:@"icon-cong.svg"].UIImage;
    [self.btnProfile addSubview:self.imgArrowView];
    [self setBackgroundColor:[UIColor whiteColor]];    
}
-(void) setImage:(UIImage*)img{
    [self.btnProfile setImage:img forState:UIControlStateNormal];
    [self.imgArrowView setHidden:YES];
}

@end
