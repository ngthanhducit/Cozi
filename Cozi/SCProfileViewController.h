//
//  SCProfileViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/15/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPostParentViewController.h"
#import "MainPageV6.h"
#import "User.h"
#import "SCSinglePostViewController.h"
#import "Friend.h"
#import "NetworkController.h"
#import "PNetworkCommunication.h"

@interface SCProfileViewController : UIViewController <PNetworkCommunication>
{
    MainPageV6              *mainPage;
    User                    *my;
    Friend                  *friend;
    CGFloat                 hHeader;
    Helper                  *helperIns;
    Store                   *storeIns;
    NetworkController       *netIns;
}

@property (nonatomic, strong) UILabel                   *lblTitle;
@property (nonatomic, strong) UIButton                  *btnClose;
@property (nonatomic, strong) UIView                    *vHeader;

- (void) setProfile:(User*)_myProfile;
@end
