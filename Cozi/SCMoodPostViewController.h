//
//  SCMoodPostViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/15/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPostParentViewController.h"
#import "HPGrowingTextView.h"
#import "TriangleView.h"
#import "NetworkController.h"

@interface SCMoodPostViewController : SCPostParentViewController <HPGrowingTextViewDelegate>
{
    UIImageView         *imgSelectFB;
    BOOL                isSelectFB;
    UIImageView         *imgQuotes;
    NSString                        *_clientKeyID;
    NetworkController       *networkControllerIns;
}

@property (nonatomic, strong) UIView            *vCaption;
@property (nonatomic, strong) UIView            *vAddFacebook;
@property (nonatomic, strong) UIView            *vButton;
@property (nonatomic, strong) HPGrowingTextView *txtCaption;
@property (nonatomic, strong) UIButton          *btnPostMood;
@end
