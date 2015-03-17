//
//  SCMessageGroupTableViewV2.m
//  Cozi
//
//  Created by ChjpCoj on 3/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCMessageTableViewV3.h"
#import "ChatView.h"
#import "SCChatViewV2ViewController.h"

@implementation SCMessageTableViewV3

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

const CGFloat leftSpacingV3 = 10;
const CGSize sizeIconV3 = { 40, 40 };
const CGFloat topSpacingV3 = 10.0f;
const CGFloat wViewMainPaddingV3 = 20.0f;

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
    clearData = NO;
    
    padding = 20.0f;
    wMax = self.bounds.size.width - 110;
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView *loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 80, 160)];
    [loadView setBackgroundColor:[UIColor lightGrayColor]];
    [loadView setAlpha:0.8f];
    
    defaultImage = [helperIns imageWithView:loadView];
    
    imgIsRead = [helperIns getImageFromSVGName:@"icon-EyeGrey-v2.svg"];
    imgIsRecive = [helperIns getImageFromSVGName:@"icon-TickGrey-v3.svg"];
}

#pragma -mark UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (clearData) {
        return 0;
    }else{
        if (self.recentIns.typeRecent == 0) {
            return [self.recentIns.friendIns.friendMessage count];
        }
        
        if (self.recentIns.typeRecent == 1) {
            return [self.recentIns.messengerRecent count];
        }
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Messenger *_message;
    if (self.recentIns.typeRecent == 0) {
        _message = [self.recentIns.friendIns.friendMessage objectAtIndex:indexPath.row];
    }
    
    if (self.recentIns.typeRecent == 1) {
        _message = [self.recentIns.messengerRecent objectAtIndex:indexPath.row];
    }
    
    if (_message.typeMessage == 0) {
        
        NSString *msg = [[_message strMessage] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CGSize textSize = { wMax, CGFLOAT_MAX };
        
        CGSize size = [msg boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:16.0f]} context:nil].size;
        CGSize sizeTime = [@"1:04pm" boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:9.0f]} context:nil].size;
        
        size.height += sizeTime.height;
        
        size.height += padding;
        size.height = size.height < 60 ? 60 : size.height;
        
        return size.height;
    }else{
        
        return 170;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellMessenger";
    SCMessageTableViewCellV2 *scCell = nil;
    
    Messenger *_message = nil;
    Messenger *_lastMessage = nil;
    
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    
    if (self.recentIns.typeRecent == 0) {
        if (lastIndexPath.row >= 0) {
            _lastMessage = [self.recentIns.friendIns.friendMessage objectAtIndex:lastIndexPath.row];
        }

        _message = [self.recentIns.friendIns.friendMessage objectAtIndex:indexPath.row];
    }
    
    if (self.recentIns.typeRecent == 1) {
        if (lastIndexPath.row >= 0) {
            _lastMessage = [self.recentIns.messengerRecent objectAtIndex:lastIndexPath.row];
        }
        
        _message = [self.recentIns.messengerRecent objectAtIndex:indexPath.row];
    }
    
    scCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCMessageTableViewCellV2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [scCell addGestureRecognizer:recognizer];
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [tapImage setNumberOfTapsRequired:1];
        [tapImage setNumberOfTouchesRequired:1];
        [scCell.viewImage addGestureRecognizer:tapImage];
        
        [scCell.btnDownloadImage addTarget:self action:@selector(btnDownloadImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [scCell setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
    
    if (self.recentIns.typeRecent == 0) {
        if (self.recentIns.friendIns.thumbnail) {
            [scCell.iconFriend setImage:self.recentIns.friendIns.thumbnail];
        }else{
            scCell.iconFriend.image = [helperIns getDefaultAvatar];
            
            if (![self.recentIns.friendIns.urlThumbnail isEqualToString:@""]) {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.recentIns.friendIns.urlThumbnail] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (image && finished) {
                        self.recentIns.friendIns.thumbnail = image;
                        [scCell.iconFriend setImage:image];
                    }
                }];
            }
        }
    }
    
    if (self.recentIns.typeRecent == 1) {
        Friend *friend = [self getFriendWithFriendID:_message.friendID];
    }
    
    UIImage *imgAvatarMe = storeIns.user.thumbnail;
    
    [scCell.iconImage setImage:imgAvatarMe];
    
    int _senderID = _message.senderID;
    int _friendID = _message.friendID;
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"hh:mm a"];
    
    if (_message.typeMessage == 0) {        //Text Message
        
        if (_senderID == _friendID) {       //Message of friend
            
            //hidden my avatar
            [scCell.iconImage setHidden:YES];
            [scCell.iconFriend setHidden:NO];
            
            if (_lastMessage != nil && _lastMessage.senderID == _message.senderID && _lastMessage.typeMessage == _message.typeMessage) {
                
                [self renderCellFriend:scCell withMessenger:_message withAvatar:NO withIndexPath:indexPath];
                
            }else{
                
                [self renderCellFriend:scCell withMessenger:_message withAvatar:YES withIndexPath:indexPath];
                
            }
            
        }else{  //My Message
            
            [scCell.iconFriend setHidden:YES];
            [scCell.iconImage setHidden:NO];
            
            if (_lastMessage != nil && _lastMessage.senderID == _message.senderID && _lastMessage.typeMessage == _message.typeMessage) {
                
                [self renderCell:scCell withMessenger:_message withAvatar:NO withIndexPaths:indexPath];
                
            }else{
                
                [self renderCell:scCell withMessenger:_message withAvatar:YES withIndexPaths:indexPath];
                
            }
            
        }
    }
    
    if (_message.typeMessage == 1 || _message.typeMessage == 2) {
        if (_senderID == _friendID) {//friend
            
            [self renderImageCellFriend:scCell withMessenger:_message withIndex:indexPath];
            
        }else{
            
            [self renderImageCell:scCell withMessenger:_message withIndexPath:indexPath];
            
        }
    }
    
    return scCell;
}

