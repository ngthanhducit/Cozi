//
//  SCFollowersTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/31/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowerUser.h"    
#import "Helper.h"
#import "Store.h"
#import "SCFollowersTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SCFollowersTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    Helper                      *helperIns;
    Store                       *storeIns;
    CGSize                      sizeText;
    
    NSMutableArray                  *items;
}

- (void) setData:(NSMutableArray*)_dataItems;

@end
