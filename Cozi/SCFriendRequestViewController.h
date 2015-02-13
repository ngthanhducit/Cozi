//
//  SCFriendRequestViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/12/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPostParentViewController.h"
#import "PNetworkCommunication.h"
#import "NetworkController.h"
#import "SCFriendRequestTableView.h"

@interface SCFriendRequestViewController : SCPostParentViewController <PNetworkCommunication>
{
    NetworkController           *netIns;
    SCFriendRequestTableView    *tbFriendRequest;
    
    UserSearch                  *friendRequest;
}
@end
