//
//  MainPageV6.h
//  VPix
//
//  Created by khoa ngo on 11/11/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwapView.h"
#import "SCCollectionViewLayout.h"
#import "SCCollectionViewController.h"
#import "Store.h"

@interface MainPageV6 : SwapView <UIScrollViewDelegate>
{
    int _top,_avartaH,_searchH;
    UIScrollView *_mScroll;
    UIImageView *_avarta;
    UIView *_searchView;
    UIView *friendView;
}

@property (nonatomic, strong) SCCollectionViewController *scCollection;

@property (nonatomic) UIEdgeInsets              itemInsets;
@property (nonatomic) CGSize                    itemSize;
@property (nonatomic) CGFloat                   interItemSpacingY;
@property (nonatomic) NSInteger                 numberOfColumns;
@property (nonatomic, strong) UIView                    *viewInfo;
@property (nonatomic, strong) UILabel                   *lblFirstName;
@property (nonatomic, strong) UILabel                   *lblLastName;
@property (nonatomic, strong) UILabel                   *lblLocationInfo;
@property (nonatomic, strong) User                      *userIns;
@property (nonatomic, strong) Store                     *storeIns;
//@property (nonatomic, strong) UIScrollView              *mScroll;

- (void) initMyInfo:(User*)_myUser;
-(void) drawAvatar;
- (void) setContentSizeContent:(CGSize)contentSize;
@end
