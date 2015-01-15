//
//  SCPostParentViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/13/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"

@interface SCPostParentViewController : UIViewController
{
    CGFloat                 hHeader;
    Helper                  *helperIns;
    Store                   *storeIns;
}

@property (nonatomic, strong) UILabel                   *lblTitle;
@property (nonatomic, strong) UIButton                  *btnClose;
@property (nonatomic, strong) UIView                    *vHeader;
@end
