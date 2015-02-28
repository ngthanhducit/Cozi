//
//  SCHeaderFooterView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/5/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCHeaderFooterView.h"

@implementation SCHeaderFooterView

@synthesize lblTime;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariable];
    }
    
    return self;
}

- (void) initVariable{
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    imgClock = [helperIns getImageFromSVGName:@"icon-ClockGreen-v2.svg"];
}

- (void) initWithData:(DataWall*)_data withSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [view setBackgroundColor:[[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1] colorWithAlphaComponent:0.8]];
    
    UIImageView *imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    imgAvatar.layer.borderWidth = 0.0f;
    [imgAvatar setClipsToBounds:YES];
    imgAvatar.layer.cornerRadius = CGRectGetHeight(imgAvatar.frame) / 2;
    
    [view addSubview:imgAvatar];
    
    __weak DataWall *_wall = _data;
    [imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
    
    if (_wall.userPostID == storeIns.user.userID) {
        if (storeIns.user.thumbnail) {
            [imgAvatar setImage:storeIns.user.thumbnail];
        }
    }else{
        if (_wall.thumb) {
            [imgAvatar setImage:_wall.thumb];
        }else{
            UIImage *imgThumb = [storeIns getAvatarThumbFriend:_wall.userPostID];
            if (imgThumb) {
                _wall.thumb = imgThumb;
                [imgAvatar setImage:imgThumb];
            }else{
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_wall.urlAvatarThumb] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (image && finished) {
                        [imgAvatar setImage:image];
                        _wall.thumb = image;
                    }
                }];
            }
        }
    }
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width, 10000);
    CGSize sizeFullName ;
    CGSize sizeLocation ;
    
    TTTAttributedLabel *lblNickName = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(55, 5, self.bounds.size.width - 100, 20)];
    [lblNickName setDelegate:self];
    [lblNickName setTextAlignment:NSTextAlignmentJustified];
    lblNickName.font = [helperIns getFontLight:15.0f];
    lblNickName.textColor = [UIColor blackColor];
    lblNickName.lineBreakMode = NSLineBreakByCharWrapping;
    lblNickName.numberOfLines = 0;
    NSString *string = [NSString stringWithFormat:@"%@ %@", _wall.firstName, _wall.lastName];
    lblNickName.text = string;
    lblNickName.highlightedTextColor = [UIColor whiteColor];
    lblNickName.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    [lblNickName setFont:[helperIns getFontLight:12.0f]];
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableLinkAttributes setValue:(__bridge id)[[UIColor blackColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    lblNickName.linkAttributes = mutableLinkAttributes;
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
//    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
//    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
//    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    lblNickName.activeLinkAttributes = mutableActiveLinkAttributes;
    
    [view addSubview:lblNickName];
    
    NSRange r = [string rangeOfString:lblNickName.text];
    NSString *strLink = [NSString stringWithFormat:@"action://show-profile?%i", _data.userPostID];
    strLink = [strLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [lblNickName addLinkToURL:[NSURL URLWithString:strLink] withRange:r];
    
    if (_wall.longitude && _wall.longitude) {
        if (![_wall.longitude isEqualToString:@"0"] || ![_wall.latitude isEqualToString:@"0"]) {
            
            /* Create custom view to display section header... */
            
            sizeFullName = [string sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
            
            [lblNickName setFrame:CGRectMake(50, 5, sizeFullName.width + 80, 20)];
            
            NSString *strLocation = @"LONDON";
            sizeLocation = [strLocation sizeWithFont:[helperIns getFontLight:10.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
            
            UIImageView *imgLocation = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-LocationGreen.svg"]];
            //        [imgLocation setBackgroundColor:[UIColor redColor]];
            [imgLocation setFrame:CGRectMake(47, 22.5, 15, 15)];
            [imgLocation setContentMode:UIViewContentModeScaleAspectFill];
            [view addSubview:imgLocation];
            
            UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, sizeLocation.width, 10)];
            [lblLocation setText:strLocation];
            [lblLocation setFont:[helperIns getFontLight:10.0f]];
            [view addSubview:lblLocation];
            
        }else{
            /* Create custom view to display section header... */
            
            sizeFullName = [string sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
            
            [lblNickName setFrame:CGRectMake(50, 20 - (sizeFullName.height / 2), sizeFullName.width + 80, 20)];
            
        }
    }else{
        /* Create custom view to display section header... */
        
        sizeFullName = [string sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        
        [lblNickName setFrame:CGRectMake(50, 20 - (sizeFullName.height / 2), sizeFullName.width + 80, 20)];
    }

    //Calculation count down time
    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:storeIns.timeServer];
    NSDate *timeMessage = [helperIns convertStringToDate:_wall.time];
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
    
    timeAgo = [helperIns convertNSDateToString:timeMessage withFormat:@"HH:mm"];
    
    CGSize sizeTime = [timeAgo sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    self.lblTime = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - (sizeTime.width + 20), 20 - (sizeFullName.height / 2), sizeTime.width + 10, sizeTime.height)];
    [self.lblTime setBackgroundColor:[UIColor clearColor]];
    [self.lblTime setTextColor:[UIColor blackColor]];
    [self.lblTime setText:timeAgo];
    [self.lblTime setFont:[helperIns getFontLight:13.0f]];
    
    [view addSubview:self.lblTime];
    
    UIImageView *clock = [[UIImageView alloc] initWithImage:imgClock];
    [clock setFrame:CGRectMake(self.bounds.size.width - (sizeTime.width + 10 + 40), 0, 40, 40)];
    [view addSubview:clock];
    
    [self addSubview:view];
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
                NSNumber *headerUser = [NSNumber numberWithInt:[query intValue]];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:headerUser forKey:key];
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
@end
