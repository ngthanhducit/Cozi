//
//  SCGroupChatTableView.h
//  Cozi
//
//  Created by ChjpCoj on 3/4/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCGroupChatTableViewCell.h"
#import "Friend.h"

@interface SCGroupChatTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    Helper                      *helperIns;
    Store                       *storeIns;
    CGSize                      sizeText;
    NSMutableArray              *listFriends;
}

- (void) initItems:(NSMutableArray*)_itemsData;
@end
