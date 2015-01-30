//
//  SCCommentTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/29/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCCommentTableView.h"

@implementation SCCommentTableView

@synthesize wallData;

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
    maxRow = 50;
    
    self.wallData = [DataWall new];
    sizeText = CGSizeMake(self.bounds.size.width - 110, CGFLOAT_MAX);
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, 55, 0, 0)];
    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
    
}

- (void) setData:(DataWall*)_data{
    self.wallData = _data;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.wallData.comments count] > maxRow) {
        return 3;
    }else{
        if ([self.wallData.comments count] > 0) {
            return 2;
        }
        
        return 1;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.wallData.comments count] > maxRow) {
        if (section == 0 || section == 1) {
            return 1;
        }else{
            return maxRow;
        }
    }else{
        if (section == 0) {
            return 1;
        }else{
            return [self.wallData.comments count];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.wallData.comments count] > maxRow) {
        if (indexPath.section == 0) {
            CGSize sizeContent = [self.wallData.content sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByCharWrapping];
            sizeContent.height += 30;
            sizeContent.height = sizeContent.height < 50 ? 50 : sizeContent.height;
            
            return sizeContent.height;
        }
        
        if (indexPath.section == 1) {
            return 50;
        }
        
        if (indexPath.section == 2) {
            PostComment *_comment = [self.wallData.comments objectAtIndex:indexPath.row];
            CGSize sizeContent = [_comment.contentComment sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByCharWrapping];
            sizeContent.height += 30;
            sizeContent.height = sizeContent.height < 50 ? 50 : sizeContent.height;
            
            return sizeContent.height;

        }
    }else{
        if (indexPath.section == 0) {
            CGSize sizeContent = [self.wallData.content sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByCharWrapping];
            sizeContent.height += 30;
            sizeContent.height = sizeContent.height < 50 ? 50 : sizeContent.height;
            
            return sizeContent.height;
        }else{
            PostComment *_comment = [self.wallData.comments objectAtIndex:indexPath.row];
            CGSize sizeContent = [_comment.contentComment sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByCharWrapping];
            sizeContent.height += 30;
            sizeContent.height = sizeContent.height < 50 ? 50 : sizeContent.height;
            
            return sizeContent.height;
        }
    }
    
    return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    SCCommentTableViewCell *scCell = nil;
    
    scCell = (SCCommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [scCell.lblLoadMore setHidden:YES];
    
    if (indexPath.section == 0) {
        [scCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        User *_user = storeIns.user;
        
        CGSize sizeContent = [self.wallData.content sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByCharWrapping];
        
        scCell.imgAvatar.image = _user.thumbnail;
        
        scCell.lblNickName.text = [NSString stringWithFormat:@"%@", _user.nickName];
        [scCell.lblNickName setDelegate:self];
        NSString *str = [NSString stringWithFormat:@"%@", _user.nickName];
        
        NSRange r = [str rangeOfString:scCell.lblNickName.text];
        NSString *strLink = [NSString stringWithFormat:@"action://show-profile?%i", _user.userID];
        strLink = [strLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [scCell.lblNickName addLinkToURL:[NSURL URLWithString:strLink] withRange:r];
        
        scCell.lblComment.text = self.wallData.content;
        [scCell.lblComment setFrame:CGRectMake(55, scCell.lblNickName.frame.origin.y + scCell.lblNickName.bounds.size.height, scCell.lblNickName.bounds.size.width, sizeContent.height)];
        
        scCell.lblTime.text = @"2h";
        [scCell.lblTime setFrame:CGRectMake(self.bounds.size.width - 50, 5, 50, 20)];
    }else{
        
        if ([self.wallData.comments count] > maxRow) {
            if (indexPath.section == 1) {
                [scCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
                
                [scCell.lblLoadMore setHidden:NO];
                [scCell.lblNickName setHidden:YES];
                [scCell.imgAvatar setHidden:YES];
                [scCell.lblComment setHidden:YES];
                [scCell.lblTime setHidden:YES];
            }else{
                [scCell setSelectionStyle:UITableViewCellSelectionStyleNone];

                [self renderComment:scCell withIndexPath:indexPath];

            }
        }else{
            [scCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            [self renderComment:scCell withIndexPath:indexPath];
            
        }
    }
    
    return scCell;
}

- (void) renderComment:(SCCommentTableViewCell*)scCell withIndexPath:(NSIndexPath*)indexPath{
    PostComment *_comment = [self.wallData.comments objectAtIndex:indexPath.row];
    
    Friend      *_friend = [storeIns getFriendByID:_comment.userCommentId];
    if (_friend && _friend.friendID > 0) {
        [scCell.imgAvatar setImage:_friend.thumbnail];
    }else{
        User *_user = storeIns.user;
        if (_user.userID == _comment.userCommentId) {
            scCell.imgAvatar.image = _user.thumbnail;
        }else{
            
            //call get info use
//            scCell.imgAvatar.image = _comment.urlImageComment;
        }
    }
    
    CGSize sizeContent = [_comment.contentComment sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByCharWrapping];
    
    scCell.lblNickName.text = [NSString stringWithFormat:@"%@ %@", _comment.firstName, _comment.lastName];
    [scCell.lblNickName setDelegate:self];
    NSString *str = [NSString stringWithFormat:@"%@ %@", _comment.firstName, _comment.lastName];
    
    NSRange r = [str rangeOfString:scCell.lblNickName.text];
    NSString *strLink = [NSString stringWithFormat:@"action://show-profile?%i", _comment.userCommentId];
    strLink = [strLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [scCell.lblNickName addLinkToURL:[NSURL URLWithString:strLink] withRange:r];
    
    scCell.lblComment.text = _comment.contentComment;
    [scCell.lblComment setFrame:CGRectMake(55, scCell.lblNickName.frame.origin.y + scCell.lblNickName.bounds.size.height, scCell.lblNickName.bounds.size.width, sizeContent.height)];
    
    scCell.lblTime.text = @"2h";
    [scCell.lblTime setFrame:CGRectMake(self.bounds.size.width - 50, 5, 50, 20)];

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SCCommentTableViewCell *cell = (SCCommentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
//    UIColor *c = [UIColor whiteColor];
//    NSAttributedString *textAttribute = [[NSAttributedString alloc] initWithString:cell.lblName.text attributes:@{ NSForegroundColorAttributeName : c }];
//    [cell.lblName setAttributedText:textAttribute];
//    
//    NSAttributedString *vincityAttribute = [[NSAttributedString alloc] initWithString:cell.lblVincity.text attributes:@{ NSForegroundColorAttributeName : c }];
//    [cell.lblVincity setAttributedText:vincityAttribute];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectNearLocation" object:nil userInfo:nil];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SCNearTableViewCell *cell = (SCNearTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell.lblName setTextColor:[UIColor blackColor]];
//    [cell.lblVincity setTextColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"show-profile"]) {
            //             load help screen
            NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            Friend *_friend = [storeIns getFriendByID:[query intValue]];
            
            if (_friend != nil) {
                NSString *key = @"tapFriend";
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_friend forKey:key];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
            }
            
        } else if ([[url host] hasPrefix:@"show-tag"]) {
            /* load settings screen */
            NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"Click Tag %@", query);
        }
    } else {
        /* deal with http links here */
    }
}
@end
