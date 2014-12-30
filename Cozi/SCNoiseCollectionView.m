//
//  SCNoiseCollectionView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCNoiseCollectionView.h"

@implementation SCNoiseCollectionView
static NSString * const reuseIdentifier = @"Cell";

- (id) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:refresh];
    
    // Register cell classes
    [self registerClass:[SCNoiseCollectionViewCell class] forCellWithReuseIdentifier:NoiseCellIdentifier];
    [self setDelegate:self];
    [self setDataSource:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [storeIns.noises count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCNoiseCollectionViewCell *scCell = [collectionView dequeueReusableCellWithReuseIdentifier:NoiseCellIdentifier
                                                                                  forIndexPath:indexPath];
    [scCell setBackgroundColor:[UIColor grayColor]];
    
    DataWall *_noise = [storeIns.noises objectAtIndex:indexPath.section];
    
    [scCell.imgView setImage:[_noise.images lastObject]];
    [scCell.imgView setFrame:CGRectMake(0, 0, scCell.bounds.size.width, scCell.bounds.size.height)];
    [scCell.imgView setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GrayColor1"]]];
    [scCell.imgView setContentMode:UIViewContentModeScaleAspectFill];
    [scCell.imgView setAutoresizingMask:UIViewAutoresizingNone];
    [scCell.imgView setClipsToBounds:YES];
    
    [scCell.shadowImage setFrame:CGRectMake(0, 0, scCell.bounds.size.width, scCell.bounds.size.height)];
    [scCell.shadowImage setBackgroundColor:[UIColor whiteColor]];
    scCell.shadowImage.layer.borderWidth = 0.0f;
    
    return scCell;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SCNoiseCollectionViewCell *scCell = (SCNoiseCollectionViewCell*)[self cellForItemAtIndexPath:indexPath];

}


- (void) stopLoadNoise{
    
    [refresh endRefreshing];
    
}

- (void) handleRefresh:(id)sender{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadNewNoise" object:nil userInfo:nil];
    
}
@end