- (void) renderCell:(SCMessageTableViewCellV2*)scCell withMessenger:(Messenger*)_message withAvatar:(BOOL)_enableAvatar withIndexPaths:(NSIndexPath*)_indexPath{
    CGSize textSize = { wMax, CGFLOAT_MAX };
    
    //hidden my avatar
    [scCell.iconFriend setHidden:YES];
    [scCell.iconImage setHidden:NO];
    
    [scCell.vMainShadow setHidden:NO];
    [scCell.viewMain setHidden:NO];
    [scCell.vTriangle setHidden:YES];
    [scCell.blackTriangle setHidden:NO];
    
    [scCell.lblTimeMessengerImage setHidden:YES];
    [scCell.imgStatusMessengerImage setHidden:YES];
    
    [scCell.viewImage setHidden:YES];
    [scCell.vMessengerImage setHidden:YES];
    [scCell.vMessengerImageFriend setHidden:YES];
    
    [scCell.vMessengerImageShadow setHidden:YES];
    
    if (_enableAvatar) {
        [scCell.iconImage setHidden:NO];
    }else{
        [scCell.iconImage setHidden:YES];
        [scCell.blackTriangle setHidden:YES];
    }
    
    CGSize sizeMessage;
    if ([_message.strMessage isEqualToString:@"(Ping)"]) {
        
        UIFont *font        = [helperIns getFontLight:16.0f];
        sizeMessage = [@"YOU PINGED" boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
        
    }else{
        
        UIFont *font        = [helperIns getFontLight:16.0f];
        sizeMessage = [_message.strMessage boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    
    CGSize sizeTime = [_message.timeMessage boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:9.0f]} context:nil].size;
    
    CGSize size = sizeMessage;
    
    size.height += sizeTime.height;
    
    size.width += padding / 2;
    size.height += padding / 2;
    
    CGFloat hView = size.height;
    hView = hView < 50 ? 50 : hView;
    
    CGFloat wView = size.width;
    wView = wView < 70 ? 70 : wView;
    
    CGFloat xViewMain = self.bounds.size.width - (leftSpacingV3 + sizeIconV3.width + leftSpacingV3 + wView + wViewMainPaddingV3);
    
    [scCell.vMainShadow setFrame:CGRectMake(xViewMain, topSpacingV3 / 2, wView + (wViewMainPaddingV3), hView)];
    [scCell.vMainShadow setBackgroundColor:[UIColor blackColor]];
    
    [scCell.viewMain setFrame:CGRectMake(xViewMain, topSpacingV3 / 2, wView + (wViewMainPaddingV3), hView)];
    [scCell.viewMain setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor3"]]];
    
    CGFloat yMessage = (hView / 2) - (sizeMessage.height / 2 + sizeTime.height / 2);
    if ([_message.strMessage isEqualToString:@"(Ping)"]) {
        scCell.txtMessageContent.text = @"YOU PINGED";
        [scCell.txtMessageContent setTextColor:[UIColor whiteColor]];
        [scCell.txtMessageContent setFrame:CGRectMake(padding / 2, yMessage, scCell.viewMain.bounds.size.width - padding, sizeMessage.height)];
        
    }else{
        scCell.txtMessageContent.text = _message.strMessage;
        [scCell.txtMessageContent setTextColor:[UIColor whiteColor]];
        [scCell.txtMessageContent setFrame:CGRectMake(padding / 2, yMessage, scCell.viewMain.bounds.size.width - padding, sizeMessage.height)];
    }
    
    [scCell.lblTime setText:_message.timeMessage];
    [scCell.lblTime setNumberOfLines:0];
    [scCell.lblTime setTextAlignment:NSTextAlignmentLeft];
//    [scCell.lblTime setTextColor:[UIColor colorWithRed:107.0f/255.0f green:107.0f/255.0f blue:107.0f/255.0f alpha:1]];
    [scCell.lblTime setTextColor:[UIColor whiteColor]];
    [scCell.lblTime setFont:[helperIns getFontLight:9.0f]];
    [scCell.lblTime setFrame:CGRectMake(padding / 2, scCell.txtMessageContent.frame.origin.y + sizeMessage.height, sizeTime.width, sizeTime.height)];
    
    [scCell.blackTriangle setFrame:CGRectMake(xViewMain + scCell.viewMain.bounds.size.width, topSpacingV3 + (sizeIconV3.height / 2) - 5, 10, 10)];
    
    //Set Status Image
    int _senderID = _message.senderID;
    int _friendID = _message.friendID;
    
    if (_message.statusMessage == 0) {
        
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            if (self.scMessageGroupTableViewDelegate && [self.scMessageGroupTableViewDelegate respondsToSelector:@selector(sendIsReadMessageGroup:withKeyMessage:withTypeMessage:)]) {
                [self.scMessageGroupTableViewDelegate sendIsReadMessageGroup:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
            }
            //            strStatus = @"Read";
            //change image status - Read
            [scCell.imgStatusMessage setImage:imgIsRead];
            
            [_message setStatusMessage:2];
            [storeIns updateStatusMessageFriendWithKey:_friendID withMessageID:_message.keySendMessage withStatus:2];
        }else{
            //            strStatus = @"Recive";
            [scCell.imgStatusMessage setImage:imgIsRecive];
        }
    }
    
    if (_message.statusMessage == 2) {
        //        strStatus = @"Read";
        [scCell.imgStatusMessage setImage:imgIsRead];
    }
    
    [scCell.imgStatusMessage setFrame:CGRectMake(scCell.lblTime.frame.origin.x + scCell.lblTime.bounds.size.width, scCell.lblTime.frame.origin.y - 3, scCell.lblTime.bounds.size.height + 6, scCell.lblTime.bounds.size.height + 6)];
    
}

- (void) renderCellFriend:(SCMessageTableViewCellV2*)scCell withMessenger:(Messenger*)_message withAvatar:(BOOL)_enableAvatar withIndexPath:(NSIndexPath*)_indexPath{
    CGSize textSize = { wMax, CGFLOAT_MAX };
    
    //hidden my avatar
    [scCell.iconImage setHidden:YES];
    [scCell.iconFriend setHidden:NO];
    
    [scCell.vMainShadow setHidden:NO];
    [scCell.viewMain setHidden:NO];
    [scCell.vTriangle setHidden:NO];
    [scCell.blackTriangle setHidden:YES];
    
    [scCell.lblTimeMessengerImage setHidden:YES];
    [scCell.imgStatusMessengerImage setHidden:YES];
    
    [scCell.viewImage setHidden:YES];
    [scCell.vMessengerImage setHidden:YES];
    [scCell.vMessengerImageFriend setHidden:YES];
    [scCell.vMessengerImageShadow setHidden:YES];
    
    if (_enableAvatar) {
        [scCell.iconFriend setHidden:NO];
    }else{
        [scCell.iconFriend setHidden:YES];
        [scCell.vTriangle setHidden:YES];
    }
    
    CGSize sizeMessage;
    if ([_message.strMessage isEqualToString:@"(Ping)"]) {
        
        sizeMessage = [@"PINGED" boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:16.0f]} context:nil].size;
    }else{
        
        sizeMessage = [_message.strMessage boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:16.0f]} context:nil].size;
    }
    
    //    CGSize sizeTime = { 44.2202148, 14.5073242 };
    CGSize sizeTime = [_message.timeMessage boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:9.0f]} context:nil].size;
    
    CGSize size = sizeMessage;
    
    size.height += sizeTime.height;
    
    size.width += padding / 2;
    size.height += padding / 2;
    
    CGFloat hView = size.height;
    hView = hView < 50 ? 50 : hView;
    
    CGFloat wView = size.width;
    wView = wView < 70 ? 70 : wView;
    
    CGFloat xViewMain = leftSpacingV3 + sizeIconV3.width + leftSpacingV3;
    
    [scCell.vMainShadow setFrame:CGRectMake(xViewMain, topSpacingV3 / 2, wView + (wViewMainPaddingV3), hView)];
    [scCell.vMainShadow setBackgroundColor:[UIColor whiteColor]];
    
    [scCell.viewMain setFrame:CGRectMake(xViewMain, topSpacingV3 / 2, wView + (wViewMainPaddingV3), hView)];
    [scCell.viewMain setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat yMessage = (hView / 2) - (sizeMessage.height / 2 + sizeTime.height / 2);
    if ([_message.strMessage isEqualToString:@"(Ping)"]) {
        scCell.txtMessageContent.text = @"PINGED";
        [scCell.txtMessageContent setTextColor:[UIColor blackColor]];
        [scCell.txtMessageContent setFrame:CGRectMake(padding / 2, yMessage, scCell.viewMain.bounds.size.width - padding, sizeMessage.height)];
    }else{
        scCell.txtMessageContent.text = _message.strMessage;
        [scCell.txtMessageContent setTextColor:[UIColor blackColor]];
        [scCell.txtMessageContent setFrame:CGRectMake(padding / 2, yMessage, scCell.viewMain.bounds.size.width - padding, sizeMessage.height)];
    }
    
    [scCell.lblTime setText:_message.timeMessage];
    [scCell.lblTime setNumberOfLines:0];
    [scCell.lblTime setTextAlignment:NSTextAlignmentLeft];
    [scCell.lblTime setTextColor:[UIColor lightGrayColor]];
    //    [scCell.lblTime setFont:[helperIns getFontLight:9.0f]];
    [scCell.lblTime setFrame:CGRectMake(padding / 2, scCell.txtMessageContent.frame.origin.y + scCell.txtMessageContent.bounds.size.height, sizeTime.width, sizeTime.height)];
    
    [scCell.vTriangle setFrame:CGRectMake(xViewMain - 10, topSpacingV3 + (sizeIconV3.height / 2) - 5, 10, 10)];
    
    //Set Status Image
    int _senderID = _message.senderID;
    int _friendID = _message.friendID;
    
    if (_message.statusMessage == 0) {
        
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            if (self.scMessageGroupTableViewDelegate && [self.scMessageGroupTableViewDelegate respondsToSelector:@selector(sendIsReadMessageGroup:withKeyMessage:withTypeMessage:)]) {
                [self.scMessageGroupTableViewDelegate sendIsReadMessageGroup:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
            }
            
            [scCell.imgStatusMessage setImage:imgIsRead];
            
            [_message setStatusMessage:2];
            [storeIns updateStatusMessageFriendWithKey:_friendID withMessageID:_message.keySendMessage withStatus:2];
        }else{
            [scCell.imgStatusMessage setImage:imgIsRecive];
        }
    }
    
    if (_message.statusMessage == 2) {
        [scCell.imgStatusMessage setImage:imgIsRead];
    }
    
    [scCell.imgStatusMessage setFrame:CGRectMake(scCell.lblTime.frame.origin.x + scCell.lblTime.bounds.size.width, scCell.lblTime.frame.origin.y - 3, scCell.lblTime.bounds.size.height + 6, scCell.lblTime.bounds.size.height + 6)];
}

