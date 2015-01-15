//
//  SCPhotoPreview.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface SCPhotoPreview : UIView <UIScrollViewDelegate>
{
    CGPoint                       point;
    CGFloat             yPoint;
}

@property (nonatomic, strong) UIScrollView                  *scrollView;
@property (nonatomic, retain) UIImageView                   *imgViewCapture;

-(void)setImageCycle:(UIImage*)image;
@end
