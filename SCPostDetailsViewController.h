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
#import "SCPostParentViewController.h"
#import "SCWaitingView.h"
#import "PNetworkCommunication.h"
#import "DataMap.h"
#import "AmazonInfoPost.h"

@interface SCPostDetailsViewController : SCPostParentViewController <HPGrowingTextViewDelegate, PNetworkCommunication>
{
    NetworkController *networkControllerIns;
    UIImageView         *imgQuotes;
    UIImageView         *imgSelectFB;
    BOOL                isSelectFB;
    AmazonInfoPost                  *amazonInfomation;
    NSString                   *_clientKeyID;
    SCWaitingView         *vLoading;
    SCActivityIndicatorView         *waiting;
}

@property (nonatomic, strong) UIImageView        *imgPost;
@property (nonatomic, strong) SCPhotoDetailsView *vCaption;
@property (nonatomic, strong) UIView             *vAddFacebook;
@property (nonatomic, strong) HPGrowingTextView  *txtCaption;
@property (nonatomic, strong) UIButton           *btnPostPhoto;

- (void) setImagePost:(UIImage*)_imagePost;

@end