- (void) renderImageCell:(SCMessageTableViewCellV2*)scCell withMessenger:(Messenger*)_message withIndexPath:(NSIndexPath*)_indexPath{
    
    CGSize textSize = { wMax, CGFLOAT_MAX };
    [scCell.iconFriend setHidden:YES];
    [scCell.iconImage setHidden:NO];
    
    [scCell.lblTimeMessengerImage setHidden:NO];
    [scCell.imgStatusMessengerImage setHidden:NO];
    
    [scCell.viewMain setHidden:YES];
    [scCell.vMainShadow setHidden:YES];
    
    [scCell.vTriangle setHidden:YES];
    [scCell.blackTriangle setHidden:YES];
    [scCell.viewImage setHidden:NO];
    [scCell.vMessengerImage setHidden:NO];
    [scCell.vMessengerImageShadow setHidden:NO];
    [scCell.vMessengerImageFriend setHidden:YES];
    [scCell.btnDownloadImage setHidden:YES];
    
    //    CGSize sizeTime = { 44.2202148, 14.5073242 };//font Light size 11
    CGSize sizeTime = [_message.timeMessage boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:9.0f]} context:nil].size;
    
    CGFloat wViewMessenger = self.bounds.size.width - (leftSpacingV3 + sizeIconV3.width + leftSpacingV3 + leftSpacingV3 + leftSpacingV3 / 2);
    CGFloat xViewMessenger = self.bounds.size.width - (leftSpacingV3 + sizeIconV3.width + leftSpacingV3 / 2 + wViewMessenger);
    
    [scCell.vMessengerImageShadow setFrame:CGRectMake(xViewMessenger, topSpacingV3 / 2, scCell.vMessengerImageShadow.bounds.size.width, scCell.vMessengerImageShadow.bounds.size.height)];
    
    [scCell.vMessengerImage setFrame:CGRectMake(xViewMessenger, topSpacingV3 / 2, wViewMessenger, 160)];
    
    scCell.vMessengerImage.imgView.image = nil;
    
    [scCell.viewImage setFrame:CGRectMake(xViewMessenger, topSpacingV3 / 2, scCell.viewImage.bounds.size.width, scCell.viewImage.bounds.size.height)];
    
    scCell.vMessengerImage.imgView.image = defaultImage;
    
    if (_message.thumnail) {
        scCell.vMessengerImage.imgView.image = _message.thumnail;
    }else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *imgMessenger = [helperIns loadImage:_message.keySendMessage];
            
            if (imgMessenger) {
                
                UIImage *newImageSize = [helperIns resizeImage:imgMessenger resizeSize:CGSizeMake(imgMessenger.size.width / 2, imgMessenger.size.height / 2)];
                _message.thumnail = newImageSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    scCell.vMessengerImage.imgView.image = _message.thumnail;
                });
                
            }else{
                
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_message.urlImage] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    if (image && finished) {
                        
                        UIImage *newImageSize = [helperIns resizeImage:image resizeSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
                        _message.thumnail = newImageSize;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            scCell.vMessengerImage.imgView.image = _message.thumnail;
                        });
                        
                        [helperIns saveImageToDocument:image withName:_message.keySendMessage];
                        
                    }
                    
                }];
            }
            
        });
        
    }
    
    [scCell.lblTimeMessengerImage setText:_message.timeMessage];
    [scCell.lblTimeMessengerImage setFrame:CGRectMake(scCell.vMessengerImage.frame.origin.x + 10, scCell.vMessengerImage.bounds.size.height - sizeTime.height, sizeTime.width, sizeTime.height)];
    
    [scCell.btnDownloadImage setTag:_indexPath.row];
    
    int _senderID = _message.senderID;
    int _friendID = _message.friendID;
    
    if (_message.statusMessage == 0) {
        
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            if (self.scMessageGroupTableViewDelegate && [self.scMessageGroupTableViewDelegate respondsToSelector:@selector(sendIsReadMessageGroup:withKeyMessage:withTypeMessage:)]) {
                [self.scMessageGroupTableViewDelegate sendIsReadMessageGroup:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
            }
            
            [scCell.imgStatusMessengerImage setImage:imgIsRead];
            
            [_message setStatusMessage:2];
            [storeIns updateStatusMessageFriendWithKey:_friendID withMessageID:_message.keySendMessage withStatus:2];
        }else{
            [scCell.imgStatusMessengerImage setImage:imgIsRecive];
        }
    }
    
    if (_message.statusMessage == 2) {
        [scCell.imgStatusMessengerImage setImage:imgIsRead];
    }
    
    [scCell.imgStatusMessengerImage setFrame:CGRectMake(scCell.lblTimeMessengerImage.frame.origin.x + sizeTime.width, scCell.lblTimeMessengerImage.frame.origin.y - 3, sizeTime.height + 6, sizeTime.height + 6)];
}

