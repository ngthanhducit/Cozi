//
//  SCCollectionViewLayout.h
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/23/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCollectionViewLayout : UICollectionViewLayout
{
    
}

@property (nonatomic, strong) NSDictionary      *layoutInfo;
@property (nonatomic) UIEdgeInsets              itemInsets;
@property (nonatomic) CGSize                    itemSize;
@property (nonatomic) CGFloat                   interItemSpacingY;
@property (nonatomic) NSInteger                 numberOfColumns;

- (id) initWithData:(UIEdgeInsets)_itemInsets withItemSize:(CGSize)_itemSize withSpacingY:(CGFloat)_spacingY withColumns:(NSInteger)_columns;
@end
