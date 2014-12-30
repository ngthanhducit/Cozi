//
//  MainPageV7.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwapView.h"
#import "SCCollectionViewLayout.h"
#import "Store.h"
#import "User.h"
#import "SCCollectionViewController.h"

@interface MainPageV7 : SwapView
{
    int _top,_avartaH,_searchH;
}

@property (nonatomic) UIEdgeInsets              itemInsets;
@property (nonatomic) CGSize                    itemSize;
@property (nonatomic) CGFloat                   interItemSpacingY;
@property (nonatomic) NSInteger                 numberOfColumns;


@property (nonatomic, strong) SCCollectionViewController *scCollection;
@property (nonatomic, strong) User                      *userIns;
@property (nonatomic, strong) Store                     *storeIns;


@end