- (void) renderImageCellFriend:(SCMessageTableViewCellV2*)scCell withMessenger:(Messenger*)_message withIndex:(NSIndexPath*)_indexPath{
    
    CGSize textSize = { wMax, CGFLOAT_MAX };
    
    [scCell.iconFriend setHidden:NO];
    [scCell.iconImage setHidden:YES];
    
    [scCell.lblTimeMessengerImage setHidden:NO];
    [scCell.imgStatusMessengerImage setHidden:NO];
    
    [scCell.viewMain setHidden:YES];
    [scCell.vMainShadow setHidden:YES];
    [scCell.vTriangle setHidden:YES];
    [scCell.blackTriangle setHidden:YES];
    [scCell.viewImage setHidden:NO];
    [scCell.vMessengerImage setHidden:YES];
    [scCell.vMessengerImageShadow setHidden:NO];
    [scCell.vMessengerImageFriend setHidden:NO];
    [scCell.btnDownloadImage setHidden:NO];
    
    CGSize sizeTime = [_message.timeMessage boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:9.0f]} context:nil].size;
    
    CGFloat wViewMessenger = self.bounds.size.width - (leftSpacingV3 + sizeIconV3.width + leftSpacingV3 + leftSpacingV3 + leftSpacingV3 / 2);
    CGFloat xViewImageShadow = leftSpacingV3 + sizeIconV3.width + leftSpacingV3;
    [scCell.vMessengerImageShadow setFrame:CGRectMake(xViewImageShadow, topSpacingV3 / 2, scCell.vMessengerImageShadow.bounds.size.width, scCell.vMessengerImageShadow.bounds.size.height)];
    
    [scCell.vMessengerImageFriend setFrame:CGRectMake(leftSpacingV3 + sizeIconV3.width + leftSpacingV3 / 2, topSpacingV3 / 2, wViewMessenger, 160)];
    
    scCell.vMessengerImageFriend.imgView.image = defaultImage;
    
    if (_message.thumnail) {
        scCell.vMessengerImageFriend.imgView.image = _message.thumnail;
    }else{
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *subKey = [_message.urlImage componentsSeparatedByString:@"/"];
            UIImage *imgMessenger = [helperIns loadImage:[subKey lastObject]];
            
            if (imgMessenger) {
                if (_message.typeMessage == 1) {
                    UIImage *newImageSize = [helperIns resizeImage:imgMessenger resizeSize:CGSizeMake(imgMessenger.size.width / 4, imgMessenger.size.height / 4)];
                    UIImage *imgBlur = [newImageSize applyLightEffect];
                    _message.thumnail = imgBlur;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        scCell.vMessengerImageFriend.imgView.image = _message.thumnail;
                    });
                }
                
                if (_message.typeMessage == 2) {
                    UIImage *newImageSize = [helperIns resizeImage:imgMessenger resizeSize:CGSizeMake(imgMessenger.size.width / 2, imgMessenger.size.height / 2)];
                    _message.thumnail = newImageSize;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        scCell.vMessengerImageFriend.imgView.image = _message.thumnail;
                    });
                }
                
                
            }else{
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_message.urlImage] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    if (image && finished) {
                        if (_message.typeMessage == 1) {
                            UIImage *newImageSize = [helperIns resizeImage:image resizeSize:CGSizeMake(image.size.width / 4, image.size.height / 4)];
                            UIImage *imgBlur = [newImageSize applyLightEffect];
                            _message.thumnail = imgBlur;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                scCell.vMessengerImageFriend.imgView.image = _message.thumnail;
                            });
                            
                            NSArray *subKey = [_message.urlImage componentsSeparatedByString:@"/"];
                            [helperIns saveImageToDocument:image withName:[subKey lastObject]];
                        }
                        
                        if (_message.typeMessage == 2) {
                            UIImage *newImageSize = [helperIns resizeImage:image resizeSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
                            _message.thumnail = newImageSize;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                scCell.vMessengerImageFriend.imgView.image = _message.thumnail;
                            });
                            
                            NSArray *subKey = [_message.urlImage componentsSeparatedByString:@"/"];
                            [helperIns saveImageToDocument:image withName:[subKey lastObject]];
                        }
                        
                    }
                    
                }];
            }
            
        });
        
    }
    
    [scCell.viewImage setFrame:CGRectMake(xViewImageShadow, topSpacingV3 / 2, scCell.viewImage.bounds.size.width, scCell.viewImage.bounds.size.height)];
    scCell.viewImage.layer.zPosition = 10;
    
    [scCell.lblTimeMessengerImage setText:_message.timeMessage];
    [scCell.lblTimeMessengerImage setFrame:CGRectMake(scCell.vMessengerImageFriend.frame.origin.x + 10, scCell.vMessengerImageFriend.bounds.size.height - sizeTime.height, sizeTime.width, sizeTime.height)];
    
    //Image Friend send is location then hidden button download
    if (_message.typeMessage == 2) {
        [scCell.btnDownloadImage setHidden:YES];
    }
    
    [scCell.btnDownloadImage setTag:_indexPath.row];
    
    int _senderID = _message.senderID;
    int _friendID = _message.friendID;
    
    if (_message.statusMessage == 0) {
        
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            //If Type Message == 1 then when user click image show full then set status message
            
            //type message == 2 then the same text
            if (_message.typeMessage == 2) {//Location
                if (self.scMessageGroupTableViewDelegate && [self.scMessageGroupTableViewDelegate respondsToSelector:@selector(sendIsReadMessageGroup:withKeyMessage:withTypeMessage:)]) {
                    [self.scMessageGroupTableViewDelegate sendIsReadMessageGroup:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
                }
                //            strStatus = @"Read";
                [scCell.imgStatusMessengerImage setImage:imgIsRead];
                
                [_message setStatusMessage:2];
                [storeIns updateStatusMessageFriendWithKey:_friendID withMessageID:_message.keySendMessage withStatus:2];
            }
            
            if (_message.typeMessage == 1) {
                [scCell.imgStatusMessengerImage setImage:imgIsRecive];
            }
            
        }else{
            //            strStatus = @"Recive";
            [scCell.imgStatusMessengerImage setImage:imgIsRead];
        }
    }
    
    if (_message.statusMessage == 2) {
        [scCell.imgStatusMessengerImage setImage:imgIsRead];
    }
    
    [scCell.imgStatusMessengerImage setFrame:CGRectMake(scCell.lblTimeMessengerImage.frame.origin.x + sizeTime.width, scCell.lblTimeMessengerImage.frame.origin.y - 3, sizeTime.height + 6, sizeTime.height + 6)];
}

