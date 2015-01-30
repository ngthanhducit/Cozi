//
//  SCMessageImageView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/19/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "UIImage+ImageEffects.h"

@interface SCMessageImageView : UIView
{
    Helper              *helperIns;
    void (^successCallback)(BOOL    isComplete);
}

@property (nonatomic, strong) UIImage           *img;
@property (nonatomic, retain) UIImageView                 *imgView;

- (void)drawLeft:(CGRect)rect;
- (void)drawRight:(CGRect)rect;
//- (void) setImage:(UIImage*)_imgMessenger withBlur:(BOOL)_isBlur successBlock:(void(^)(BOOL isComplete))success;
//- (void) setImage:(UIImage*)_imgMessenger;
- (void) removeImage;
- (void) addBlurView;
- (UIImage*)getBlurImage;
- (void) setDefault;
@end
