//
//  SCLikeTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCLikeTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DataWall.h"
#import "PostLike.h"

@interface SCLikeTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    DataWall                    *_wallData;
    Helper                      *helperIns;
    Store                       *storeIns;
    CGSize                      sizeText;
}

- (void) setData:(DataWall*)_wall;

@end
