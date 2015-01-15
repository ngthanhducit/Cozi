//
//  SCNearTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/14/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNearTableViewCell.h"
#import "NearLocation.h"
#import "Helper.h"

@interface SCNearTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray              *_nearItems;
    Helper                      *helperIns;
    CGFloat                     hRow;
}

@property (nonatomic, strong) NSMutableArray                *nearItems;

@end
