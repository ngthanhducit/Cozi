//
//  SCSearchFriendViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/11/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPostParentViewController.h"
#import "SCSearchBar.h"
#import "SCSearchFriendTableView.h"
#import "PNetworkCommunication.h"
#import "NetworkController.h"
#import "UserSearch.h"

@interface SCSearchFriendViewController : SCPostParentViewController <UISearchBarDelegate, PNetworkCommunication>
{
    UIView                  *vBlur;
    SCSearchBar           *scSearchFriend;
    SCSearchFriendTableView *tbSearchFriend;
    
    NetworkController           *netIns;
    
    NSMutableArray              *items;
    
    UserSearch                  *userSearch;
    
    UIActivityIndicatorView     *waiting;
}
@end