- (void) setClearData:(BOOL)_isClear{
    clearData = _isClear;
}

- (void) reloadTableView{
    
    Messenger *_mess = nil;
    if (self.recentIns.typeRecent == 0) {
        _mess = [self.recentIns.friendIns.friendMessage lastObject];
    }
    
    if (self.recentIns.typeRecent == 1) {
        _mess = [self.recentIns.messengerRecent lastObject];
    }
    
    CGFloat hRow = 0;
    if (_mess.typeMessage == 0) {
        NSString *msg = [[_mess strMessage] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CGSize textSize = { wMax, CGFLOAT_MAX };
        CGSize size = [msg boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:16.0f]} context:nil].size;
        CGSize sizeTime = [@"1:04pm" boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[helperIns getFontLight:9.0f]} context:nil].size;
        
        size.height += sizeTime.height;
        
        size.height += padding;
        size.height = size.height < 60 ? 60 : size.height;
        
        hRow = size.height;
    }else{
        hRow = 170;
    }
    
    CGFloat y = self.contentSize.height - (self.bounds.size.height + hRow);
    
    if (self.contentOffset.y >= (lroundf(y * 100) / 100)) {
        if (inScroll == NO) {
            
            [self reloadData];
            
            //scroll to bottom
            double y = self.contentSize.height - self.bounds.size.height;
            CGPoint bottomOffset = CGPointMake(0, y);
            
            if (y > -self.contentInset.top)
                [self setContentOffset:bottomOffset animated:NO];
        }
    }else{
        SCChatViewV2ViewController *parent = nil;
        
        for (UIView* next = [self superview]; next; next = next.superview)
        {
            UIResponder* nextResponder = [next nextResponder];
            
            if ([nextResponder isKindOfClass:[SCChatViewV2ViewController class]])
            {
                parent = ((SCChatViewV2ViewController*)nextResponder);
                break;
            }
        }
        
        Messenger *_messenger = nil;
        if (self.recentIns.typeRecent == 0) {
            _messenger = [self.recentIns.friendIns.friendMessage lastObject];
        }
        
        if (self.recentIns.typeRecent == 1) {
            _messenger = [self.recentIns.messengerRecent lastObject];
        }
        
        if (_messenger.senderID > 0) {
            [parent.vNewMessage setHidden:NO];
            if (_messenger.typeMessage == 0) {
                [parent.lblNewMessenger setText:_messenger.strMessage];
            }else{
                [parent.lblNewMessenger setText:@"You have new messenger"];
            }
            
        }
        
    }
    
    [self reloadData];
}

