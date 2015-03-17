//
//  SCGroupChatViewController.h
//  Cozi
//
//  Created by ChjpCoj on 3/4/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPostParentViewController.h"
#import "SCGroupChatTableView.h"
#import "SCTextField.h"
#import "TriangleView.h"
#import "SCActivityIndicatorView.h"
#import "PNetworkCommunication.h"
#import "NetworkController.h"
#import "Recent.h"

@interface SCGroupChatViewController : SCPostParentViewController <PNetworkCommunication, UITextFieldDelegate>
{
    UIColor             *borderColor;
    NetworkController   *netIns;
}

@property (nonatomic, strong) SCActivityIndicatorView       *waiting;
@property (nonatomic, strong) NSMutableArray         *items;
@property (nonatomic, strong) UIImageView           *imgAvatar;
@property (nonatomic, strong) SCTextField            *txtGroupName;
@property (nonatomic, strong) SCGroupChatTableView   *tbFriend;
@property (nonatomic, strong) UIButton               *btnCreateGroup;

- (void) initData:(NSMutableArray*)_itemsData;
@end
