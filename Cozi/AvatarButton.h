//
//  AvatarButton.h
//  VPix
//
//  Created by DO PHUONG TRINH on 11/12/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKImageView.h"
#import "SVGKLayeredImageView.h"

@interface AvatarButton : UIButton
@property (nonatomic, strong) UIButton                    *btnProfile;
@property (nonatomic, strong) UIImageView                *imgArrowView;

-(void) setImage:(UIImage*)img;
@end
