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

- (void) drawRect:(CGRect)rect{
    
}

- (void) initVariable{
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
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
    
    DataWall *_wall = [storeIns.walls objectAtIndex:section];
    
    Friend *_friend = [storeIns getFriendByID:_wall.userPostID];
    if (_friend) {
        _wall.fullName = _friend.nickName;
        [imgAvatar setImage:_friend.thumbnail];
    }else{
        
        _wall.fullName = storeIns.user.nickName;
        [imgAvatar setImage:storeIns.user.thumbnail];
    }
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width, 10000);
    CGSize sizeFullName = { 0 , 0 };
    CGSize sizeLocation = { 0, 0 };
    
    if (_wall.longitude != 0 || _wall.latitude != 0) {
        
        /* Create custom view to display section header... */
        
        sizeFullName = [_wall.fullName sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, sizeFullName.width + 80, 20)];
        [lblFullName setFont:[helperIns getFontLight:15.0f]];
        [lblFullName setTextAlignment:NSTextAlignmentLeft];
        [lblFullName setTextColor:[UIColor blackColor]];
        [lblFullName setBackgroundColor:[UIColor clearColor]];
        
        NSString *string = [NSString stringWithFormat:@"%@", _wall.fullName];
        /* Section header is in 0th index... */
        
        [lblFullName setText:[string uppercaseString]];
        
        [view addSubview:lblFullName];
        
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
        
        sizeFullName = [_wall.fullName sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(50, 20 - (sizeFullName.height / 2), sizeFullName.width + 80, 20)];
        [lblFullName setFont:[helperIns getFontLight:15.0f]];
        [lblFullName setTextAlignment:NSTextAlignmentLeft];
        [lblFullName setTextColor:[UIColor blackColor]];
        [lblFullName setBackgroundColor:[UIColor clearColor]];
        
        NSString *string = [NSString stringWithFormat:@"%@", _wall.fullName];
        /* Section header is in 0th index... */
        
        [lblFullName setText:[string uppercaseString]];
        
        [view addSubview:lblFullName];
    }
    
    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:storeIns.timeServer];
    NSDate *timeMessage = [helperIns convertStringToDate:_wall.time];
    NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
    
    NSTimeInterval deltaWall = [[NSDate date] timeIntervalSinceDate:_dateTimeMessage];
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
    
    NSDate *_timeHeader = [helperIns convertStringToDate:_wall.time];
    timeAgo = [helperIns convertNSDateToString:_timeHeader withFormat:@"HH:mm:ss"];
    
    CGSize sizeTime = [timeAgo sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    self.lblTime = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - (sizeTime.width + 20), 20 - (sizeFullName.height / 2), sizeTime.width + 10, sizeTime.height)];
    [self.lblTime setBackgroundColor:[UIColor clearColor]];
    [self.lblTime setTextColor:[UIColor blackColor]];
    [self.lblTime setText:timeAgo];
    [self.lblTime setFont:[helperIns getFontLight:13.0f]];
    
    NSLog(@"set time: %@", self.lblTime.text);
    [view addSubview:self.lblTime];
    
    UIImageView *imgClock = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-ClockGreen.svg"]];
    [imgClock setFrame:CGRectMake(self.bounds.size.width - (sizeTime.width + 20 + 40), 0, 40, 40)];
    [view addSubview:imgClock];
    
    [self addSubview:view];
}
@end
