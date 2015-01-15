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
}

@property (nonatomic, strong) UILabel               *lblTime;

- (void) initWithData:(DataWall*)_data withSection:(NSInteger)section;
@end
