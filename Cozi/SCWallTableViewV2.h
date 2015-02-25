//
//  SCWallTableViewV2.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/24/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCWallTableViewCellV2.h"
#import "TTTAttributedLabel.h"
#import "Friend.h"
#import "NetworkCommunication.h"
#import "PostComment.h"
#import "PostLike.h"
#import "SCHeaderFooterView.h"
#import "NetworkController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/SDImageCache.h"

@interface SCWallTableViewV2 : UITableView <UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
{
    Store               *storeIns;
    Helper              *helperIns;
    UIRefreshControl            *refreshControl;
    UIRefreshControl            *bottomRefreshControl;
    UIActivityIndicatorView         *spinner;
 
    CGFloat                 spacing;
    CGFloat                 bottomSpacing;
    CGFloat                 deltaWithStatus;
    CGFloat                 spacingViewAllComment;
    CGFloat                 spacingLineComment;
    BOOL                isMoreData;
    BOOL                isEnd;
    CGPoint         lastOffset;
    NetworkController           *networkControllerIns;
    
    int                     type;
    NSMutableArray          *items;
    BOOL                    isOnTick;
}

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (void) stopStartOnTick:(BOOL)_isTick;
- (void) stopLoadWall:(BOOL)_isEndData;
- (void) stopRefesh;
- (void) initWithData:(NSMutableArray*)_data withType:(int)_type;
@end
