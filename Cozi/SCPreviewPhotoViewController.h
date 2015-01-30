//
//  SCPreviewPhotoViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "Helper.h"
#import "SCGridView.h"
#import "SCPhotoPreview.h"
#import "TriangleView.h"
#import "SCPostDetailsViewController.h"
#import "SCPostParentViewController.h"

@interface SCPreviewPhotoViewController : UIViewController
{
    CGFloat                 hHeader;
    Helper                  *helperIns;
    Store                   *storeIns;
    UIImage                 *imgSelect;
}

@property (nonatomic, strong) UIButton       *btnSelect;
@property (nonatomic, strong) SCGridView     *vGridLine;
@property (nonatomic, strong) SCPhotoPreview *vPreviewPhoto;
@property (nonatomic, strong) UIButton       *btnClose;
@property (nonatomic, strong) UIView         *vHeader;
@property (nonatomic, strong) UIView         *vTool;

- (void) setImagePreview:(UIImage*)_imagePreview;
@end
