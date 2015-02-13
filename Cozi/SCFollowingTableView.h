//
//  SCFollowingTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/31/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "Helper.h"
#import "SCFollowingTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SCFollowingTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
{
    Helper                      *helperIns;
    Store                       *storeIns;
    CGSize                      sizeText;
    
    NSMutableArray                  *items;
}

- (void) setData:(NSMutableArray*)_dataItems;
@end
