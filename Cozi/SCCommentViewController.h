//
//  SCCommentViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/29/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCCommentTableView.h"
#import "HPGrowingTextView.h"
#import "DataWall.h"
#import "PNetworkCommunication.h"
#import "NetworkController.h"
#import "SCPostParentViewController.h"

@interface SCCommentViewController : SCPostParentViewController <HPGrowingTextViewDelegate, PNetworkCommunication>
{
    DataWall                *wallItems;
//    CGFloat                 hHeader;
    CGFloat                 hViewAddComment;
//    Helper                  *helperIns;
//    Store                   *storeIns;
    int                     typeDisplay;
    NetworkController       *netControllerIns;
}

//@property (nonatomic, strong) UILabel           *lblTitle;
//@property (nonatomic, strong) UIButton          *btnClose;
//@property (nonatomic, strong) UIView            *vHeader;
@property (nonatomic, strong) SCCommentTableView    *tbComment;

@property (nonatomic, strong) UIView                *vAddComment;
@property (nonatomic, strong) HPGrowingTextView     *txtComment;
@property (nonatomic, strong) UIButton              *btnSend;

- (void) setData:(DataWall*)data withType:(int)_typeDisplay;
@end
