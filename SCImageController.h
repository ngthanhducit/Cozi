//
//  SCImageController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/21/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"  
#import "SCCollectionViewController.h"

@interface SCImageController : UIViewController
{
        NSMutableArray *itemData;
    Helper              *helperIns;
}

@property (nonatomic) UIEdgeInsets              itemInsets;
@property (nonatomic) CGSize                    itemSize;
@property (nonatomic) CGFloat                   interItemSpacingY;
@property (nonatomic) NSInteger                 numberOfColumns;

@property (nonatomic, strong) SCCollectionViewController *scCollection;


- (void) initData:(NSMutableArray*)_itemData;
@end
