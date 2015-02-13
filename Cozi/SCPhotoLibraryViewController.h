//
//  SCPhotoLibraryViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/3/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPhotoCollectionView.h"
#import "Store.h"
#import "Helper.h"

@interface SCPhotoLibraryViewController : UIViewController
{
    Store                   *storeIns;
    Helper                  *helperIns;
}

@property (nonatomic        ) UIEdgeInsets          itemInsets;
@property (nonatomic        ) CGSize                itemSize;
@property (nonatomic        ) CGFloat               interItemSpacingY;
@property (nonatomic        ) NSInteger             numberOfColumns;

@property (nonatomic, strong) UIView                *vLibrary;

@property (nonatomic, strong) SCPhotoCollectionView *scPhotoCollectionView;

@end