#pragma mark- UIScrollView Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = self.contentSize.height - (self.bounds.size.height + self.frame.origin.y + 20);
    
    if (self.contentOffset.y >= (lroundf(y * 100) / 100)) {
        
        for (UIView* next = [self superview]; next; next = next.superview)
        {
            UIResponder* nextResponder = [next nextResponder];
            
            if ([nextResponder isKindOfClass:[SCChatViewV2ViewController class]])
            {
                [((SCChatViewV2ViewController*)nextResponder).vNewMessage setHidden:YES];
                break;
            }
        }
        
//        SCChatViewV2ViewController *parent = (SCChatViewV2ViewController*)[self superview];
//        [parent.vNewMessage setHidden:YES];
    }
    
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    inScroll = YES;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    inScroll = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endDeceleration" object:self];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    inScroll = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    inScroll = NO;
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    inScroll = NO;
}

#pragma mark- Touch View
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!inScroll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"touchTableView" object:self];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!inScroll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"touchEndTableView" object:self];
    }
    
}

#pragma -mark UILongPressGestureRecognizer
- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        SCMessageTableViewCellV2 *cell = (SCMessageTableViewCellV2 *)recognizer.view;
        [cell becomeFirstResponder];
        rowAction = [self indexPathForCell:cell];
        
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

