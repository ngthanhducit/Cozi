//
//  SCSearchFriendTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/11/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCSearchFriendTableViewCell.h"
#import "UserSearch.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SCSearchFriendTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary             *contacts;
    Helper                          *helperIns;
    Store                           *storeIns;
    
    NSMutableArray                  *contactList;
    NSMutableArray                  *contactIndex;
    
//    NSMutableArray              *selectList;
//    NSMutableArray              *selectCell;
}

- (void) initData:(NSMutableArray *)_searchFriend;
@end
