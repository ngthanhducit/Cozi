//
//  SCLikeTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCLikeTableView.h"

@implementation SCLikeTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    
    sizeText = CGSizeMake(self.bounds.size.width - 110, CGFLOAT_MAX);
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self setSeparatorInset:UIEdgeInsetsMake(0, 55, 0, 0)];
    [self setDelaysContentTouches:NO];
//    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) setData:(DataWall*)_wall;{
    _wallData = _wall;
}

#pragma mark- UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_wallData.likes count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    SCLikeTableViewCell *scCell = nil;
    
    scCell = (SCLikeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCLikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    PostLike *like = (PostLike*)[_wallData.likes objectAtIndex:indexPath.row];
    
    if (![like.urlAvatarThumb isEqualToString:@""]) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:like.urlAvatarThumb] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished) {
                [scCell.imgAvatar setImage:image];
            }
        }];
    }else{
        [scCell.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
    }

    scCell.lblNickName.text = [NSString stringWithFormat:@"%@ %@", like.firstName, like.lastName];

    [scCell.btnFollowing setTag:1000 + indexPath.row];
    
    [scCell.btnFollowing addTarget:self action:@selector(btnFollowingClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (like.userLikeId != storeIns.user.userID) {
        BOOL isExists = [storeIns isFollowing:like.userLikeId];
        [scCell.btnFollowing setHidden:NO];
        if (isExists) {
            [scCell.btnFollowing setTitle:@"Following" forState:UIControlStateNormal];
        }else{
            [scCell.btnFollowing setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }else{
        [scCell.btnFollowing setHidden:YES];
    }
    
    return scCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostLike *_like = [_wallData.likes objectAtIndex:indexPath.row];
    
    if (storeIns.user.userID == _like.userLikeId) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
    }else{
        NSString *key = @"tapFriend";
        NSNumber *nFriend = [NSNumber numberWithInt:_like.userLikeId];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:nFriend forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
    }
}

//- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
//    // Because we set delaysContentTouches = NO, we return YES for UIButtons
//    // so that scrolling works correctly when the scroll gesture
//    // starts in the UIButtons.
//    if ([view isKindOfClass:[UIButton class]]) {
//        return YES;
//    }
//    
//    return [super touchesShouldCancelInContentView:view];
//}

- (void) btnFollowingClick:(id)sender{
    NSLog(@"click Following");
    UIButton *btnFollowing = (UIButton*)sender;
    NSInteger _tagFollowing = btnFollowing.tag;

    PostLike *_like = [_wallData.likes objectAtIndex:_tagFollowing - 1000];
    
    NSString *key = @"followingUser";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_like forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationAddRemoveFollowing" object:nil userInfo:dictionary];
}
@end
