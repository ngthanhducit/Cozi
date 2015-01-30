//
//  SCPostPhotoViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/8/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cozi/Helper.h"
#import "Store.h"
#import "AvatarPreview.h"
#import "Cozi/SCPhotoCollectionView.h"
#import "Cozi/SCPhotoCollectionViewLayout.h"
#import "Cozi/SCPreviewPhotoViewController.h"
#import "SCPostParentViewController.h"

@interface SCPostPhotoViewController : SCPostParentViewController
{
    UIScrollView            *scrollImageLibrary;
}

@property (nonatomic        ) UIEdgeInsets          itemInsets;
@property (nonatomic        ) CGSize                itemSize;
@property (nonatomic        ) CGFloat               interItemSpacingY;
@property (nonatomic        ) NSInteger             numberOfColumns;

@property (nonatomic, strong) UIView                *vLibrary;

@property (nonatomic, strong) SCPhotoCollectionView *scPhotoCollectionView;
@end
