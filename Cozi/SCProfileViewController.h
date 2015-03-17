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
#import "SCFollowersViewController.h"
#import "SCFollowingViewController.h"
#import "SCPostParentViewController.h"

@interface SCProfileViewController : SCPostParentViewController <PNetworkCommunication>
{
    MainPageV6              *mainPage;
    User                    *my;
    Friend                  *friend;
    NetworkController       *netIns;
}

- (void) setProfile:(User*)_myProfile;
@end
