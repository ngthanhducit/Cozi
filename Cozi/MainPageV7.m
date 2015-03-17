//
//  MainPageV7.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "MainPageV7.h"

@implementation MainPageV7

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _top=[self getHeaderHeight];
        
        [self initVariable];
        
        [self drawFriend];
    }
    
    return self;
}


- (void) initVariable{
    
    self.storeIns = [Store shareInstance];
    
    self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.itemSize = CGSizeMake(100.0f, 100.0f);
    self.interItemSpacingY = 5.0f;
    self.numberOfColumns = 3;
}

-(void) drawFriend
{
    int fViewH=self.bounds.size.height;
    
    CGFloat columns = self.bounds.size.width / (self.itemSize.width + self.itemInsets.left + self.interItemSpacingY);
    CGFloat _columnFlood = floor(columns);
    CGFloat _columnMinus = columns - _columnFlood;
    CGFloat _columnResult = 0.0;
    if (_columnMinus > 0.8) {
        _columnResult = round(columns);
    }else{
        _columnResult = _columnFlood;
    }
    
    CGFloat widthCell = (self.bounds.size.width / _columnResult) - (self.interItemSpacingY * (_columnResult - 1));
    widthCell = widthCell < 100 ? 100 : widthCell;
    
    self.itemSize = CGSizeMake(widthCell, widthCell);
    
    SCCollectionViewLayout *layout = [[SCCollectionViewLayout alloc] initWithData:self.itemInsets withItemSize:self.itemSize withSpacingY:self.interItemSpacingY withColumns:_columnResult];

    self.scCollection = [[SCCollectionViewController alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, fViewH + 10) collectionViewLayout:layout];
    
//    UIView *temp = [[UIView alloc] initWithFrame:self.scCollection.bounds];
//    [temp setBackgroundColor:[UIColor colorWithRed:45/255.0f green:45/255.0f blue:45/255.0f alpha:1.0]];
    
    [self.scCollection initWithData:nil withType:0];
    [self.scCollection setBounces:YES];
//    [self.scCollection setAlwaysBounceHorizontal:YES];
    [self.scCollection setAlwaysBounceVertical:YES];
    [self.scCollection setShowsHorizontalScrollIndicator:NO];
    [self.scCollection setShowsVerticalScrollIndicator:NO];
    [self.scCollection setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.scCollection];
}

@end
