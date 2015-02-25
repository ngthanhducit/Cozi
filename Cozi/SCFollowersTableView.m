//
//  SCFollowersTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/31/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCFollowersTableView.h"

@implementation SCFollowersTableView

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
    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) setData:(NSMutableArray*)_dataItems;{
    items = _dataItems;
}

#pragma mark- UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [items count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    SCFollowersTableViewCell *scCell = nil;
    
    scCell = (SCFollowersTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCFollowersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    FollowerUser *follower = [items objectAtIndex:indexPath.row];
    
    [scCell.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
    
    if (follower.userID == storeIns.user.userID) {
        if (storeIns.user.thumbnail) {
            [scCell.imgAvatar setImage:storeIns.user.thumbnail];
        }
    }else{
        UIImage *imgThumb = [storeIns getAvatarThumbFriend:follower.userID];
        if (imgThumb) {
            [scCell.imgAvatar setImage:imgThumb];
        }else{
            if (![follower.urlAvatar isEqualToString:@""]) {
                
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:follower.urlAvatar] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (image && finished) {
                        [scCell.imgAvatar setImage:image];
                    }
                }];
                
            }
        }
    }
    
    scCell.lblNickName.text = [NSString stringWithFormat:@"%@ %@", follower.firstName, follower.lastName];
    
    [scCell.btnFollowing setTag:1000+indexPath.row];
    [scCell.btnFollowing addTarget:self action:@selector(btnFollowingClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (follower.userID != storeIns.user.userID) {
        BOOL isExists = [storeIns isFollowing:follower.userID];
        [scCell.btnFollowing setHidden:NO];
        if (isExists) {
            [scCell.btnFollowing setTitle:@"Following" forState:UIControlStateNormal];
        }else{
            [scCell.btnFollowing setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }else{
        [scCell.btnFollowing setHidden:YES];
    }
    
    for (UIView *currentView in tableView.subviews) {
        if ([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    return scCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowerUser *_follow = [items objectAtIndex:indexPath.row];
    
    if (storeIns.user.userID == _follow.userID) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
    }else{
        NSString *key = @"tapFriend";
        NSNumber *nFriend = [NSNumber numberWithInt:_follow.userID];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:nFriend forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
    }
}


- (void) btnFollowingClick:(id)sender{
    NSLog(@"click Following");
    UIButton *btnFollowing = (UIButton*)sender;
    NSInteger _tagFollowing = btnFollowing.tag;
    
    FollowerUser *_follower = [items objectAtIndex:_tagFollowing - 1000];
    
    NSString *key = @"followingUser";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_follower forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationAddRemoveFollowing" object:nil userInfo:dictionary];

}
@end
