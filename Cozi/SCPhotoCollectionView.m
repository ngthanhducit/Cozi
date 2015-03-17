//
//  SCPhotoCollectionView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPhotoCollectionView.h"

@implementation SCPhotoCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    assets = [storeIns getAssetsThumbnail];
    
    // Register cell classes
    [self registerClass:[SCPhotoCollectionViewCell class] forCellWithReuseIdentifier:PostPhotoCellIdentifier];
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self setBounces:YES];
    [self setAlwaysBounceVertical:YES];
}

- (void) initData:(NSMutableArray*)_items{
    assets = _items;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [assets count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCPhotoCollectionViewCell *scCell = [collectionView dequeueReusableCellWithReuseIdentifier:PostPhotoCellIdentifier
                                                                                  forIndexPath:indexPath];
    [scCell setBackgroundColor:[UIColor grayColor]];
    
    UIImage *_image = [assets objectAtIndex:indexPath.section];
    
    scCell.imgView.layer.borderWidth = 0.0;
    [scCell.imgView setImage:_image];
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
    [storeIns playSoundPress];
    
    lastSelect = (int)indexPath.section;
    
    if (lastSelectIndex) {
        SCPhotoCollectionViewCell *scCell = (SCPhotoCollectionViewCell*)[self cellForItemAtIndexPath:lastSelectIndex];
        scCell.imgView.layer.borderWidth = 0.0;
    }
    
    SCPhotoCollectionViewCell *scCell = (SCPhotoCollectionViewCell*)[self cellForItemAtIndexPath:indexPath];
    scCell.imgView.layer.borderWidth = 4.0;
    scCell.imgView.layer.borderColor = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]].CGColor;
    
    NSNumber *resultCode = [NSNumber numberWithInt:(int)indexPath.section];
    NSString *key = @"tapPhotoPost";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:resultCode forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POSTPHOTOSELECT" object:nil userInfo:dictionary];
    
    lastSelectIndex = indexPath;
}

- (void) handleRefresh:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadNewNoise" object:nil userInfo:nil];
    
}

@end
