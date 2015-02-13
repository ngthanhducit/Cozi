//
//  SCFriendRequestTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/12/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCFriendRequestTableView.h"

@implementation SCFriendRequestTableView

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
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setDelaysContentTouches:NO];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) initData:(NSMutableArray *)_itemsData{
    items = _itemsData;
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
    SCFriendRequestTableViewCell *scCell = nil;
    
    scCell = (SCFriendRequestTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCFriendRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    UserSearch *friendRequest = (UserSearch*)[items objectAtIndex:indexPath.row];

    if (![friendRequest.urlAvatar isEqualToString:@""]) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:friendRequest.urlAvatar] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished) {
                [scCell.imgAvatar setImage:image];
            }
        }];
    }else{
        [scCell.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
    }
    
    scCell.lblFullName.text = friendRequest.nickName;
    
    [scCell.btnDeny setTag:1000 + indexPath.row];
    [scCell.btnDeny addTarget:self action:@selector(btnDenyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [scCell.btnAccept setTag:2000 + indexPath.row];
    [scCell.btnAccept addTarget:self action:@selector(btnAcceptClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [scCell.btnFollowing setTag:1000 + indexPath.row];
//    
//    [scCell.btnFollowing addTarget:self action:@selector(btnFollowingClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    if (like.userLikeId != storeIns.user.userID) {
//        BOOL isExists = [storeIns isFollowing:like.userLikeId];
//        [scCell.btnFollowing setHidden:NO];
//        if (isExists) {
//            [scCell.btnFollowing setTitle:@"Following" forState:UIControlStateNormal];
//        }else{
//            [scCell.btnFollowing setTitle:@"Follow" forState:UIControlStateNormal];
//        }
//    }else{
//        [scCell.btnFollowing setHidden:YES];
//    }
    
    return scCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSearch *_friendRequest = [items objectAtIndex:indexPath.row];
    
    if (storeIns.user.userID == _friendRequest.friendID) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
    }else{
        
        NSString *key = @"tapFriend";
        NSNumber *nFriend = [NSNumber numberWithInt:_friendRequest.friendID];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:nFriend forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
        
    }
}

- (void) btnDenyClick:(id)sender{
    UIButton *btnDeny = (UIButton*)sender;
    NSInteger _tagDeny = (btnDeny.tag - 1000);
    
    UserSearch *_friendRequest = (UserSearch*)[items objectAtIndex:_tagDeny];
    
    NSString *key = @"DenyAddFriend";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_friendRequest forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDenyAddFriend" object:nil userInfo:dictionary];
}

- (void) btnAcceptClick:(id)sender{
    UIButton *btnDeny = (UIButton*)sender;
    NSInteger _tagDeny = (btnDeny.tag - 2000);
    
    UserSearch *_friendRequest = (UserSearch*)[items objectAtIndex:_tagDeny];
    
    NSString *key = @"AcceptAddFriend";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_friendRequest forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationAcceptAddFriend" object:nil userInfo:dictionary];
}


@end
