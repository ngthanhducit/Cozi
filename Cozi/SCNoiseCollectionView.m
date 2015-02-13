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
    
    // Register cell classes
    [self registerClass:[SCNoiseCollectionViewCell class] forCellWithReuseIdentifier:NoiseCellIdentifier];
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self setBounces:YES];
    [self setAlwaysBounceVertical:YES];
}

- (void) initData:(NSMutableArray*)_data withType:(int)_type{
    type = _type;
    if (type == 0) {
        refresh = [[UIRefreshControl alloc] init];
        [refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:refresh];
    }
    
    items = _data;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (type == 0) {
        return [storeIns.noises count];
    }else{
        return [items count];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCNoiseCollectionViewCell *scCell = [collectionView dequeueReusableCellWithReuseIdentifier:NoiseCellIdentifier
                                                                                  forIndexPath:indexPath];
    [scCell setBackgroundColor:[UIColor grayColor]];
    DataWall *_noise;
    if (type == 0) {
        _noise = [storeIns.noises objectAtIndex:indexPath.section];
        
        if (indexPath.section == ([storeIns.noises count] - 4) && !inLoadMoreNoise) {
            inLoadMoreNoise = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMoreNoise" object:nil];
        }
    }else{
        _noise = [items objectAtIndex:indexPath.section];
    }
    
    [scCell.imgView setFrame:CGRectMake(0, 0, scCell.bounds.size.width, scCell.bounds.size.height)];
    [scCell.imgView setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GrayColor1"]]];
    [scCell.imgView setContentMode:UIViewContentModeScaleAspectFill];
    [scCell.imgView setAutoresizingMask:UIViewAutoresizingNone];
    [scCell.imgView setClipsToBounds:YES];
    
    [scCell.imgView sd_setImageWithURL:[NSURL URLWithString:_noise.urlThumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [scCell.shadowImage setFrame:CGRectMake(0, 0, scCell.bounds.size.width, scCell.bounds.size.height)];
    [scCell.shadowImage setBackgroundColor:[UIColor whiteColor]];
    scCell.shadowImage.layer.borderWidth = 0.0f;
    
    return scCell;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DataWall *_noise;
    if (type == 0) {
        _noise = [storeIns.noises objectAtIndex:indexPath.section];
        
        NSString *key = @"selectNoise";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_noise forKey:key];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectNoiseNotification" object:nil userInfo:dictionary];
        
    }else{
        _noise = [items objectAtIndex:indexPath.section];
        
        NSString *key = @"selectMyNoise";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_noise forKey:key];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectMyNoiseNotification" object:nil userInfo:dictionary];

    }
}

- (void) stopLoadNoise:(BOOL)_isEnd{
    inLoadMoreNoise = NO;
    isEndData = _isEnd;
    [refresh endRefreshing];
    
    if (!isEndData) {
        [self reloadData];
    }
}

- (void) handleRefresh:(id)sender{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadNewNoise" object:nil userInfo:nil];
    
}
@end
