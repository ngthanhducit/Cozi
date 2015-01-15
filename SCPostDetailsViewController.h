//
//  SCPostDetailsViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/7/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cozi/Helper.h"
#import "Cozi/SCPhotoDetailsView.h"
#import "TriangleView.h"
#import "HPGrowingTextView.h"
#import "Cozi/SCActivityIndicatorView.h"
#import "AmazonInfoPost.h"
#import "AmazonInfo.h"
#import "Cozi/Store.h"
#import "NetworkController.h"

@interface SCPostDetailsViewController : UIViewController <HPGrowingTextViewDelegate>
{
    CGFloat             hHeader;
    Helper              *helperIns;
    Store               *storeIns;
    NetworkController *networkControllerIns;
    UIImageView         *imgQuotes;
    UIImageView         *imgSelectFB;
    BOOL                isSelectFB;
    AmazonInfoPost                  *amazonInfomation;
    NSInteger                   _clientKeyID;
    SCActivityIndicatorView         *vLoading;
}

@property (nonatomic, strong) UIView            *vHeader;
@property (nonatomic, strong) UIButton          *btnClose;

@property (nonatomic, strong) UIImageView       *imgPost;

@property (nonatomic, strong) SCPhotoDetailsView        *vCaption;

@property (nonatomic, strong) UIView                    *vAddFacebook;
@property (nonatomic, strong) HPGrowingTextView         *txtCaption;
@property (nonatomic, strong) UIButton                  *btnPostPhoto;

- (void) setImagePost:(UIImage*)_imagePost;
//- (void) setAmazoneUpload:(AmazonInfo*)_amazon;
//- (void) setResultUpload:(int)_result;
//- (void) setResultAddWall:(NSString*)_strResult;

@end
