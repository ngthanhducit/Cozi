//
//  SCPhotoCollectionView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCPhotoCollectionViewCell.h"
#import "SCPhotoCollectionViewLayout.h"

static NSString * const PostPhotoCellIdentifier = @"PhotoCell";

@interface SCPhotoCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>
{
    Store                       *storeIns;
    Helper                      *helperIns;
    UIRefreshControl            *refresh;
    NSMutableArray              *assets;
    int                         lastSelect;
}
@end
