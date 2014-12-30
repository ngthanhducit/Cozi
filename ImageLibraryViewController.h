//
//  ImageLibraryViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/11/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCollectionViewController.h"
#import "Helper.h"
#import "Cozi/Store.h"
#import "Cozi/ImageSelected.h"
#import "NetworkCommunication.h"

@interface ImageLibraryViewController : UIViewController
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
