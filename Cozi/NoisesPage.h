//
//  NoisesPage.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNoiseCollectionViewLayout.h"
#import "SCNoiseCollectionView.h"

@interface NoisesPage : UIView
{
    
}

@property (nonatomic) UIEdgeInsets              itemInsets;
@property (nonatomic) CGSize                    itemSize;
@property (nonatomic) CGFloat                   interItemSpacingY;
@property (nonatomic) NSInteger                 numberOfColumns;

@property (nonatomic, strong) SCNoiseCollectionView *scCollection;


@end
