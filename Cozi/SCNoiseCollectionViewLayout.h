//
//  SCNoiseCollectionViewLayout.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCNoiseCollectionViewLayout : UICollectionViewLayout
{
    
}

@property (nonatomic, strong) NSDictionary      *layoutInfo;
@property (nonatomic) UIEdgeInsets              itemInsets;
@property (nonatomic) CGSize                    itemSize;
@property (nonatomic) CGFloat                   interItemSpacingY;
@property (nonatomic) NSInteger                 numberOfColumns;

- (id) initWithData:(UIEdgeInsets)_itemInsets withItemSize:(CGSize)_itemSize withSpacingY:(CGFloat)_spacingY withColumns:(NSInteger)_columns;
@end
