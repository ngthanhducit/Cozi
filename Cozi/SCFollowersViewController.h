//
//  SCFollowersViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/31/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "Helper.h"
#import "NetworkController.h"
#import "SCFollowersTableView.h"
#import "PNetworkCommunication.h"
#import "SCPostParentViewController.h"

@interface SCFollowersViewController : SCPostParentViewController <PNetworkCommunication>
{
//    CGFloat                 hHeader;
//    Helper                  *helperIns;
//    Store                   *storeIns;
    NetworkController       *netIns;
    NSMutableArray          *items;
    int                     friendID;
    
    FollowerUser            *inFollowerUser;
    BOOL                    inFollowing;
}

@property (nonatomic, strong) UIActivityIndicatorView           *waiting;
@property (nonatomic, strong) SCFollowersTableView      *tbView;
//@property (nonatomic, strong) UILabel                   *lblTitle;
//@property (nonatomic, strong) UIButton                  *btnClose;
//@property (nonatomic, strong) UIView                    *vHeader;

- (void) setFriendID:(int)_friendID;
- (void) setData:(NSMutableArray*)_dataItems;
@end
