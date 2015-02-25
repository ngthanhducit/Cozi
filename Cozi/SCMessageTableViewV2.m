//
//  SCMessageTableViewV2.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/18/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCMessageTableViewV2.h"
#import "ChatView.h"

@implementation SCMessageTableViewV2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

const CGFloat leftSpacing = 10;
const CGSize sizeIcon = { 40, 40 };
const CGFloat topSpacing = 10.0f;
const CGFloat wViewMainPadding = 20.0f;

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
    
//    defaultImage = [helperIns imageWithView:loadView];
    imgIsRead = [helperIns getImageFromSVGName:@"icon-EyeGrey-v2.svg"];
    imgIsRecive = [helperIns getImageFromSVGName:@"icon-TickGrey-v3.svg"];
}

- (void) setData:(NSMutableArray *)_data{
//    items = _data;
}

- (void) setFriendIns:(Friend *)_friend{
    friendIns = _friend;
}

- (Friend*) getFrinedIns{
    return friendIns;
}

#pragma -mark UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (clearData) {
        return 0;
    }else{
        return [friendIns.friendMessage count];
//        return [items count];
    }

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Messenger *_message = [friendIns.friendMessage objectAtIndex:indexPath.row];
    
    if (_message.typeMessage == 0) {
     
        NSString *msg = [[_message strMessage] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CGSize textSize = { wMax, CGFLOAT_MAX };
        CGSize size = [msg sizeWithFont:[helperIns getFontLight:16.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
        CGSize sizeTime = [@"1:04pm" sizeWithFont:[helperIns getFontLight:9.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
        
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
    
    Messenger *_message = [friendIns.friendMessage objectAtIndex:indexPath.row];
    Messenger *_lastMessage = nil;
    
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    
    if (lastIndexPath.row >= 0) {
        _lastMessage = [friendIns.friendMessage objectAtIndex:lastIndexPath.row];
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
    
    UIImage *imgAvatarFriend = friendIns.thumbnail;
    UIImage *imgAvatarMe = storeIns.user.thumbnail;
    
    [scCell.iconFriend setImage: imgAvatarFriend];
    [scCell.iconImage setImage:imgAvatarMe];
    
    int _senderID = _message.senderID;
    int _friendID = friendIns.friendID;
    
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
        sizeMessage = [@"YOU PINGED" sizeWithFont:[helperIns getFontLight:16.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    }else{
        sizeMessage = [[_message.strMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sizeWithFont:[helperIns getFontLight:16.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
//    CGSize sizeTime = { 44.2202148, 14.5073242 };
    CGSize sizeTime = [_message.timeMessage sizeWithFont:[helperIns getFontLight:9.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize size = sizeMessage;
    
    size.height += sizeTime.height;
    
    size.width += padding / 2;
    size.height += padding / 2;
    
    CGFloat hView = size.height;
    hView = hView < 50 ? 50 : hView;
    
    CGFloat wView = size.width;
    wView = wView < 70 ? 70 : wView;
    
    CGFloat xViewMain = self.bounds.size.width - (leftSpacing + sizeIcon.width + leftSpacing + wView + wViewMainPadding);
    
    [scCell.vMainShadow setFrame:CGRectMake(xViewMain, topSpacing / 2, wView + (wViewMainPadding), hView)];
    [scCell.vMainShadow setBackgroundColor:[UIColor blackColor]];
    
    [scCell.viewMain setFrame:CGRectMake(xViewMain, topSpacing / 2, wView + (wViewMainPadding), hView)];
    [scCell.viewMain setBackgroundColor:[UIColor blackColor]];

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
//    [scCell.lblTime setTextColor:[UIColor whiteColor]];
    [scCell.lblTime setTextColor:[UIColor colorWithRed:107.0f/255.0f green:107.0f/255.0f blue:107.0f/255.0f alpha:1]];
    [scCell.lblTime setFont:[helperIns getFontLight:9.0f]];
    [scCell.lblTime setFrame:CGRectMake(padding / 2, scCell.txtMessageContent.frame.origin.y + sizeMessage.height, sizeTime.width, sizeTime.height)];

    [scCell.blackTriangle setFrame:CGRectMake(xViewMain + scCell.viewMain.bounds.size.width, topSpacing + (sizeIcon.height / 2) - 5, 10, 10)];

    //Set Status Image
    int _senderID = _message.senderID;
    int _friendID = friendIns.friendID;
    
    if (_message.statusMessage == 0) {
        
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            if (self.scMessageTableViewDelegate && [self.scMessageTableViewDelegate respondsToSelector:@selector(sendIsReadMessage:withKeyMessage:withTypeMessage:)]) {
                [self.scMessageTableViewDelegate sendIsReadMessage:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
            }
//            strStatus = @"Read";
            //change image status - Read
            [scCell.imgStatusMessage setImage:imgIsRead];
            
            [[friendIns.friendMessage objectAtIndex:_indexPath.row] setStatusMessage:2];
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
        sizeMessage = [@"PINGED" sizeWithFont:[helperIns getFontLight:16.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    }else{
        sizeMessage = [[_message.strMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sizeWithFont:[helperIns getFontLight:16.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
//    CGSize sizeTime = { 44.2202148, 14.5073242 };
    CGSize sizeTime = [_message.timeMessage sizeWithFont:[helperIns getFontLight:9.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize size = sizeMessage;
    
    size.height += sizeTime.height;
    
    size.width += padding / 2;
    size.height += padding / 2;
    
    CGFloat hView = size.height;
    hView = hView < 50 ? 50 : hView;
    
    CGFloat wView = size.width;
    wView = wView < 70 ? 70 : wView;
    
    CGFloat xViewMain = leftSpacing + sizeIcon.width + leftSpacing;
    
    [scCell.vMainShadow setFrame:CGRectMake(xViewMain, topSpacing / 2, wView + (wViewMainPadding), hView)];
    [scCell.vMainShadow setBackgroundColor:[UIColor whiteColor]];
    
    [scCell.viewMain setFrame:CGRectMake(xViewMain, topSpacing / 2, wView + (wViewMainPadding), hView)];
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
    [scCell.lblTime setFont:[helperIns getFontLight:9.0f]];
    [scCell.lblTime setFrame:CGRectMake(padding / 2, scCell.txtMessageContent.frame.origin.y + scCell.txtMessageContent.bounds.size.height, sizeTime.width, sizeTime.height)];
    
    [scCell.vTriangle setFrame:CGRectMake(xViewMain - 10, topSpacing + (sizeIcon.height / 2) - 5, 10, 10)];
    
    //Set Status Image
    int _senderID = _message.senderID;
    int _friendID = friendIns.friendID;
    
    if (_message.statusMessage == 0) {
        
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            if (self.scMessageTableViewDelegate && [self.scMessageTableViewDelegate respondsToSelector:@selector(sendIsReadMessage:withKeyMessage:withTypeMessage:)]) {
                [self.scMessageTableViewDelegate sendIsReadMessage:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
            }
            //            strStatus = @"Read";
            [scCell.imgStatusMessage setImage:imgIsRead];
            
            [[friendIns.friendMessage objectAtIndex:_indexPath.row] setStatusMessage:2];
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
    CGSize sizeTime = [_message.timeMessage sizeWithFont:[helperIns getFontLight:9.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat wViewMessenger = self.bounds.size.width - (leftSpacing + sizeIcon.width + leftSpacing + leftSpacing + leftSpacing / 2);
    CGFloat xViewMessenger = self.bounds.size.width - (leftSpacing + sizeIcon.width + leftSpacing / 2 + wViewMessenger);

    [scCell.vMessengerImageShadow setFrame:CGRectMake(xViewMessenger, topSpacing / 2, scCell.vMessengerImageShadow.bounds.size.width, scCell.vMessengerImageShadow.bounds.size.height)];
    
    [scCell.vMessengerImage setFrame:CGRectMake(xViewMessenger, topSpacing / 2, wViewMessenger, 160)];

    if (_message.thumnail !=nil) {
        
        scCell.vMessengerImage.imgView.image = _message.thumnail;
        
    }else{
        
        scCell.vMessengerImage.imgView.image = defaultImage;

        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_message.urlImage] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            if (image && finished) {

                UIImage *newImageSize = [helperIns resizeImage:image resizeSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
                _message.thumnail = newImageSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    scCell.vMessengerImage.imgView.image = _message.thumnail;
                });

            }
        }];
    }
    
//    [scCell.vMessengerImage.imgView sd_setImageWithURL:[NSURL URLWithString:_message.urlImage] placeholderImage:nil];
    
    [scCell.viewImage setFrame:CGRectMake(xViewMessenger, topSpacing / 2, scCell.viewImage.bounds.size.width, scCell.viewImage.bounds.size.height)];

    [scCell.lblTimeMessengerImage setText:_message.timeMessage];
    [scCell.lblTimeMessengerImage setFrame:CGRectMake(scCell.vMessengerImage.frame.origin.x + 10, scCell.vMessengerImage.bounds.size.height - sizeTime.height, sizeTime.width, sizeTime.height)];

    [scCell.btnDownloadImage setTag:_indexPath.row];
    
    
    int _senderID = _message.senderID;
    int _friendID = friendIns.friendID;
    
    if (_message.statusMessage == 0) {
        
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            if (self.scMessageTableViewDelegate && [self.scMessageTableViewDelegate respondsToSelector:@selector(sendIsReadMessage:withKeyMessage:withTypeMessage:)]) {
                [self.scMessageTableViewDelegate sendIsReadMessage:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
            }
            //            strStatus = @"Read";
            [scCell.imgStatusMessengerImage setImage:imgIsRead];
            
            [[friendIns.friendMessage objectAtIndex:_indexPath.row] setStatusMessage:2];
            [storeIns updateStatusMessageFriendWithKey:_friendID withMessageID:_message.keySendMessage withStatus:2];
        }else{
            //            strStatus = @"Recive";
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
    
//    CGSize sizeTime = { 44.2202148, 14.5073242 };
    CGSize sizeTime = [_message.timeMessage sizeWithFont:[helperIns getFontLight:9.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat wViewMessenger = self.bounds.size.width - (leftSpacing + sizeIcon.width + leftSpacing + leftSpacing + leftSpacing / 2);
    CGFloat xViewImageShadow = leftSpacing + sizeIcon.width + leftSpacing;
    [scCell.vMessengerImageShadow setFrame:CGRectMake(xViewImageShadow, topSpacing / 2, scCell.vMessengerImageShadow.bounds.size.width, scCell.vMessengerImageShadow.bounds.size.height)];
    
    [scCell.vMessengerImageFriend setFrame:CGRectMake(leftSpacing + sizeIcon.width + leftSpacing / 2, topSpacing / 2, wViewMessenger, 160)];

    //Comment
    if (_message.thumnail !=nil) {
        scCell.vMessengerImageFriend.imgView.image = _message.thumnail;
        
    }else{
        
        scCell.vMessengerImageFriend.imgView.image = defaultImage;
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_message.urlImage] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {

            if (image && finished) {
                UIImage *newImageSize = [helperIns resizeImage:image resizeSize:CGSizeMake(image.size.width / 4, image.size.height / 4)];
                UIImage *imgBlur = [newImageSize applyLightEffect];
                _message.thumnail = imgBlur;
                dispatch_async(dispatch_get_main_queue(), ^{
                    scCell.vMessengerImageFriend.imgView.image = _message.thumnail;
                });
            }
            
        }];
    }
    
    [scCell.viewImage setFrame:CGRectMake(xViewImageShadow, topSpacing / 2, scCell.viewImage.bounds.size.width, scCell.viewImage.bounds.size.height)];
    scCell.viewImage.layer.zPosition = 10;
    
    [scCell.lblTimeMessengerImage setText:_message.timeMessage];
    [scCell.lblTimeMessengerImage setFrame:CGRectMake(scCell.vMessengerImageFriend.frame.origin.x + 10, scCell.vMessengerImageFriend.bounds.size.height - sizeTime.height, sizeTime.width, sizeTime.height)];
    
    //Image Friend send is location then hidden button download
    if (_message.typeMessage == 2) {
        [scCell.btnDownloadImage setHidden:YES];
    }
    
    [scCell.btnDownloadImage setTag:_indexPath.row];
    
    int _senderID = _message.senderID;
    int _friendID = friendIns.friendID;
    
    if (_message.statusMessage == 0) {
        
    }
    
    if (_message.statusMessage == 1) {
        if (_senderID == _friendID) {
            //If Type Message == 1 then when user click image show full then set status message
            
            //type message == 2 then the same text
            if (_message.typeMessage == 2) {//Location
                if (self.scMessageTableViewDelegate && [self.scMessageTableViewDelegate respondsToSelector:@selector(sendIsReadMessage:withKeyMessage:withTypeMessage:)]) {
                    [self.scMessageTableViewDelegate sendIsReadMessage:_friendID withKeyMessage:_message.keySendMessage withTypeMessage:_message.typeMessage];
                }
                //            strStatus = @"Read";
                [scCell.imgStatusMessengerImage setImage:imgIsRead];
                
                [[friendIns.friendMessage objectAtIndex:_indexPath.row] setStatusMessage:2];
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

#pragma mark- UIScrollView Delegate
- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    inScroll = YES;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    inScroll = NO;
//    [self reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endDeceleration" object:self];
    
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    inScroll = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    inScroll = NO;
//    [self reloadData];
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    inScroll = NO;
//    [self reloadData];
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

- (void) tapImage:(UITapGestureRecognizer*)recognizer{
    
    CGPoint tapLocation = [recognizer locationInView:self];
    NSIndexPath *tapIndexPath = [self indexPathForRowAtPoint:tapLocation];
    
    Messenger *_messenger = [friendIns.friendMessage objectAtIndex:tapIndexPath.row];
    
    [self showImageFull:_messenger];
}

- (void) btnDownloadImage:(id)sender{

    UIButton *btnDownload = (UIButton*)sender;
    NSInteger _tagButton = btnDownload.tag;
    
    Messenger *_messenger = [friendIns.friendMessage objectAtIndex:_tagButton];
    
    [self showImageFull:_messenger];
}

- (void) showImageFull:(Messenger*)_messenger{
    
    ChatView *parent = (ChatView*)[self superview];
    [parent endEditing:YES];
    
    if (_messenger.typeMessage == 1) {
        
        ImageFullView *_fullImage = [[ImageFullView alloc] initWithFrame:[[self superview] bounds]];
        [_fullImage initWithUrl:[NSURL URLWithString:_messenger.urlImage]];
        [[self superview] addSubview:_fullImage];
        
    }else if(_messenger.typeMessage == 2){
        
        AppleMapView *newAppleView = [[AppleMapView alloc] initWithFrame:CGRectMake(0, [parent getHeaderHeight], self.bounds.size.width, parent.bounds.size.height - [parent getHeaderHeight])];
        [newAppleView setTag:200000];
        if (_messenger.senderID > 0) {
            [newAppleView addAnnotation:[_messenger.latitude floatValue] withLongitude:[_messenger.longitude floatValue] withFriend:friendIns];
        }
        
        [newAppleView addAnnotation:[_messenger.latitude floatValue] withLongitude:[_messenger.longitude floatValue] withFriend:friendIns];
        
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
            NSLog(@"button index: %i", (int)buttonIndex);
            Messenger *_messenger = [friendIns.friendMessage objectAtIndex:rowAction.row];
            
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
