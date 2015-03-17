//
//  SCGroupChatTableView.m
//  Cozi
//
//  Created by ChjpCoj on 3/4/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCGroupChatTableView.h"

@implementation SCGroupChatTableView

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
    listFriends = [NSMutableArray new];
    
    sizeText = CGSizeMake(self.bounds.size.width - 110, CGFLOAT_MAX);
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setDelaysContentTouches:NO];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) initItems:(NSMutableArray *)_itemsData{
    listFriends = _itemsData;
}

#pragma mark- UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listFriends count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    SCGroupChatTableViewCell *scCell = nil;
    
    scCell = (SCGroupChatTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCGroupChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Friend *friend = (Friend*)[listFriends objectAtIndex:indexPath.row];
    
    [scCell.imgAvatar setImage:[helperIns getDefaultAvatar]];
    
    UIImage *imgThumb = [storeIns getAvatarThumbFriend:friend.friendID];
    if (imgThumb) {
        [scCell.imgAvatar setImage:imgThumb];
    }else{
        if (![friend.urlThumbnail isEqualToString:@""]) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:friend.urlThumbnail] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (image && finished) {
                    [scCell.imgAvatar setImage:image];
                }
            }];
        }
    }
    
    scCell.lblNickName.text = friend.nickName
    ;
    
    return scCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PostLike *_like = [_wallData.likes objectAtIndex:indexPath.row];
//    
//    if (storeIns.user.userID == _like.userLikeId) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
//    }else{
//        NSString *key = @"tapFriend";
//        NSNumber *nFriend = [NSNumber numberWithInt:_like.userLikeId];
//        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:nFriend forKey:key];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
//    }
}

@end
