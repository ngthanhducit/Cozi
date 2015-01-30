//
//  SCCommentTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/29/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "PostComment.h"
#import "SCCommentTableViewCell.h"
#import "Store.h"
#import "TTTAttributedLabel.h"
#import "DataWall.h"

@interface SCCommentTableView : UITableView <UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate>
{
    DataWall                    *_wallData;
    Helper                      *helperIns;
    Store                       *storeIns;
    CGSize                      sizeText;
    int                         maxRow;
}

@property (nonatomic, strong) DataWall        *wallData;

- (void) setData:(DataWall*)_data;
@end
