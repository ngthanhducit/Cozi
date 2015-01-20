//
//  SCMessageTableViewV2.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/18/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCMessageTableViewV2.h"

@implementation SCMessageTableViewV2

@synthesize friendIns;

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
    
    padding = 20.0f;
    wMax = self.bounds.size.width - 110;
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) setData:(NSMutableArray *)_data{
    items = _data;
}

#pragma -mark UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friendIns.friendMessage count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Messenger *_message = [self.friendIns.friendMessage objectAtIndex:indexPath.row];
    
    if (_message.typeMessage == 0) {
     
        NSString *msg = [[_message strMessage] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CGSize textSize = { wMax, CGFLOAT_MAX };
        CGSize size = [msg sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
        CGSize sizeTime = [@"1:04pm" sizeWithFont:[helperIns getFontLight:11.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
        
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
    
    Messenger *_message = [self.friendIns.friendMessage objectAtIndex:indexPath.row];
    Messenger *_lastMessage = nil;
    
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    
    if (lastIndexPath.row >= 0) {
        _lastMessage = [self.friendIns.friendMessage objectAtIndex:lastIndexPath.row];
    }
    
    scCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCMessageTableViewCellV2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [scCell setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
    if (indexPath.row % 2 == 0) {
//        [scCell setBackgroundColor:[UIColor purpleColor]];
    }else{
//        [scCell setBackgroundColor:[UIColor orangeColor]];
    }
    
    UIImage *imgAvatarFriend = self.friendIns.thumbnail;
    UIImage *imgAvatarMe = storeIns.user.thumbnail;
    
    [scCell.iconFriend setImage: imgAvatarFriend];
    [scCell.iconFriend setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GrayColor2"]]];
    [scCell.iconImage setImage:imgAvatarMe];
    [scCell.iconImage setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GrayColor2"]]];
    
    int _senderID = _message.senderID;
    int _friendID = self.friendIns.friendID;
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"hh:mm a"];
    
    if (_message.typeMessage == 0) {        //Text Message
        
        
        if (_senderID == _friendID) {       //Message of friend
            
            //hidden my avatar
            [scCell.iconImage setHidden:YES];
            [scCell.iconFriend setHidden:NO];
            
            if (_lastMessage != nil && _lastMessage.senderID == _message.senderID && _lastMessage.typeMessage == _message.typeMessage) {
            
                [self renderCellFriend:scCell withMessenger:_message withAvatar:NO];
                
            }else{
                
                [self renderCellFriend:scCell withMessenger:_message withAvatar:YES];
                
            }
            
        }else{  //My Message
            
            [scCell.iconFriend setHidden:YES];
            [scCell.iconImage setHidden:NO];
            
            if (_lastMessage != nil && _lastMessage.senderID == _message.senderID && _lastMessage.typeMessage == _message.typeMessage) {
                
                [self renderCell:scCell withMessenger:_message withAvatar:NO];
            }else{
                [self renderCell:scCell withMessenger:_message withAvatar:YES];
            }
        }
    }
    
    if (_message.typeMessage == 1) {
        if (_senderID == _friendID) {//friend
            [self renderImageCellFriend:scCell withMessenger:_message];
        }else{
            [self renderImageCell:scCell withMessenger:_message];
        }
    }
    
    return scCell;
}

- (void) renderCell:(SCMessageTableViewCellV2*)scCell withMessenger:(Messenger*)_message withAvatar:(BOOL)_enableAvatar{
    CGSize textSize = { wMax, CGFLOAT_MAX };
    
    //hidden my avatar
    [scCell.iconFriend setHidden:YES];
    [scCell.iconImage setHidden:NO];
    
    [scCell.viewMain setHidden:NO];
    [scCell.vTriangle setHidden:YES];
    [scCell.blackTriangle setHidden:NO];
    
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
    
    CGSize sizeMessage = [[_message.strMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize sizeTime = [_message.timeMessage sizeWithFont:[helperIns getFontLight:11.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize size = sizeMessage;
    
    size.height += sizeTime.height;
    
    size.width += padding / 2;
    size.height += padding / 2;
    
    CGFloat hView = size.height;
    hView = hView < 50 ? 50 : hView;
    
    CGFloat wView = size.width;
    wView = wView < 70 ? 70 : wView;
    
    CGFloat xViewMain = self.bounds.size.width - (leftSpacing + sizeIcon.width + leftSpacing + wView + wViewMainPadding);
    
    [scCell.viewMain setFrame:CGRectMake(xViewMain, topSpacing / 2, wView + (wViewMainPadding), hView)];
    [scCell.viewMain setBackgroundColor:[UIColor blackColor]];
//    scCell.viewMain.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    scCell.viewMain.layer.shadowOffset = CGSizeMake(1, 1);
//    scCell.viewMain.layer.shadowOpacity = 1;
//    scCell.viewMain.layer.shadowRadius = 1.0;

    CGFloat yMessage = (hView / 2) - (sizeMessage.height / 2 + sizeTime.height / 2);
    scCell.txtMessageContent.text = _message.strMessage;
    [scCell.txtMessageContent setBackgroundColor:[UIColor clearColor]];
    [scCell.txtMessageContent setTextColor:[UIColor whiteColor]];
    [scCell.txtMessageContent setTextAlignment:NSTextAlignmentLeft];
    [scCell.txtMessageContent setFont:[helperIns getFontLight:15.0f]];
    [scCell.txtMessageContent setTextContainerInset:UIEdgeInsetsMake(-4, -4, 0, 0)];
//    [scCell.txtMessageContent sizeToFit];
//    [scCell.txtMessageContent sizeThatFits:sizeMessage];
//    scCell.txtMessageContent.textContainer.lineFragmentPadding = 0 ;
//    [scCell.txtMessageContent setTextContainerInset:UIEdgeInsetsZero];
    [scCell.txtMessageContent setFrame:CGRectMake(padding / 2, yMessage, scCell.viewMain.bounds.size.width - padding, sizeMessage.height)];

    [scCell.lblTime setText:_message.timeMessage];
    [scCell.lblTime setBackgroundColor:[UIColor clearColor]];
    [scCell.lblTime setNumberOfLines:0];
    CGSize sizeTimeLabel = [scCell.lblTime.text sizeWithFont:[helperIns getFontLight:11.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    [scCell.lblTime setTextAlignment:NSTextAlignmentLeft];
    [scCell.lblTime setTextColor:[UIColor whiteColor]];
    [scCell.lblTime setFont:[helperIns getFontLight:11.0f]];
    [scCell.lblTime setFrame:CGRectMake(padding / 2, scCell.txtMessageContent.frame.origin.y + sizeMessage.height, sizeTimeLabel.width, sizeTimeLabel.height)];

    CGFloat xIcon = self.bounds.size.width - (leftSpacing + sizeIcon.width);
    [scCell.iconImage setFrame:CGRectMake(xIcon, topSpacing / 2, sizeIcon.width, sizeIcon.height)];
    [scCell.iconImage setContentMode:UIViewContentModeScaleAspectFill];
    [scCell.iconImage setAutoresizingMask:UIViewAutoresizingNone];
    scCell.iconImage.layer.borderWidth = 0.0f;
    [scCell.iconImage setClipsToBounds:YES];
    scCell.iconImage.layer.cornerRadius = CGRectGetHeight(scCell.iconImage.frame) / 2;
    
//    [scCell.vTriangle setBackgroundColor:[UIColor blackColor]];
//    [scCell.vTriangle drawTrianMessageBlack];
    [scCell.blackTriangle setFrame:CGRectMake(xViewMain + scCell.viewMain.bounds.size.width, topSpacing + (sizeIcon.height / 2) - 5, 10, 10)];
//    scCell.vTriangle.layer.shadowColor = [UIColor blackColor].CGColor;
//    scCell.vTriangle.layer.shadowOffset = CGSizeMake(10, 10);
//    scCell.vTriangle.layer.shadowOpacity = 3;
//    scCell.vTriangle.layer.shadowRadius = 3.0;
//    [scCell.vTriangle.layer setMasksToBounds:NO];
    

//    UIImage *imgStatus = [helperIns getImageFromSVGName:@"icon-EyeGrey.svg"];
    [scCell.imgStatusMessage setFrame:CGRectMake(scCell.lblTime.frame.origin.x + scCell.lblTime.bounds.size.width, scCell.lblTime.frame.origin.y, scCell.lblTime.bounds.size.height, scCell.lblTime.bounds.size.height)];
//    [scCell.imgStatusMessage setImage:imgStatus];
//    [scCell.imgStatusMessage setBackgroundColor:[UIColor orangeColor]];
}

- (void) renderCellFriend:(SCMessageTableViewCellV2*)scCell withMessenger:(Messenger*)_message withAvatar:(BOOL)_enableAvatar{
    CGSize textSize = { wMax, CGFLOAT_MAX };
    
    //hidden my avatar
    [scCell.iconImage setHidden:YES];
    [scCell.iconFriend setHidden:NO];
    
    [scCell.viewMain setHidden:NO];
    [scCell.vTriangle setHidden:NO];
    [scCell.blackTriangle setHidden:YES];
    
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

    CGSize sizeMessage = [[_message.strMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize sizeTime = [_message.timeMessage sizeWithFont:[helperIns getFontLight:11.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize size = sizeMessage;
    
    size.height += sizeTime.height;
    
    size.width += padding / 2;
    size.height += padding / 2;
    
    CGFloat hView = size.height;
    hView = hView < 50 ? 50 : hView;
    
    CGFloat wView = size.width;
    wView = wView < 70 ? 70 : wView;
    
    CGFloat xViewMain = leftSpacing + sizeIcon.width + leftSpacing;
    [scCell.viewMain setFrame:CGRectMake(xViewMain, topSpacing / 2, wView + (wViewMainPadding), hView)];
    //            [scCell.viewMain setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]];
    [scCell.viewMain setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat yMessage = (hView / 2) - (sizeMessage.height / 2 + sizeTime.height / 2);
    scCell.txtMessageContent.text = _message.strMessage;
    [scCell.txtMessageContent setBackgroundColor:[UIColor clearColor]];
    //            [scCell.txtMessageContent setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [scCell.txtMessageContent setTextColor:[UIColor lightGrayColor]];
    [scCell.txtMessageContent setTextAlignment:NSTextAlignmentLeft];
    [scCell.txtMessageContent setFont:[helperIns getFontLight:15.0f]];
    [scCell.txtMessageContent setTextContainerInset:UIEdgeInsetsMake(-4, -4, 0, 0)];
//    scCell.txtMessageContent.textContainer.lineFragmentPadding = 0 ;
//    [scCell.txtMessageContent setTextContainerInset:UIEdgeInsetsZero];
    [scCell.txtMessageContent setFrame:CGRectMake(padding / 2, yMessage, scCell.viewMain.bounds.size.width - padding, sizeMessage.height)];
    
    [scCell.lblTime setText:_message.timeMessage];
    [scCell.lblTime setBackgroundColor:[UIColor clearColor]];
    [scCell.lblTime setNumberOfLines:0];
    CGSize sizeTimeLabel = [scCell.lblTime.text sizeWithFont:[helperIns getFontLight:11.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    [scCell.lblTime setTextAlignment:NSTextAlignmentLeft];
    [scCell.lblTime setTextColor:[UIColor lightGrayColor]];
    [scCell.lblTime setFont:[helperIns getFontLight:11.0f]];
    [scCell.lblTime setFrame:CGRectMake(padding / 2, scCell.txtMessageContent.frame.origin.y + scCell.txtMessageContent.bounds.size.height, sizeTimeLabel.width, sizeTimeLabel.height)];
    
    [scCell.iconFriend setFrame:CGRectMake(leftSpacing, topSpacing / 2, sizeIcon.width, sizeIcon.height)];
    [scCell.iconFriend setContentMode:UIViewContentModeScaleAspectFill];
    [scCell.iconFriend setAutoresizingMask:UIViewAutoresizingNone];
    scCell.iconFriend.layer.borderWidth = 0.0f;
    [scCell.iconFriend setClipsToBounds:YES];
    scCell.iconFriend.layer.cornerRadius = CGRectGetHeight(scCell.iconFriend.frame)/2;
    
//    [scCell.vTriangle setBackgroundColor:[UIColor whiteColor]];
//    [scCell.vTriangle drawTrianMessage];
    [scCell.vTriangle setFrame:CGRectMake(xViewMain - 10, topSpacing + (sizeIcon.height / 2) - 5, 10, 10)];
    
//    UIImage *imgStatus = [helperIns getImageFromSVGName:@"icon-EyeGrey.svg"];
    [scCell.imgStatusMessage setFrame:CGRectMake(scCell.lblTime.frame.origin.x + scCell.lblTime.bounds.size.width, scCell.lblTime.frame.origin.y, scCell.lblTime.bounds.size.height, scCell.lblTime.bounds.size.height)];
//    [scCell.imgStatusMessage setImage:imgStatus];
//    [scCell.imgStatusMessage setBackgroundColor:[UIColor grayColor]];
}

- (void) renderImageCell:(SCMessageTableViewCellV2*)scCell withMessenger:(Messenger*)_message{
    [scCell.iconFriend setHidden:YES];
    [scCell.iconImage setHidden:NO];
    
    [scCell.viewMain setHidden:YES];
    [scCell.vTriangle setHidden:YES];
    [scCell.blackTriangle setHidden:YES];
    [scCell.viewImage setHidden:NO];
    [scCell.vMessengerImage setHidden:NO];
    [scCell.vMessengerImageShadow setHidden:NO];
    [scCell.vMessengerImageFriend setHidden:YES];
    
    CGFloat xIcon = self.bounds.size.width - (leftSpacing + sizeIcon.width);
    [scCell.iconImage setFrame:CGRectMake(xIcon, topSpacing / 2, sizeIcon.width, sizeIcon.height)];
    [scCell.iconImage setContentMode:UIViewContentModeScaleAspectFill];
    [scCell.iconImage setAutoresizingMask:UIViewAutoresizingNone];
    scCell.iconImage.layer.borderWidth = 0.0f;
    [scCell.iconImage setClipsToBounds:YES];
    scCell.iconImage.layer.cornerRadius = CGRectGetHeight(scCell.iconImage.frame) / 2;
    
    CGFloat wViewMessenger = self.bounds.size.width - (leftSpacing + sizeIcon.width + leftSpacing + leftSpacing + leftSpacing / 2);
    CGFloat xViewMessenger = self.bounds.size.width - (leftSpacing + sizeIcon.width + leftSpacing / 2 + wViewMessenger);

    [scCell.vMessengerImageShadow setFrame:CGRectMake(xViewMessenger, topSpacing / 2, scCell.vMessengerImageShadow.bounds.size.width, scCell.vMessengerImageShadow.bounds.size.height)];
    
    [scCell.vMessengerImage setFrame:CGRectMake(xViewMessenger, topSpacing / 2, wViewMessenger, 160)];
//    [scCell.vMessengerImage drawRight:CGRectMake(xViewMessenger, topSpacing / 2, wViewMessenger, 160)];
//    [scCell.vMessengerImage setBackgroundColor:[UIColor purpleColor]];
//    [scCell.vMessengerImage setImage:_message.thumnail withBlur:YES];

    if (_message.thumnailBlur) {
        [scCell.vMessengerImage setImage:_message.thumnailBlur];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *imgBlur = [self blurWithImageEffectsRestore:_message.thumnail withRadius:40];
            _message.thumnailBlur = imgBlur;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });

        });
    }
    
    [scCell.viewImage setFrame:CGRectMake(xViewMessenger, topSpacing / 2, scCell.viewImage.bounds.size.width, scCell.viewImage.bounds.size.height)];
    [scCell.viewImage setBackgroundColor:[UIColor clearColor]];
    scCell.viewImage.layer.zPosition = 10;
    
//    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake((scCell.viewImage.bounds.size.width / 2) - 25, (scCell.viewImage.bounds.size.height / 2) - 25, 50, 50)];
//    [circleView setClipsToBounds:YES];
//    [circleView setContentMode:UIViewContentModeScaleAspectFill];
//    [circleView setAutoresizingMask:UIViewAutoresizingNone];
//    circleView.layer.cornerRadius = circleView.bounds.size.width / 2;
//    circleView.layer.borderColor = [UIColor whiteColor].CGColor;
//    circleView.layer.borderWidth = 2.0f;
//    [scCell.viewImage addSubview:circleView];
}

- (void) renderImageCellFriend:(SCMessageTableViewCellV2*)scCell withMessenger:(Messenger*)_message{
    [scCell.iconFriend setHidden:NO];
    [scCell.iconImage setHidden:YES];
    
    [scCell.viewMain setHidden:YES];
    [scCell.vTriangle setHidden:YES];
    [scCell.blackTriangle setHidden:YES];
    [scCell.vMessengerImage setHidden:YES];
    [scCell.vMessengerImageFriend setHidden:NO];
    
//    CGFloat xViewMessenger = leftSpacing + sizeIcon.width + leftSpacing;
//    CGFloat wViewMessenger = self.bounds.size.width - (leftSpacing + sizeIcon.width + leftSpacing + leftSpacing);
    
    
}

- (void) setClearData:(BOOL)_isClear{
    clearData = _isClear;
}

- (void) reloadTableView{
    
}

- (UIImage *)blurWithImageEffectsRestore:(UIImage *)image withRadius:(CGFloat)_radius{
    
    return [image applyBlurWithRadius:_radius tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
    
}

- (UIImage *)takeSnapshotOfView:(UIView *)view
{
    CGFloat reductionFactor = 1;
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