- (void) tapImage:(UITapGestureRecognizer*)recognizer{
    
    CGPoint tapLocation = [recognizer locationInView:self];
    NSIndexPath *tapIndexPath = [self indexPathForRowAtPoint:tapLocation];
    
    Messenger *_messenger = nil;
    if (self.recentIns.typeRecent == 0) {
        _messenger = [self.recentIns.friendIns.friendMessage objectAtIndex:tapIndexPath.row];
    }
    
    if (self.recentIns.typeRecent == 1) {
        _messenger = [self.recentIns.messengerRecent objectAtIndex:tapIndexPath.row];
    }
    
    [self showImageFull:_messenger withIndexPath:tapIndexPath];
    
}

- (void) btnDownloadImage:(id)sender{
    
    UIButton *btnDownload = (UIButton*)sender;
    NSInteger _tagButton = btnDownload.tag;
    
    Messenger *_messenger = nil;
    if (self.recentIns.typeRecent == 0) {
        _messenger = [self.recentIns.friendIns.friendMessage objectAtIndex:_tagButton];
    }
    
    if (self.recentIns.typeRecent == 1) {
        _messenger = [self.recentIns.messengerRecent objectAtIndex:_tagButton];
    }
    
    NSIndexPath *_indexPahtTap = [NSIndexPath indexPathForRow:_tagButton inSection:0];
    
    [self showImageFull:_messenger withIndexPath:_indexPahtTap];
}

