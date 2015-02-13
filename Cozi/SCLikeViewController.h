//
//  SCLikeViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLikeTableView.h"
#import "NetworkController.h"
#import "PNetworkCommunication.h"
#import "SCPostParentViewController.h"

@interface SCLikeViewController : SCPostParentViewController <PNetworkCommunication>
{
    DataWall                *wallItems;
//    CGFloat                 hHeader;
//    Helper                  *helperIns;
//    Store                   *storeIns;
    NetworkController       *netControllerIns;
}

//@property (nonatomic, strong) UILabel           *lblTitle;
//@property (nonatomic, strong) UIButton          *btnBack;
//@property (nonatomic, strong) UIButton          *btnClose;
//@property (nonatomic, strong) UIView            *vHeader;
@property (nonatomic, strong) SCLikeTableView    *tbLike;

- (void) setData:(DataWall*)data;

@end
