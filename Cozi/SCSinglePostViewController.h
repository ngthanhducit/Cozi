//
//  SCSinglePostViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/16/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPostParentViewController.h"
#import "SCWallTableViewV2.h"

@interface SCSinglePostViewController : UIViewController
{
    NSMutableArray              *items;
    CGFloat                 hHeader;
    Helper                  *helperIns;
    Store                   *storeIns;
}

@property (nonatomic, strong) SCWallTableViewV2 *singleWall;
@property (nonatomic, strong) UILabel           *lblTitle;
@property (nonatomic, strong) UIButton          *btnClose;
@property (nonatomic, strong) UIView            *vHeader;

- (void) setData:(NSMutableArray*)data;
@end
