//
//  NoisesPage.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "NoisesPage.h"

@implementation NoisesPage

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initVariable];
        [self setupUI];
    }
    
    return self;
}


- (void) initVariable{
    
//    self.storeIns = [Store shareInstance];
    
    self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.itemSize = CGSizeMake(100.0f, 100.0f);
    self.interItemSpacingY = 5.0f;
    self.numberOfColumns = 3;
}

- (void) setupUI{
    CGFloat columns = self.bounds.size.width / (self.itemSize.width + self.itemInsets.left + self.interItemSpacingY);
    CGFloat _columnFlood = floor(columns);
    CGFloat _columnMinus = columns - _columnFlood;
    CGFloat _columnResult = 0.0;
    if (_columnMinus > 0.8) {
        _columnResult = round(columns);
    }else{
        _columnResult = _columnFlood;
    }
    
    CGFloat widthCell = (self.bounds.size.width / _columnResult) - 25;
    widthCell = widthCell < 100 ? 100 : widthCell;
    
    self.itemSize = CGSizeMake(widthCell, widthCell);
    
    SCNoiseCollectionViewLayout *layout = [[SCNoiseCollectionViewLayout alloc] initWithData:self.itemInsets withItemSize:self.itemSize withSpacingY:self.interItemSpacingY withColumns:3];
    
    self.scCollection = [[SCNoiseCollectionView alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
    
    [self.scCollection setShowsHorizontalScrollIndicator:NO];
    [self.scCollection setShowsVerticalScrollIndicator:NO];
    [self.scCollection setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.scCollection];
}
@end
