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
#import "SCNoiseCollectionView.h"
#import "Store.h"
#import "TriangleView.h"
#import "Profile.h"
#import "User.h"

@interface MainPageV6 : SwapView <UIScrollViewDelegate>
{
    int _top,_avartaH,_searchH;
    UIScrollView *_mScroll;
    UIImageView *_avarta;
    UIView *_followInfo;
    UIView *friendView;
    
    UIView          *vAddFollow;
    UIView          *vFollowers;
    UIView          *vFollowing;
    UIView          *vPosts;
    
    UILabel         *lblFollowers;
    UILabel         *lblFollowing;
    UILabel         *lblPosts;
    
    Profile         *profile;
    User            *user;
    NSMutableArray          *items;

    UIActivityIndicatorView     *waitingLoadHistory;
    UIActivityIndicatorView     *waitingLoadAvatar;
}

@property (nonatomic, strong)     UIActivityIndicatorView     *waitingFollow;
@property (nonatomic, strong) SCNoiseCollectionView *scCollection;

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
@property (nonatomic, strong) UIButton                  *btnEditProfile;
@property (nonatomic, strong) UIButton                  *btnFollow;
//@property (nonatomic, strong) UIScrollView              *mScroll;
@property (nonatomic, strong) UIView                  *vFollowingUser;

- (void) initFriend:(Profile*)_profile;
- (void) initUser:(User*)_user;
- (void) setNoisesHistory:(NSMutableArray*)_items;

-(void) drawAvatar:(UIImage*)_imgAvatar;
- (void) setContentSizeContent:(CGSize)contentSize;

- (void) initButtonFollowUser;
- (void) initViewFollowing;
@end
