//
//  SCActivityIndicatorView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/8/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface SCActivityIndicatorView : UIView
{
    Helper                          *helperIns;
    UIActivityIndicatorView         *activityView;
    UIView                          *vLoading;
    UILabel                         *lblLoading;
}

@property (nonatomic, strong) UIActivityIndicatorView           *activityView;
@property (nonatomic, strong) UIView                            *vLoading;
@property (nonatomic, strong) UILabel                           *lblLoading;
@end
