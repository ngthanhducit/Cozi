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
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
        
        if (self.wallData.userPostID == _user.userID) {
            
            CGSize sizeContent = [self.wallData.content sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByCharWrapping];
            
            if (_user.thumbnail) {
                scCell.imgAvatar.image = _user.thumbnail;
            }else{
                [scCell.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
            }

            scCell.lblNickName.text = [NSString stringWithFormat:@"%@", _user.nickName];
            [scCell.lblNickName setDelegate:self];
            NSString *str = [NSString stringWithFormat:@"%@", _user.nickName];
            
            NSRange r = [str rangeOfString:scCell.lblNickName.text];
            NSString *strLink = [NSString stringWithFormat:@"action://show-profile?%i", _user.userID];
            strLink = [strLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [scCell.lblNickName addLinkToURL:[NSURL URLWithString:strLink] withRange:r];
            
            scCell.lblComment.text = self.wallData.content;
            [scCell.lblComment setFrame:CGRectMake(55, scCell.lblNickName.frame.origin.y + scCell.lblNickName.bounds.size.height, scCell.lblNickName.bounds.size.width, sizeContent.height)];
            
            
            
            scCell.lblTime.text = [self calculationTimeAgo:self.wallData.time];
            
            [scCell.lblTime setFrame:CGRectMake(self.bounds.size.width - 50, 5, 50, 20)];
            
        }else{  //Friend or not post
            
            CGSize sizeContent = [self.wallData.content sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:sizeText lineBreakMode:NSLineBreakByCharWrapping];
            
            if (self.wallData.urlAvatarThumb) {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.wallData.urlAvatarThumb] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (image && finished) {
                        scCell.imgAvatar.image = image;
                    }
                }];
            }
            
            scCell.lblNickName.text = [NSString stringWithFormat:@"%@ %@", self.wallData.firstName, self.wallData.lastName];
            [scCell.lblNickName setDelegate:self];
            NSString *str = [NSString stringWithFormat:@"%@ %@", self.wallData.firstName, self.wallData.lastName];
            
            NSRange r = [str rangeOfString:scCell.lblNickName.text];
            NSString *strLink = [NSString stringWithFormat:@"action://show-profile?%i", self.wallData.userPostID];
            strLink = [strLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [scCell.lblNickName addLinkToURL:[NSURL URLWithString:strLink] withRange:r];
            
            scCell.lblComment.text = self.wallData.content;
            [scCell.lblComment setFrame:CGRectMake(55, scCell.lblNickName.frame.origin.y + scCell.lblNickName.bounds.size.height, scCell.lblNickName.bounds.size.width, sizeContent.height)];
            
            scCell.lblTime.text = [self calculationTimeAgo:self.wallData.time];
            [scCell.lblTime setFrame:CGRectMake(self.bounds.size.width - 50, 5, 50, 20)];
            
        }

        
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
            
            if (![_comment.urlAvatarThumb isEqualToString:@""]) {
                //call get info use
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_comment.urlAvatarThumb] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    if (image && finished) {
                        scCell.imgAvatar.image = image;
                    }
                }];
                
            }else{
                [scCell.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
            }
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
    
    scCell.lblTime.text = [self calculationTimeAgo:[helperIns convertNSDateToString:_comment.dateComment withFormat:@"yyyy-MM-dd HH:mm:ss"]];
    
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
            
            if ([query intValue] == storeIns.user.userID) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
            }else{
                NSString *key = @"tapFriend";
                NSNumber *nUser = [NSNumber numberWithInt:[query intValue]];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:nUser forKey:key];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
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

- (NSString*) calculationTimeAgo:(NSString *)_timePost{
    //calculation time count down
    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:storeIns.timeServer];
    NSDate *timeMessage = [helperIns convertStringToDate:_timePost];
    NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                                        fromDate:_dateTimeMessage
                                                          toDate:[NSDate date]
                                                         options:0];
    
    NSString *timeAgo = @"";
    NSInteger w = [components week];
    if (w <= 0) {
        NSInteger d = [components day];
        if (d <= 0) {
            NSInteger h = components.hour;
            if (h <=0) {
                NSInteger m = [components minute];
                if (m <= 0) {
                    NSInteger s = [components second];
                    timeAgo = [NSString stringWithFormat:@"%i s", (int)s];
                }else{
                    timeAgo = [NSString stringWithFormat:@"%i m", (int)m];
                }
            }else{
                timeAgo = [NSString stringWithFormat:@"%i h", (int)h];
            }
        }else{
            timeAgo = [NSString stringWithFormat:@"%i d", (int)d];
        }
    }else{
        timeAgo = [NSString stringWithFormat:@"%i w", (int)w];
    }
    
    return timeAgo;
}
@end
