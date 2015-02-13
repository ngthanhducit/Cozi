//
//  SCFriendRequestTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/12/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SCFriendRequestTableViewCell.h"
#import "Helper.h"
#import "Store.h"

@interface SCFriendRequestTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    Helper                      *helperIns;
    Store                       *storeIns;
    NSMutableArray              *items;
}

- (void) initData:(NSMutableArray*)_itemsData;
@end
