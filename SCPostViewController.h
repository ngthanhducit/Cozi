//
//  SCPostViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/6/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraCaptureV6.h"
#import "Helper.h"
#import "SCCameraCaptureV7.h"
#import "SCPostDetailsViewController.h"
#import "TriangleView.h"
#import "SCGridView.h"
#import "SCPostParentViewController.h"

@interface SCPostViewController : SCPostParentViewController
{
//    Helper              *helperIns;
//    CGFloat             hHeader;
    CGFloat             hTool;
    CGFloat             yLineTool;
    int                 statusFlash; //0:off-1:on:2:auto
    BOOL                inSwitchCamera;
    BOOL                inChangeFlash;
}

//@property (nonatomic, strong) UIButton          *btnClose;
@property (nonatomic, strong) SCCameraCaptureV7 *cameraCapture;

@property (nonatomic, strong) SCGridView        *vGridLine;
@property (nonatomic, strong) UIButton          *btnGrid;
@property (nonatomic, strong) UIButton          *btnFlash;
@property (nonatomic, strong) UIButton          *btnSwithCamera;
@property (nonatomic, strong) UIButton          *btnTakePhoto;
//@property (nonatomic, strong) UIView            *vHeader;
@property (nonatomic, strong) UIView            *vTool;
@end
