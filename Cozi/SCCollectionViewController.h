//
//  SCCollectionViewController.h
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/23/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCollectionViewLayout.h"
#import "SCCollectionViewCell.h"
#import "Store.h"
#import "Helper.h"
#import "ImageSelected.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const PhotoCellIdentifier = @"PhotoCell";
@protocol SCCollectionViewDelegate <NSObject>

@required
- (void) delegateScrollView:(UIScrollView*)scrollView;

@end

@interface SCCollectionViewController : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    id<SCCollectionViewDelegate>                        _scCollectionDelegate;
    NSMutableArray                                      *itemData;
    int                         type;
    NSMutableDictionary                  *indexPathSelected;
    NSMutableArray                      *indexNewMessenger;
    BOOL                            increment ;
    NSTimer                         *timerNewMessenger;
}


@property (nonatomic, strong) id<SCCollectionViewDelegate>          scCollectionDelegate;
@property (nonatomic, strong) Store             *storeIns;
@property (nonatomic, strong) Helper             *helperIns;

- (void) initWithData:(NSMutableArray *)_itemData withType:(int)_type;
- (NSMutableArray*) getItemSelected;
@end
