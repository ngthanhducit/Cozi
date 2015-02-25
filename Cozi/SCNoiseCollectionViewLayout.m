//
//  SCNoiseCollectionViewLayout.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCNoiseCollectionViewLayout.h"

static NSString * const SCLayoutPhotoCellKind = @"PhotoCell";

@implementation SCNoiseCollectionViewLayout

@synthesize itemInsets;
@synthesize itemSize;
@synthesize interItemSpacingY;
@synthesize numberOfColumns;

- (id) init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //        [self setup];
    }
    
    return self;
}

- (id) initWithData:(UIEdgeInsets)_itemInsets withItemSize:(CGSize)_itemSize withSpacingY:(CGFloat)_spacingY withColumns:(NSInteger)_columns{
    self.itemInsets = _itemInsets;
    self.itemSize = _itemSize;
    self.interItemSpacingY = _spacingY;
    self.numberOfColumns = _columns;
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void) setup {
    self.itemInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    self.itemSize = CGSizeMake(100.0f, 100.0f);
    self.interItemSpacingY = 10.0f;
    self.numberOfColumns = 2;
}

#pragma -mark - Layout
- (void) prepareLayout{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[SCLayoutPhotoCellKind] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.layoutInfo[SCLayoutPhotoCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    // make sure we count another row if one is only partially filled
    if ([self.collectionView numberOfSections] % self.numberOfColumns) rowCount++;
    
    CGFloat height = self.itemInsets.top +
    rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY +
    self.itemInsets.bottom;
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

#pragma mark - Private

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    CGFloat spacingX = self.collectionView.bounds.size.width -
    self.itemInsets.left -
    self.itemInsets.right -
    (self.numberOfColumns * self.itemSize.width);
    
    if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns - 1);
    
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
    
    CGFloat originY = floor(self.itemInsets.top +
                            (self.itemSize.height + self.interItemSpacingY) * row);
    
    NSLog(@"origin x: %f - origin y: %f - row: %i", originX, originY, (int)row);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

@end
