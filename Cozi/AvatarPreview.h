//
//  AvatarPreview.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/28/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartialTransparentView.h"
#import "Helper.h"

@interface AvatarPreview : UIView <UIScrollViewDelegate>
{
    CGPoint                       point;
    CGFloat             yPoint;
    UILabel             *lblFinish;
    UILabel             *lblCancel;
}

@property (nonatomic, strong) PartialTransparentView                        *patialTransparent;
@property (nonatomic, strong) UIView                        *circleView;
@property (nonatomic, strong) UIScrollView                  *scrollView;
@property (nonatomic, retain) UIImageView                   *imgViewCapture;

-(void)setImageCycle:(UIImageView*)image;
@end
