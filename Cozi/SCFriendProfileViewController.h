//
//  SCFriendProfileViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/16/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "MainPageV6.h"
#import "Friend.h"
#import "SCSinglePostViewController.h"
#import "NetworkController.h"
#import "PNetworkCommunication.h"
#import "Profile.h"
#import "DataMap.h"
#import "SCFollowersViewController.h"
#import "SCFollowingViewController.h"
#import "FollowerUser.h"
#import "SCPostParentViewController.h"

@interface SCFriendProfileViewController : SCPostParentViewController <PNetworkCommunication>
{
    MainPageV6              *mainPage;
//    Friend                  *friend;
    Profile                 *profile;
//    CGFloat                 hHeader;
//    Helper                  *helperIns;
//    Store                   *storeIns;
    DataMap                 *dataMapIns;
    NetworkController           *netIns;
    SCFollowersViewController *followers;
    SCFollowingViewController   *following;
    
    int                     friendID;
    BOOL                    inFollowing;
}

//@property (nonatomic, strong) UILabel                   *lblTitle;
//@property (nonatomic, strong) UIButton                  *btnClose;
//@property (nonatomic, strong) UIView                    *vHeader;

- (void) setFriendProfile:(Friend*)_friendProfile;
- (void) setFriendId:(int)_friendID;
@end
