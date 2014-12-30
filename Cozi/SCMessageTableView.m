//
//  SCMessageTableView.m
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "SCMessageTableView.h"
#import "ChatView.h"

@implementation SCMessageTableView

@synthesize friendIns;
@synthesize helperIns;

static CGFloat padding = 20.0;
const CGFloat leftSpacing = 10;
const CGFloat topSpacing = 5.0f;
const CGFloat wViewMainPadding = 30.0f;

const CGSize sizeIcon = { 40, 40 };
const CGSize sizeImage = { 240, 160 };

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
    self.helperIns = [Helper shareInstance];
    self.storeIns = [Store shareInstance];
    
    clearData = NO;
    
    lastMessage = nil;
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (clearData) {
        return 0;
    }else{
        return [self.friendIns.friendMessage count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    Messenger *_lastMessage = nil;
    
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    if (lastIndexPath.row >= 0) {
        _lastMessage = [self.friendIns.friendMessage objectAtIndex:lastIndexPath.row];
    }
    
    Messenger *_message = [self.friendIns.friendMessage objectAtIndex:indexPath.row];

    if (_message.typeMessage == 0) {
        if (_lastMessage != nil && _lastMessage.senderID == _message.senderID && _lastMessage.typeMessage == _message.typeMessage) {
            NSString *msg = [_message strMessage];
            CGSize textSize = { (self.bounds.size.width - 130), CGFLOAT_MAX };
            CGSize size = [msg sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
            size.height += padding / 2;
            
            size.height = size.height < 45 ? 45 : size.height;
            
            CGFloat height = size.height;
            return height;
        }
        
        NSString *msg = [[_message strMessage] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        CGSize textSize = { (self.bounds.size.width - 130), CGFLOAT_MAX };
        CGSize size = [msg sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];

        size.height += padding;
        
        size.height = size.height < 50 ? 50 : size.height;
        
        CGFloat height = size.height;
        return height;
    }else{
        return 170;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    SCMessageTableViewCell *cell = nil;
    
    //Status Message: 0: Da gui - 1: Da Nhan - 2: Da xem - 3: Loi
    
    Messenger *_message = [self.friendIns.friendMessage objectAtIndex:indexPath.row];
    
    Messenger *_lastMessage = nil;
    
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    
    if (lastIndexPath.row >= 0) {
        _lastMessage = [self.friendIns.friendMessage objectAtIndex:lastIndexPath.row];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (cell == nil) {
        cell = [[SCMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:recognizer];
    
//    UIImage *imgAvatarFriend = [UIImage imageWithData:self.friendIns.dataAvatar];
    UIImage *imgAvatarFriend = self.friendIns.thumbnail;
    //
    //        if (imgAvatarFriend == nil) {
    //            imgAvatarFriend = [SVGKImage imageNamed:@"icon-contact-male.svg"].UIImage;
    //        }
    //
    UIImage *imgAvatarMe = self.storeIns.user.avatar;
    //        if (imgAvatarMe == nil) {
    //            imgAvatarMe = [SVGKImage imageNamed:@"icon-contact-male.svg"].UIImage;
    //        }
    
    [cell.iconFriend setImage: imgAvatarFriend];
    [cell.iconFriend setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GrayColor2"]]];
    [cell.iconImage setImage:imgAvatarMe];
    [cell.iconImage setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GrayColor2"]]];
    
    int _senderID = _message.senderID;
    int _friendID = self.friendIns.friendID;
    CGSize textSize = { self.bounds.size.width - 130, 10000.0 };
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"hh:mm a"];
    NSString *strStatus = @"";
    if (_message.statusMessage == 0) {
        strStatus = @"Send";
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            if (self.scMessageTableViewDelegate && [self.scMessageTableViewDelegate respondsToSelector:@selector(sendIsReadMessage:withKeyMessage:withTypeMessage:)]) {
                [self.scMessageTableViewDelegate sendIsReadMessage:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
            }
            strStatus = @"Read";
            
            [[self.friendIns.friendMessage objectAtIndex:indexPath.row] setStatusMessage:2];
            [self.storeIns updateStatusMessageFriendWithKey:_friendID withMessageID:_message.keySendMessage withStatus:2];
        }else{
            strStatus = @"Recive";
        }
    }
    
    if (_message.statusMessage == 2) {
        strStatus = @"Read";
    }
    
    if (_message.typeMessage == 0) {
        
        NSString *strTime = [NSString stringWithFormat:@"%@\n%@", _message.timeMessage, strStatus];
        
        [cell.smsImage setHidden:YES];
        [cell.viewMain setHidden:NO];
        [cell.txtMessageContent setHidden:NO];
        
        if (_senderID == _friendID) {//friend
            
            if (_lastMessage != nil && _lastMessage.senderID == _message.senderID && _lastMessage.typeMessage == _message.typeMessage){
                CGSize size = [_message.strMessage sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
                size.width += (padding / 2);
                size.height += (padding / 4);
                
                [cell.iconImage setHidden:YES];
                [cell.iconFriend setHidden:NO];
                
                [cell.viewCircle setHidden:YES];
                [cell.viewCircle setFrame:CGRectMake(self.bounds.size.width - (sizeIcon.width + leftSpacing), topSpacing - 5, sizeIcon.width, sizeIcon.height)];
                cell.viewCircle.layer.cornerRadius = CGRectGetHeight(cell.viewCircle.frame)/2;
//                [cell.viewCircle setBackgroundColor:[UIColor whiteColor]];
                [cell.viewCircle setBackgroundColor:[UIColor clearColor]];

                [cell.iconFriend setFrame:CGRectMake(leftSpacing, topSpacing, sizeIcon.width, sizeIcon.height)];
                [cell.iconFriend setContentMode:UIViewContentModeScaleAspectFill];
                [cell.iconFriend setAutoresizingMask:UIViewAutoresizingNone];
                cell.iconFriend.layer.borderWidth = 0.0f;
                [cell.iconFriend setClipsToBounds:YES];
                cell.iconFriend.layer.cornerRadius = CGRectGetHeight(cell.iconFriend.frame)/2;
                
//                CGFloat hView = size.height + (padding / 2);
                CGFloat hView = size.height;
                hView = hView < 40 ? 40 : hView;
                
                CGFloat wView = size.width;
                wView = wView < 30 ? 30 : wView;
                
                [cell.viewMain setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), topSpacing - 5, wView + wViewMainPadding, hView)];
//                [cell.viewMain setBackgroundColor:[[self.helperIns colorWithHex:0xf1f1f1] colorWithAlphaComponent:0.3]];
                [cell.viewMain setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
                
                [cell.txtMessageContent setText:_message.strMessage];
                [cell.txtMessageContent setTextContainerInset:UIEdgeInsetsMake(2, 0, 0, 0)];
//                [cell.txtMessageContent setTextColor:[UIColor blackColor]];
                [cell.txtMessageContent setTextColor:[UIColor whiteColor]];
                [cell.txtMessageContent setBackgroundColor:[UIColor clearColor]];
                [cell.txtMessageContent setFont:[self.helperIns getFontLight:15.0f]];
                [cell.txtMessageContent setFrame:CGRectMake(25, (hView / 2) - (size.height / 2), size.width, size.height)];
                
                [cell.lblTime setText:strTime];
                [cell.lblTime setNumberOfLines:0];
                CGSize sizeTimeLabel = [cell.lblTime.text sizeWithFont:[self.helperIns getFontThin:10.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
                [cell.lblTime setTextAlignment:NSTextAlignmentLeft];
                [cell.lblTime setTextColor:[UIColor whiteColor]];
//                [cell.lblTime setTextColor:[self.helperIns colorWithHex:0x434343]];
                [cell.lblTime setFont:[self.helperIns getFontThin:9.0f]];
                [cell.lblTime setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2) + wView + wViewMainPadding + topSpacing, (hView - sizeTimeLabel.height) + topSpacing - 5, sizeTimeLabel.width, sizeTimeLabel.height)];
            }else{

                CGSize size = [[_message.strMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
                size.width += (padding / 2);
                size.height += (padding / 2);
                
                [cell.iconImage setHidden:YES];
                [cell.iconFriend setHidden:NO];
                
                [cell.viewCircle setHidden:NO];
                [cell.viewCircle setFrame:CGRectMake(leftSpacing, topSpacing, sizeIcon.width, sizeIcon.height)];
                cell.viewCircle.layer.cornerRadius = CGRectGetHeight(cell.viewCircle.frame)/2;
//                [cell.viewCircle setBackgroundColor:[UIColor whiteColor]];
                [cell.viewCircle setBackgroundColor:[UIColor clearColor]];

                [cell.iconFriend setFrame:CGRectMake(0, 0, sizeIcon.width, sizeIcon.height)];
                [cell.iconFriend setContentMode:UIViewContentModeScaleAspectFill];
                [cell.iconFriend setAutoresizingMask:UIViewAutoresizingNone];
                cell.iconFriend.layer.borderWidth = 0.0f;
                [cell.iconFriend setClipsToBounds:YES];
                cell.iconFriend.layer.cornerRadius = CGRectGetHeight(cell.iconFriend.frame)/2;
                
                CGFloat hView = size.height;
                hView = hView < 40 ? 40 : hView;
                
                CGFloat wView = size.width;
                wView = wView < 30 ? 30 : wView;
                
                [cell.viewMain setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), topSpacing, wView + wViewMainPadding, hView)];
//                [cell.viewMain setBackgroundColor:[[self.helperIns colorWithHex:0xf1f1f1] colorWithAlphaComponent:0.3]];
                [cell.viewMain setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
                
                [cell.txtMessageContent setText:_message.strMessage];
                [cell.txtMessageContent setBackgroundColor:[UIColor clearColor]];
                [cell.txtMessageContent setTextContainerInset:UIEdgeInsetsMake(4, 0, 0, 0)];
//                [cell.txtMessageContent setTextColor:[UIColor blackColor]];
                [cell.txtMessageContent setTextColor:[UIColor whiteColor]];
                [cell.txtMessageContent setFont:[self.helperIns getFontLight:15.0f]];
                [cell.txtMessageContent setFrame:CGRectMake(25, (hView / 2) - (size.height / 2), size.width, size.height)];
                
                [cell.lblTime setText:strTime];
                [cell.lblTime setNumberOfLines:0];
                CGSize sizeTimeLabel = [cell.lblTime.text sizeWithFont:[self.helperIns getFontThin:10.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
                [cell.lblTime setTextAlignment:NSTextAlignmentLeft];
//                [cell.lblTime setTextColor:[self.helperIns colorWithHex:0x434343]];
                [cell.lblTime setTextColor:[UIColor whiteColor]];
                [cell.lblTime setFont:[self.helperIns getFontThin:9.0f]];
                [cell.lblTime setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2) + wView + wViewMainPadding + topSpacing, (hView - sizeTimeLabel.height) + topSpacing, sizeTimeLabel.width, sizeTimeLabel.height)];
            }
        
        }else{//me

            [cell.iconFriend setHidden:YES];
            [cell.iconImage setHidden:NO];
            
            if (_lastMessage != nil && _lastMessage.senderID == _message.senderID && _lastMessage.typeMessage == _message.typeMessage) {
                
                CGSize size = [_message.strMessage sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
                size.width += (padding / 2);
                size.height += (padding / 4);
                
                [cell.viewCircle setHidden:YES];
                [cell.viewCircle setFrame:CGRectMake(self.bounds.size.width - (sizeIcon.width + leftSpacing), topSpacing - 5, sizeIcon.width, sizeIcon.height)];
                cell.viewCircle.layer.cornerRadius = CGRectGetHeight(cell.viewCircle.frame)/2;
                [cell.viewCircle setBackgroundColor:[UIColor whiteColor]];
                
                [cell.iconImage setHidden:YES];
                [cell.iconImage setFrame:CGRectMake(0, 0, sizeIcon.width, sizeIcon.height)];
                [cell.iconImage setContentMode:UIViewContentModeScaleAspectFill];
                [cell.iconImage setAutoresizingMask:UIViewAutoresizingNone];
                cell.iconImage.layer.borderWidth = 0.0f;
                //            cell.iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
                [cell.iconImage setClipsToBounds:YES];
                cell.iconImage.layer.cornerRadius = CGRectGetHeight(cell.iconImage.frame)/2;
                
                //            CGFloat hView = size.height + (padding / 2);
                CGFloat hView = size.height;
                hView = hView < 40 ? 40 : hView;
                
                CGFloat wView = size.width + (padding / 4);
                wView = wView < 30 ? 30 : wView;
                
                [cell.viewMain setFrame:CGRectMake(self.bounds.size.width - (wView + wViewMainPadding) - (sizeIcon.width / 2) - leftSpacing, topSpacing - 5, wView + wViewMainPadding, hView)];
                //            [cell.viewMain setBackgroundColor:[self.helperIns colorWithHex:0x00cdd2]];
                [cell.viewMain setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
                
                [cell.txtMessageContent setText:_message.strMessage];
                [cell.txtMessageContent setTextContainerInset:UIEdgeInsetsMake(2, 0, 0, 0)];
//                [cell.txtMessageContent setTextColor:[UIColor whiteColor]];
                cell.txtMessageContent.textColor = [UIColor colorWithRed:255.0f/255.0 green:255.0f/255.0 blue:255.0f/255.0 alpha:1.0];
                [cell.txtMessageContent setBackgroundColor:[UIColor clearColor]];
//                [cell.txtMessageContent setFont:[self.helperIns getFontLight:15.0f]];
                cell.txtMessageContent.font = [self.helperIns getFontLight:15.0f];
                [cell.txtMessageContent setFrame:CGRectMake(4, (hView / 2) - (size.height / 2), wView, size.height)];
                
                [cell.lblTime setText:strTime];
                [cell.lblTime setNumberOfLines:0];
                CGSize sizeTimeLabel = [cell.lblTime.text sizeWithFont:[self.helperIns getFontThin:10.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
                [cell.lblTime setTextAlignment:NSTextAlignmentRight];
                [cell.lblTime setFont:[self.helperIns getFontThin:9.0f]];
//                [cell.lblTime setTextColor:[self.helperIns colorWithHex:0x888888]];
                [cell.lblTime setTextColor:[UIColor whiteColor]];
                CGFloat marginTime = self.bounds.size.width - (wView + wViewMainPadding + (sizeIcon.width / 2) + leftSpacing + sizeTimeLabel.width + topSpacing);
                [cell.lblTime setFrame:CGRectMake(marginTime, (hView - sizeTimeLabel.height), sizeTimeLabel.width, sizeTimeLabel.height)];
            }else{
                
                CGSize size = [_message.strMessage sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
                
//                CGSize size = [_message.strMessage sizeWithFont:[self.helperIns getFontThin:15.0f] forWidth:self.bounds.size.width - 120 lineBreakMode:NSLineBreakByCharWrapping];
                size.width += (padding / 2);
                size.height += (padding / 2);

                [cell.viewCircle setHidden:NO];
                [cell.viewCircle setFrame:CGRectMake(self.bounds.size.width - (sizeIcon.width + leftSpacing), topSpacing, sizeIcon.width, sizeIcon.height)];
                cell.viewCircle.layer.cornerRadius = CGRectGetHeight(cell.viewCircle.frame)/2;
                [cell.viewCircle setBackgroundColor:[UIColor clearColor]];
                
                [cell.iconImage setFrame:CGRectMake(0, 0, sizeIcon.width, sizeIcon.height)];
                [cell.iconImage setContentMode:UIViewContentModeScaleAspectFill];
                [cell.iconImage setAutoresizingMask:UIViewAutoresizingNone];
                cell.iconImage.layer.borderWidth = 0.0f;
                //            cell.iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
                [cell.iconImage setClipsToBounds:YES];
                cell.iconImage.layer.cornerRadius = CGRectGetHeight(cell.iconImage.frame)/2;
                
                //            CGFloat hView = size.height + (padding / 2);
                CGFloat hView = size.height;
                hView = hView < 40 ? 40 : hView;
                
                CGFloat wView = size.width + (padding / 4);
                wView = wView < 30 ? 30 : wView;
                
                [cell.viewMain setFrame:CGRectMake(self.bounds.size.width - (wView + wViewMainPadding) - (sizeIcon.width / 2) - leftSpacing, topSpacing, wView + wViewMainPadding, hView)];
                //            [cell.viewMain setBackgroundColor:[self.helperIns colorWithHex:0x00cdd2]];
                [cell.viewMain setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
                
                [cell.txtMessageContent setText:_message.strMessage];
                [cell.txtMessageContent setTextColor:[UIColor whiteColor]];
                [cell.txtMessageContent sizeThatFits:textSize];
                [cell.txtMessageContent setBackgroundColor:[UIColor clearColor]];
                [cell.txtMessageContent setFont:[self.helperIns getFontLight:15.0f]];
                [cell.txtMessageContent setFrame:CGRectMake(4, (hView / 2) - (size.height / 2), wView, size.height)];
                [cell.txtMessageContent setTextContainerInset:UIEdgeInsetsMake(4, 0, 0, 0)];
                
                [cell.lblTime setText:strTime];
                [cell.lblTime setNumberOfLines:0];
                CGSize sizeTimeLabel = [cell.lblTime.text sizeWithFont:[self.helperIns getFontThin:10.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
                [cell.lblTime setTextAlignment:NSTextAlignmentRight];
                [cell.lblTime setFont:[self.helperIns getFontThin:9.0f]];
//                [cell.lblTime setTextColor:[self.helperIns colorWithHex:0x888888]];
                [cell.lblTime setTextColor:[UIColor whiteColor]];
                CGFloat marginTime = self.bounds.size.width - (wView + wViewMainPadding + (sizeIcon.width / 2) + leftSpacing + sizeTimeLabel.width + topSpacing);
                [cell.lblTime setFrame:CGRectMake(marginTime, (hView - sizeTimeLabel.height) + 5, sizeTimeLabel.width, sizeTimeLabel.height)];
            }
        }
    }
    
    if (_message.typeMessage == 1 || _message.typeMessage == 2) {
        
        NSString *strTime = [NSString stringWithFormat:@"%@\n%@", _message.timeMessage, strStatus];
        
//        NSString *strTime = @"1:04 pm,\nRead";
        CGSize sizeTime = [strTime sizeWithFont:[self.helperIns getFontThin:10] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        sizeTime.width += (padding / 2);
        sizeTime.height += (padding / 4);
        
        [cell.smsImage setHidden:NO];
        [cell.viewMain setHidden:YES];
        [cell.txtMessageContent setHidden:YES];
        
        if (_senderID == _friendID) {//friend
            
            [cell.iconFriend setHidden:NO];
            [cell.iconImage setHidden:YES];
            
            [cell.viewCircle setHidden:NO];
            [cell.viewCircle setFrame:CGRectMake(leftSpacing, topSpacing, sizeIcon.width, sizeIcon.height)];
            cell.viewCircle.layer.cornerRadius = CGRectGetHeight(cell.viewCircle.frame)/2;
//            [cell.viewCircle setBackgroundColor:[UIColor whiteColor]];
            [cell.viewCircle setBackgroundColor:[UIColor clearColor]];

//            [cell.iconFriend setFrame:CGRectMake(self.bounds.size.width - (sizeIcon.width + leftSpacing), topSpacing, sizeIcon.width, sizeIcon.height)];
            [cell.iconFriend setFrame:CGRectMake(0, 0, sizeIcon.width, sizeIcon.height)];

            [cell.iconFriend setContentMode:UIViewContentModeScaleAspectFill];
//            [cell.iconFriend setAutoresizingMask:UIViewAutoresizingNone];
            cell.iconFriend.layer.borderWidth = 0.0f;
            [cell.iconFriend setClipsToBounds:YES];
            cell.iconFriend.layer.cornerRadius = CGRectGetHeight(cell.iconFriend.frame)/2;
            
//            [cell.iconFriend setFrame:CGRectMake(leftSpacing, topSpacing, sizeIcon.width, sizeIcon.height)];
            
//            [cell.iconImage setFrame:CGRectMake(self.bounds.size.width - (sizeIcon.width + leftSpacing), topSpacing, sizeIcon.width, sizeIcon.height)];
//            [cell.iconImage setContentMode:UIViewContentModeScaleAspectFill];
//            [cell.iconImage setAutoresizingMask:UIViewAutoresizingNone];
//            cell.iconImage.layer.borderWidth = 0.0f;
//            [cell.iconImage setClipsToBounds:YES];
//            cell.iconImage.layer.cornerRadius = CGRectGetHeight(cell.iconImage.frame)/2;
            
//            UIImage *img = [UIImage imageWithData:_message.thumnail];
            if (_message.thumnail !=nil) {
                
//                if (_message.isTimeOut) {
//
////                    UIImage *imgBlur = [self.helperIns blurWithImageEffectsRestore:_message.thumnail withRadius:50];
//                    [cell.smsImage setImage: _message.thumnailBlur];
//                    [cell.smsImage setTag:indexPath.row];
//                    [cell.smsImage setContentMode:UIViewContentModeScaleAspectFill];
//                    //            [cell.smsImage setAutoresizingMask:UIViewAutoresizingNone];
//                    [cell.smsImage setClipsToBounds:YES];
//                    [cell.smsImage setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), 5, sizeImage.width, sizeImage.height)];
//
//                    
//                }else{
//                    
//                }
                
                [cell.smsImage setImage: _message.thumnail];
                [cell.smsImage setTag:indexPath.row];
                [cell.smsImage setContentMode:UIViewContentModeScaleAspectFill];
                //            [cell.smsImage setAutoresizingMask:UIViewAutoresizingNone];
                [cell.smsImage setClipsToBounds:YES];
                [cell.smsImage setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), 5, sizeImage.width, sizeImage.height)];

                
            }else{
                
                UIView *loadView = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), 5, sizeImage.width, sizeImage.height)];
                [loadView setBackgroundColor:[UIColor lightGrayColor]];
                [loadView setAlpha:0.8f];
                
                UIImage *imgLoad = [self.helperIns imageWithView:loadView];
                [cell.smsImage setImage: imgLoad];
                [cell.smsImage setTag:indexPath.row];
                [cell.smsImage setContentMode:UIViewContentModeScaleAspectFill];
                //            [cell.smsImage setAutoresizingMask:UIViewAutoresizingNone];
                [cell.smsImage setClipsToBounds:YES];
                [cell.smsImage setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), 5, sizeImage.width, sizeImage.height)];
            }
            
//            [cell.smsImage setFrame:CGRectMake(self.bounds.size.width - (cell.iconImage.bounds.size.width / 2)  - (sizeImage.width + leftSpacing), 5, sizeImage.width, sizeImage.height)];
//            [cell.smsImage setUserInteractionEnabled:YES];
//            [cell.smsImage setTag:indexPath.row];
//            [cell.smsImage setUserInteractionEnabled:YES];
//            
//            UITapGestureRecognizer *tapLogo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
//            [tapLogo setNumberOfTapsRequired:1];
//            [tapLogo setNumberOfTouchesRequired:1];
//            [cell.smsImage addGestureRecognizer:tapLogo];
            
            [cell.smsImage setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapLocation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocation:)];
            [tapLocation setNumberOfTapsRequired:1];
            [tapLocation setNumberOfTouchesRequired:1];
            [cell.smsImage addGestureRecognizer:tapLocation];
            
            [cell.lblTime setText:strTime];
            [cell.lblTime setNumberOfLines:0];
            CGSize sizeTimeLabel = [cell.lblTime.text sizeWithFont:[self.helperIns getFontThin:10] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
            [cell.lblTime setTextAlignment:NSTextAlignmentLeft];
//            [cell.lblTime setTextColor:[self.helperIns colorWithHex:0x888888]];
            [cell.lblTime setTextColor:[UIColor whiteColor]];
            [cell.lblTime setFont:[self.helperIns getFontThin:9.0f]];
            [cell.lblTime setFrame:CGRectMake((leftSpacing + (sizeIcon.width / 2) + sizeImage.width + topSpacing), (cell.smsImage.bounds.size.height - sizeTimeLabel.height) + topSpacing, sizeTimeLabel.width, sizeTimeLabel.height)];
            
//            [cell.lblTime setFrame:CGRectMake(self.bounds.size.width - (leftSpacing + (sizeIcon.width / 2) + sizeImage.width + topSpacing + sizeTimeLabel.width), (cell.smsImage.bounds.size.height - sizeTimeLabel.height) + topSpacing, sizeTimeLabel.width, sizeTimeLabel.height)];
            
        }else{//me
            
            [cell.iconFriend setHidden:YES];
            [cell.iconImage setHidden:NO];
            
            [cell.viewCircle setHidden:NO];
            [cell.viewCircle setFrame:CGRectMake(self.bounds.size.width - (sizeIcon.width + leftSpacing), topSpacing, sizeIcon.width, sizeIcon.height)];
            cell.viewCircle.layer.cornerRadius = CGRectGetHeight(cell.viewCircle.frame)/2;
//            [cell.viewCircle setBackgroundColor:[UIColor whiteColor]];
            [cell.viewCircle setBackgroundColor:[UIColor clearColor]];
            
            [cell.iconImage setFrame:CGRectMake(0, 0, sizeIcon.width, sizeIcon.height)];
            [cell.iconImage setContentMode:UIViewContentModeScaleAspectFill];
            [cell.iconImage setAutoresizingMask:UIViewAutoresizingNone];
            cell.iconImage.layer.borderWidth = 0.0f;
            [cell.iconImage setClipsToBounds:YES];
            cell.iconImage.layer.cornerRadius = CGRectGetHeight(cell.iconImage.frame)/2;

            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                //move to an asynchronous thread to fetch your image data
//                UIImage* thumbnail = _message.thumnail; //get thumbnail from photo id dictionary (fastest)
//                if (!thumbnail) {    //if it's not in the dictionary
//                    thumbnail = _message.thumnail;     //get it from the cache  (slower)
//                }
//                
//                if (thumbnail) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //return to the main thread to update the UI
//                        if ([[tableView indexPathsForVisibleRows] containsObject:indexPath]) {
//
//                            [[cell smsImage] setImage:thumbnail];
//                            CGFloat wSmsImage = self.bounds.size.width - (leftSpacing * 2 + (sizeIcon.width / 2) + sizeIcon.width);
//                            [cell.smsImage setFrame:CGRectMake(self.bounds.size.width - (cell.iconImage.bounds.size.width / 2)  - (wSmsImage + leftSpacing), 5, wSmsImage, sizeImage.height)];
//                            [cell.smsImage setTag:indexPath.row];
//                            [cell.smsImage setUserInteractionEnabled:YES];
//                        }
//                    });
//                }
//                
//            });
            
//            [cell.smsImage setImage: _message.thumnail];
////            CGFloat wSmsImage = self.bounds.size.width - (leftSpacing * 2 + (sizeIcon.width / 2) + sizeIcon.width);
//            [cell.smsImage setFrame:CGRectMake(self.bounds.size.width - (cell.iconImage.bounds.size.width / 2)  - (sizeImage.width + leftSpacing), 5, sizeImage.width, sizeImage.height)];
//            [cell.smsImage setTag:indexPath.row];
//            [cell.smsImage setUserInteractionEnabled:YES];
//            
//            [cell.smsImage setContentMode:UIViewContentModeScaleAspectFill];
//            [cell.smsImage setClipsToBounds:YES];
            
            if (_message.thumnail !=nil) {
                [cell.smsImage setImage: _message.thumnail];
                [cell.smsImage setTag:indexPath.row];
                [cell.smsImage setContentMode:UIViewContentModeScaleAspectFill];
                //            [cell.smsImage setAutoresizingMask:UIViewAutoresizingNone];
                [cell.smsImage setClipsToBounds:YES];
//                [cell.smsImage setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), 5, sizeImage.width, sizeImage.height)];
                [cell.smsImage setFrame:CGRectMake(self.bounds.size.width - (cell.iconImage.bounds.size.width / 2)  - (sizeImage.width + leftSpacing), 5, sizeImage.width, sizeImage.height)];
                [cell.smsImage setTag:indexPath.row];
                
            }else{
                UIView *loadView = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), 5, sizeImage.width, sizeImage.height)];
                [loadView setBackgroundColor:[UIColor lightGrayColor]];
                [loadView setAlpha:0.8f];
                
                UIImage *imgLoad = [self.helperIns imageWithView:loadView];
                [cell.smsImage setImage: imgLoad];
                [cell.smsImage setTag:indexPath.row];
                [cell.smsImage setContentMode:UIViewContentModeScaleAspectFill];
                //            [cell.smsImage setAutoresizingMask:UIViewAutoresizingNone];
                [cell.smsImage setClipsToBounds:YES];
//                [cell.smsImage setFrame:CGRectMake(leftSpacing + (sizeIcon.width / 2), 5, sizeImage.width, sizeImage.height)];
                [cell.smsImage setFrame:CGRectMake(self.bounds.size.width - (cell.iconImage.bounds.size.width / 2)  - (sizeImage.width + leftSpacing), 5, sizeImage.width, sizeImage.height)];
                [cell.smsImage setTag:indexPath.row];
            }
            
            [cell.smsImage setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapLocation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocation:)];
            [tapLocation setNumberOfTapsRequired:1];
            [tapLocation setNumberOfTouchesRequired:1];
            [cell.smsImage addGestureRecognizer:tapLocation];

            [cell.lblTime setText:strTime];
            [cell.lblTime setNumberOfLines:0];
            CGSize sizeTimeLabel = [cell.lblTime.text sizeWithFont:[self.helperIns getFontThin:10] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
            [cell.lblTime setTextAlignment:NSTextAlignmentRight];
//            [cell.lblTime setTextColor:[self.helperIns colorWithHex:0x888888]];
            [cell.lblTime setTextColor:[UIColor whiteColor]];
            [cell.lblTime setFont:[self.helperIns getFontThin:9.0f]];
            [cell.lblTime setFrame:CGRectMake(self.bounds.size.width - (leftSpacing + (sizeIcon.width / 2) + sizeImage.width + topSpacing + sizeTimeLabel.width), (cell.smsImage.bounds.size.height - sizeTimeLabel.height) + topSpacing, sizeTimeLabel.width, sizeTimeLabel.height)];
        }
    }
    
    return cell;
}

//- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return YES;
//}
//
//- (BOOL) tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
//    if (action == @selector(copy:)) {
//        return YES;
//    }
//    
//    return NO;
//}

//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    if (action == @selector(copy:)) {
//        [UIPasteboard generalPasteboard].string =
//    }
//}

- (void) tapImage:(UITapGestureRecognizer *)recognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchTableView" object:self];
    
    UIImageView *imgView = (UIImageView*)[recognizer view];
    int row = (int)imgView.tag;

    UIImage *img = nil;
//    if ([[self.friendIns.friendMessage objectAtIndex:row] senderID] > 0) {
        img = [UIImage imageWithData:[[self.friendIns.friendMessage objectAtIndex:row] dataImage]];
//    }else{
//        NSData *dataImage = [self.helperIns decodeBase64:[[self.friendIns.friendMessage objectAtIndex:row] strMessage]];
//        img = [UIImage imageWithData:dataImage];
//    }
    
//    FullImageView *imgFull = [[FullImageView alloc] initWithData:img withFrame:[[self superview] bounds]];
//    [imgFull setFrame: [[self superview] bounds]];
//    [[self superview] addSubview:imgFull];
//    [imgFull showImage];
}

- (void) reloadTableView{
    CGFloat y = self.contentSize.height - self.bounds.size.height;
    if (self.contentOffset.y >= (lroundf(y * 100) / 100)) {
        if (inScroll == NO) {
            [self reloadData];
            //scroll to bottom
            double y = self.contentSize.height - self.bounds.size.height;
            CGPoint bottomOffset = CGPointMake(0, y);
            
            if (y > -self.contentInset.top)
                [self setContentOffset:bottomOffset animated:NO];            
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchTableView" object:self];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchEndTableView" object:self];
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    inScroll = YES;
    NSLog(@"willbegindecelerating");
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"end deceleration");
    inScroll = NO;
    [self reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endDeceleration" object:self];
    
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    inScroll = YES;
    NSLog(@"begin dragging");
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    inScroll = NO;
    [self reloadData];
    NSLog(@"end dragging");
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    inScroll = NO;
    [self reloadData];
    NSLog(@"end scrolling animation");
}

#pragma -mark UILongPressGestureRecognizer
- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        SCMessageTableViewCell *cell = (SCMessageTableViewCell *)recognizer.view;
        [cell becomeFirstResponder];
        rowAction = [self indexPathForCell:cell];
        
//        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copy:)];
//        UIMenuItem *approve = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(delete:)];
        UIMenuItem *deny = [[UIMenuItem alloc] initWithTitle:@"Forward" action:@selector(forward:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:deny, nil]];
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setArrowDirection:UIMenuControllerArrowDown];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)copy:(id)sender {
    NSLog(@"Cell was copy");
}

- (void)delete:(id)sender {
    NSLog(@"Cell was delete");
    
    NSString *actionSheetTitle = @"Please Select Action"; //Action Sheet Title
    NSString *destructiveTitle = @"Delete"; //Action Sheet Button Titles
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:nil, nil];
    
    [actionSheet showInView:self];

}

- (void)forward:(id)sender {
    NSLog(@"Cell was forward");
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // These are selector(s) that we mentioned in UIMenuItem action
    if (action == @selector(copy:) || action == @selector(delete:) || action == @selector(forward:)) {
        return YES;
    }
    return NO;
}

- (void) setClearData:(BOOL)_isClear{
    clearData = _isClear;
}

- (void) tapLocation:(UITapGestureRecognizer *)recognizer{
    
    UIImageView *imgView = (UIImageView*)[recognizer view];
    int row = (int)imgView.tag;
    
    ChatView *parent = (ChatView*)[self superview];
    
    Messenger *_messenger = [self.friendIns.friendMessage objectAtIndex:row];
    UIImage *img = [UIImage imageWithData:_messenger.dataImage];
    if (_messenger.typeMessage == 1) {
        
        ImageFullView *imgFull = [[ImageFullView alloc] initWithFrame:CGRectMake(0, [parent getHeaderHeight], self.bounds.size.width, parent.bounds.size.height - [parent getHeaderHeight])];
        [imgFull initWithData:img];
        [imgFull setTag:100000];
        
        [[self superview] addSubview:imgFull];
        
    }else{
        
        AppleMapView *newAppleView = [[AppleMapView alloc] initWithFrame:CGRectMake(0, [parent getHeaderHeight], self.bounds.size.width, parent.bounds.size.height - [parent getHeaderHeight])];
        [newAppleView setTag:200000];
        if (_messenger.senderID > 0) {
            [newAppleView addAnnotation:[_messenger.latitude floatValue] withLongitude:[_messenger.longitude floatValue] withFriend:self.friendIns];
        }
        
        [newAppleView addAnnotation:[_messenger.latitude floatValue] withLongitude:[_messenger.longitude floatValue] withFriend:self.friendIns];
        
        [[self superview] addSubview:newAppleView];
        
    }
}

#pragma -mark UIActionSheet Delegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"button index: %i", (int)buttonIndex);
            Messenger *_messenger = [self.friendIns.friendMessage objectAtIndex:rowAction.row];
            
            if (self.scMessageTableViewDelegate && [self.scMessageTableViewDelegate respondsToSelector:@selector(notifyDeleteMessage:)]){
                [self.scMessageTableViewDelegate notifyDeleteMessage:_messenger];
            }
        }
            break;
            
        default:
            break;
    }
}
@end
