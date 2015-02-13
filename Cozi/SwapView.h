//
//  SwapView.h
//  VPix
//
//  Created by khoa ngo on 11/11/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKImage.h"

@interface SwapView : UIView
{
    int _headerH;
    CGSize _sizeLogo;
//    UIView* _headPanel;
}
@property (nonatomic, strong) UIView                *_headPanel;
@property (nonatomic, strong) UIView                *_backView;
@property (nonatomic, strong) UIImageView                *imgLogoView;
@property (nonatomic, strong) UILabel               *lblNickName;

-(int) getHeaderHeight;
- (void) initBackView;
-(int) getContentHeight;
- (CGSize) getSizeLogo;
@end
