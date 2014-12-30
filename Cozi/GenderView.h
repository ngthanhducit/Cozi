//
//  GenderView.h
//  VPix
//
//  Created by DO PHUONG TRINH on 11/11/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGImageElement.h"
#import "SVGKImageView.h"
#import "SVGKLayeredImageView.h"

@interface GenderView : UIView
@property (nonatomic, assign) int               numGender;
@property (nonatomic, strong) UIButton            *btnMale;
@property (nonatomic, strong) UIButton            *btnFemela;
@property (nonatomic, strong) UILabel            *lbFemela;
@property (nonatomic, strong) UILabel            *lbMale;
- (id) initWithFrame:(int)num withFrame:(CGRect)frame;
-(NSString*)getGender;
@end
