//
//  ImageRender.h
//  VPix
//
//  Created by khoa ngo on 10/30/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageRender : NSObject
- (UIImage*)colorize:(UIImage *)input brightness:(CGFloat)brightness;
- (UIImage*)colorize:(UIImage *)input hue:(CGFloat)hueDegrees;
- (UIImage*)colorize:(UIImage *)input saturation:(CGFloat)saturation;
- (UIImage *)imageBlackAndWhite:(UIImage*)source;
- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame;
-(UIImage*) cutImageByRect:(UIImage*)input frame:(CGRect)frame;
-(UIImage*) makeHomeTopImage:(UIImage*)input frame:(CGRect)frame;
@end
