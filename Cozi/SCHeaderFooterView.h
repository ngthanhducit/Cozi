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

@interface SCHeaderFooterView : UITableViewHeaderFooterView
{
    Store               *storeIns;
    Helper              *helperIns;
    UIImage             *imgClock;
}

@property (nonatomic, strong) UILabel               *lblTime;
//@property (nonatomic, retain) UIImageView           *imgAvatar;
//@property (nonatomic, retain) UILabel               *lblFullName;
//@property (nonatomic, retain) UILabel               *lblLocation;
//@property (nonatomic, retain) UIImageView           *imgLocation;
//@property (nonatomic, retain) UIImageView           *imgClock;

- (void) initUI;
- (void) initWithData:(DataWall*)_data withSection:(NSInteger)section;
@end
