//
//  SCWallTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/24/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "DataWall.h"
#import "Helper.h"
#import "SCWallTableViewCell.h"
#import "Friend.h"

@interface SCWallTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
{
    Store               *storeIns;
    Helper              *helperIns;
}
@end
