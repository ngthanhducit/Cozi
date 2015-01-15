//
//  SCShareMenu.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/5/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriangleView.h"
#import "Helper.h"

@interface SCShareMenu : UIView
{
    Helper              *helperIns;
}

@property (nonatomic, strong) UIView                *vBlurShare;
@property (nonatomic, strong) UIView                *vMenuShare;

@property (nonatomic, strong) UIButton              *btnMood;
@property (nonatomic, strong) UIButton              *btnCamera;
@property (nonatomic, strong) UIButton              *btnPhoto;
@property (nonatomic, strong) UIButton              *btnLocation;
@end
