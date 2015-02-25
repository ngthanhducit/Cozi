//
//  SCHeaderFooterView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/5/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataWall.h"
#import "Store.h"
#import "Helper.h"
#import "TTTAttributedLabel.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SCHeaderFooterView : UITableViewHeaderFooterView <TTTAttributedLabelDelegate>
{
    Store               *storeIns;
    Helper              *helperIns;
    UIImage             *imgClock;
}

@property (nonatomic, strong) UILabel               *lblTime;

- (void) initWithData:(DataWall*)_data withSection:(NSInteger)section;
@end