- (void) showImageFull:(Messenger*)_messenger withIndexPath:(NSIndexPath*)_indexPath{
    
    ChatView *parent = (ChatView*)[self superview];
    
    [parent endEditing:YES];
    
    if (_messenger.typeMessage == 1) {
        
        if ([_messenger.urlImage isEqualToString:@""] || _messenger.urlImage == nil) {
            return;
        }
            
        ImageFullView *_fullImage = [[ImageFullView alloc] initWithFrame:[[self superview] bounds]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *imgMessenger = nil;
            if (_messenger.senderID > 0) {
                NSArray *subKey = [_messenger.urlImage componentsSeparatedByString:@"/"];
                imgMessenger = [helperIns loadImage:[subKey lastObject]];
            }else{
                imgMessenger = [helperIns loadImage:_messenger.keySendMessage];
            }
            
            if (imgMessenger) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_fullImage initWithImage:imgMessenger];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_fullImage initWithUrl:[NSURL URLWithString:_messenger.urlImage]];
                });
            }
            
        });
        
        int _senderID = _messenger.senderID;
        int _friendID = _messenger.friendID;
        
        SCMessageTableViewCellV2 *scCell = (SCMessageTableViewCellV2*)[self cellForRowAtIndexPath:_indexPath];
        if (_messenger.statusMessage == 1) {
            
            if (_senderID == _friendID) {
                //If Type Message == 1 then when user click image show full then set status message
                
                //type message == 2 then the same text
                if (_messenger.typeMessage == 1) {//Location
                    if (self.scMessageGroupTableViewDelegate && [self.scMessageGroupTableViewDelegate respondsToSelector:@selector(sendIsReadMessageGroup:withKeyMessage:withTypeMessage:)]) {
                        [self.scMessageGroupTableViewDelegate sendIsReadMessageGroup:_friendID withKeyMessage:_messenger.keySendMessage withTypeMessage:_messenger.typeMessage];
                    }
                    //            strStatus = @"Read";
                    [scCell.imgStatusMessengerImage setImage:imgIsRead];
                    [scCell setNeedsDisplay];
                    
                    [_messenger setStatusMessage:2];
                    [storeIns updateStatusMessageFriendWithKey:_friendID withMessageID:_messenger.keySendMessage withStatus:2];
                }
                
                if (_messenger.typeMessage == 1) {
                    [scCell.imgStatusMessengerImage setImage:imgIsRecive];
                }
                
            }else{
                //            strStatus = @"Recive";
                [scCell.imgStatusMessengerImage setImage:imgIsRead];
            }
        }else if (_messenger.statusMessage == 2){
            [scCell.imgStatusMessengerImage setImage:imgIsRead];
        }
        
        NSArray *visibleCell = [self indexPathsForVisibleRows];
        [self reloadRowsAtIndexPaths:visibleCell withRowAnimation:UITableViewRowAnimationNone];
        
        //Notification to Parent View show Full Image
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showFullImage" object:nil];
        
        [[self superview] addSubview:_fullImage];
        
    }else if(_messenger.typeMessage == 2){
        
        AppleMapView *newAppleView = [[AppleMapView alloc] initWithFrame:[[self superview] bounds]];
        [newAppleView setTag:200000];
//        if (_messenger.senderID > 0) {
//            [newAppleView addAnnotation:[_messenger.latitude floatValue] withLongitude:[_messenger.longitude floatValue] withFriend:friendIns];
//        }
        
        if (self.recentIns.typeRecent == 0) {
            [newAppleView addAnnotation:[_messenger.latitude floatValue] withLongitude:[_messenger.longitude floatValue] withFriend:self.recentIns.friendIns];
        }
        
        if (self.recentIns.typeRecent == 1) {
            Friend *_friend = nil;
            if (self.recentIns.friendRecent) {
                int count = (int)[self.recentIns.friendRecent count];
                for (int i = 0; i < count; i++) {
                    if ([[self.recentIns.friendRecent objectAtIndex:i] friendID] == _messenger.friendID) {
                        _friend = [self.recentIns.friendRecent objectAtIndex:i];
                        
                        break;
                    }
                }
            }
            
            [newAppleView addAnnotation:[_messenger.latitude floatValue] withLongitude:[_messenger.longitude floatValue] withFriend:_friend];
        }
        
        [[self superview] addSubview:newAppleView];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"touchTableView" object:self];
    }
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

#pragma -mark UIActionSheet Delegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            Messenger *_messenger = nil;
            if (self.recentIns.typeRecent == 0) {
                _messenger = [self.recentIns.friendIns.friendMessage objectAtIndex:rowAction.row];
            }
            
            if (self.recentIns.typeRecent == 1) {
                _messenger = [self.recentIns.messengerRecent objectAtIndex:rowAction.row];
            }
            
            if (self.scMessageGroupTableViewDelegate && [self.scMessageGroupTableViewDelegate respondsToSelector:@selector(notifyDeleteMessageGroup:)]){
                [self.scMessageGroupTableViewDelegate notifyDeleteMessageGroup:_messenger];
            }
        }
            break;
            
        default:
            break;
    }
}

- (Friend*) getFriendWithFriendID:(int)_friendID{
    Friend *result = nil;
    if (self.recentIns.friendRecent) {
        int count = (int)[self.recentIns.friendRecent count];
        for (int i = 0; i < count; i++) {
            if ([[self.recentIns.friendRecent objectAtIndex:i] friendID] == _friendID) {
                result = [self.recentIns.friendRecent objectAtIndex:i];
                
                break;
            }
        }
    }
    
    return result;
}
@end
