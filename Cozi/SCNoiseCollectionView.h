//
//  SCNoiseCollectionView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNoiseCollectionViewCell.h"
#import "Helper.h"
#import "Store.h"
#import "DataWall.h"
#import "SDWebImage/UIImageView+WebCache.h"

static NSString * const NoiseCellIdentifier = @"PhotoCell";
@interface SCNoiseCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>
{
    Store                       *storeIns;
    Helper                      *helperIns;
    UIRefreshControl            *refresh;
    NSMutableArray              *items;
    int                         type;
    BOOL                        isEndData;
}

- (void) initData:(NSMutableArray*)_data withType:(int)_type;
- (void) stopLoadNoise:(BOOL)_isEnd;
@end
