//
//  SCWallTableViewV2.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/24/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCWallTableViewV2.h"

@implementation SCWallTableViewV2

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupVariable];
    }
    
    return self;
}

- (void) setupVariable{
    spacing = 10;
    bottomSpacing = 50;
    deltaWithStatus = 60;
    spacingViewAllComment  = 10;
    spacingLineComment = 20;
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    [self setDelegate:self];
    [self setDataSource:self];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:refreshControl];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner stopAnimating];
    spinner.hidesWhenStopped = NO;
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.tableFooterView = spinner;
    
    self.bounces = YES;
    self.alwaysBounceVertical = YES;
    
    NSTimer *_timerTick = [[NSTimer alloc] initWithFireDate:storeIns.timeServer interval:1.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:_timerTick forMode:NSDefaultRunLoopMode];
}

#pragma -mark UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [storeIns.walls count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return [storeIns.walls count];
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [view setBackgroundColor:[[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1] colorWithAlphaComponent:0.8]];
//    [view setBackgroundColor:[UIColor whiteColor]];
//    [view setAlpha:0.9];
    
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(0, 1);
//    view.layer.shadowOpacity = 1;
//    view.layer.shadowRadius = 1.0;
    
    UIImageView *imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    imgAvatar.layer.borderWidth = 0.0f;
    [imgAvatar setClipsToBounds:YES];
    imgAvatar.layer.cornerRadius = CGRectGetHeight(imgAvatar.frame)/2;
    
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
        [imgLocation setFrame:CGRectMake(50, 25, 10, 10)];
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

    CGSize sizeTime = [timeAgo sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - (sizeTime.width + 20), 20 - (sizeFullName.height / 2), sizeTime.width + 10, sizeTime.height)];
    [lblTime setBackgroundColor:[UIColor clearColor]];
    [lblTime setTextColor:[UIColor blackColor]];
    [lblTime setText:timeAgo];
    [lblTime setFont:[helperIns getFontLight:13.0f]];
    
    [view addSubview:lblTime];
    
    UIImageView *imgClock = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-ClockGreen.svg"]];
    [imgClock setFrame:CGRectMake(self.bounds.size.width - (sizeTime.width + 20 + 40), 0, 40, 40)];
    [view addSubview:imgClock];
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat totalHeight = [self calculationHeightRow:indexPath.section];
    
    return totalHeight;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    SCWallTableViewCellV2 *scCell = nil;
    
    scCell = (SCWallTableViewCellV2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DataWall *_wall = [storeIns.walls objectAtIndex:indexPath.section];
    
    if (scCell == nil) {
        scCell = [[SCWallTableViewCellV2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (_wall.typePost == 0) {
        
        //post with image and caption
        [scCell.imgView setImage:[_wall.images lastObject]];
        
        CGFloat heightMain = [self calculationHeightRow:indexPath.section];
        
        [scCell.mainView setFrame:CGRectMake(0, 0, scCell.bounds.size.width, heightMain)];
        [scCell.mainView setBackgroundColor:[UIColor whiteColor]];
        
        //set header scCell with fullname and avatar
        //==========HEADER========
        Friend *_friend = [storeIns getFriendByID:_wall.userPostID];
        if (_friend) {
            _wall.fullName = _friend.nickName;
            
            scCell.imgAvatar.image = _friend.thumbnail;
        }else{
            
            _wall.fullName = storeIns.user.nickName;
            scCell.imgAvatar.image = storeIns.user.thumbnail;
        }
        
        [scCell setWallData:_wall];
        
        //=========STATUS============
        NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, _wall.content];
        [scCell setNickNameText:_wall.fullName];
        [scCell setStatusText:_wall.content];
        
        [scCell setTextStatus];
        
        //calculation height cell + spacing top and bottom
        CGSize textSize = CGSizeMake(self.bounds.size.width - deltaWithStatus, 10000);
        CGSize sizeStatus = { 0 , 0 };
        sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
        
        if (sizeStatus.height < 40) {
            sizeStatus.height = 40;
            [scCell.imgQuotes setFrame:CGRectMake(scCell.imgQuotes.frame.origin.x, 5, scCell.imgQuotes.bounds.size.width, scCell.imgQuotes.bounds.size.height)];
        }else{
            [scCell.imgQuotes setFrame:CGRectMake(scCell.imgQuotes.frame.origin.x, -5, scCell.imgQuotes.bounds.size.width, scCell.imgQuotes.bounds.size.height)];
        }
        
//        sizeStatus.height = sizeStatus.height < 40 ? 40 : sizeStatus.height;
        
        [scCell.lblStatus setFrame:CGRectMake(scCell.lblStatus.frame.origin.x, 0, scCell.lblStatus.bounds.size.width, sizeStatus.height)];
        [scCell.lblStatus setBackgroundColor:[UIColor clearColor]];
        [scCell.lblStatus setDelegate:self];
        scCell.lblStatus.userInteractionEnabled = YES;
        //============LIKE===========
        
        [scCell.lblLike setText:[NSString stringWithFormat:@"%i Likes", (int)[_wall.likes count]]];
        
        [scCell.vStatus setFrame:CGRectMake(scCell.vStatus.frame.origin.x, scCell.vStatus.frame.origin.y + spacing, scCell.vStatus.bounds.size.width, scCell.lblStatus.bounds.size.height)];
        
        //==========set hidden quotes
        [scCell.bottomLike setHidden:NO];
        [scCell.imgQuotes setHidden:NO];
        [scCell.imgQuotesWhite setHidden:YES];
        [scCell.imgQuotesWhiteRight setHidden:YES];
        
        //===========COMMENT=============
        if ([_wall.comments count] > 0) {
            if ([_wall.comments count] > 4) {
                [scCell.vAllComment setHidden:NO];
                
                [scCell.vAllComment setFrame:CGRectMake(scCell.vAllComment.frame.origin.x, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height + spacingViewAllComment, scCell.lblViewAllComment.bounds.size.width, 40)];
                [scCell.lblViewAllComment setText:[NSString stringWithFormat:@"View all %i comments", (int)[_wall.comments count]]];
                
                CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
                
                [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vAllComment.frame.origin.y + scCell.vAllComment.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
                
                [scCell.vTool setFrame:CGRectMake(0, scCell.vComment.frame.origin.y + scCell.vComment.bounds.size.height, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
            }else{
                
                [scCell.vAllComment setHidden:YES];
                
                CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
                
                [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
                
                [scCell.vTool setFrame:CGRectMake(0, scCell.vComment.frame.origin.y + scCell.vComment.bounds.size.height + 10, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
            }
            
            [scCell renderComment];
    
        }else{
            [scCell.vAllComment setHidden:YES];
            [scCell.vComment setHidden:YES];
            
            [scCell.vTool setFrame:CGRectMake(0, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height + 10, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
        }
        
        //===========Waiting=======
        if (![_wall.images count] > 0) {
            [scCell.spinner setHidden:NO];
            [scCell.spinner startAnimating];
        }else{
            [scCell.spinner setHidden:YES];
            [scCell.spinner stopAnimating];
        }
        
    }else{
        
        CGFloat heightMain = [self calculationHeightRow:indexPath.section];
        
        [scCell.mainView setFrame:CGRectMake(0, 0, scCell.bounds.size.width, heightMain)];
        [scCell.mainView setBackgroundColor:[UIColor whiteColor]];
        
        //set header scCell with fullname and avatar
        //==========HEADER========
        Friend *_friend = [storeIns getFriendByID:_wall.userPostID];
        if (_friend) {
            _wall.fullName = _friend.nickName;
            
            scCell.imgAvatar.image = _friend.thumbnail;
        }else{
            
            _wall.fullName = storeIns.user.nickName;
            scCell.imgAvatar.image = storeIns.user.thumbnail;
        }
        
        [scCell setWallData:_wall];
        
        //=========STATUS============
        NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, _wall.content];
        [scCell setNickNameText:_wall.fullName];
        [scCell setStatusText:_wall.content];
        
        [scCell setTextStatus];
        
        //calculation height cell + spacing top and bottom
        CGSize textSize = CGSizeMake(self.bounds.size.width - deltaWithStatus, 10000);
        CGSize sizeStatus = { 0 , 0 };
        sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
        
        if (sizeStatus.height < 60) {
            sizeStatus.height = 60;
            [scCell.imgQuotes setFrame:CGRectMake(scCell.imgQuotes.frame.origin.x, 5, scCell.imgQuotes.bounds.size.width, scCell.imgQuotes.bounds.size.height)];
        }
        
        [scCell.lblStatus setFrame:CGRectMake(scCell.lblStatus.frame.origin.x, 0, scCell.lblStatus.bounds.size.width, sizeStatus.height)];
        [scCell.lblStatus setDelegate:self];
        scCell.lblStatus.userInteractionEnabled = YES;
        
        //============LIKE===========
        
        [scCell.lblLike setText:[NSString stringWithFormat:@"%i Likes", (int)[_wall.likes count]]];
        
        [scCell.vStatus setFrame:CGRectMake(scCell.vStatus.frame.origin.x, 0, scCell.vStatus.bounds.size.width, scCell.lblStatus.bounds.size.height)];
        [scCell.vStatus setBackgroundColor:[UIColor lightGrayColor]];
        
        [scCell.vLike setFrame:CGRectMake(scCell.vLike.frame.origin.x, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height, scCell.vLike.bounds.size.width , scCell.vLike.bounds.size.height)];
        
        //==========set hidden quotes
        [scCell.imgQuotes setHidden:YES];
        [scCell.imgQuotesWhite setHidden:NO];
        [scCell.imgQuotesWhiteRight setHidden:NO];
        [scCell.imgQuotesWhite setFrame:CGRectMake(0, (sizeStatus.height / 2) - (scCell.imgQuotesWhite.bounds.size.height / 2), scCell.imgQuotesWhite.bounds.size.width, scCell.imgQuotesWhite.bounds.size.height)];
        [scCell.imgQuotesWhiteRight setFrame:CGRectMake(scCell.imgQuotesWhiteRight.frame.origin.x, (sizeStatus.height / 2) - (scCell.imgQuotesWhite.bounds.size.height / 2), scCell.imgQuotesWhiteRight.bounds.size.width, scCell.imgQuotesWhiteRight.bounds.size.height)];
        
        //===========COMMENT=============
        if ([_wall.comments count] > 0) {
            if ([_wall.comments count] > 4) {
                [scCell.vAllComment setHidden:NO];
                
                [scCell.vAllComment setFrame:CGRectMake(scCell.vAllComment.frame.origin.x, scCell.vLike.frame.origin.y + scCell.vLike.bounds.size.height + spacingViewAllComment, scCell.lblViewAllComment.bounds.size.width, 40)];
                [scCell.lblViewAllComment setText:[NSString stringWithFormat:@"View all %i comments", (int)[_wall.comments count]]];
                
                CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
                
                [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vAllComment.frame.origin.y + scCell.vAllComment.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
                
                [scCell.vTool setFrame:CGRectMake(0, scCell.vComment.frame.origin.y + scCell.vComment.bounds.size.height, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
                
                //hidden bottom if viewallcomment view exists
                [scCell.bottomLike setHidden:YES];
            }else{
                
                [scCell.vAllComment setHidden:YES];
                
                CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
                
                [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vLike.frame.origin.y + scCell.vLike.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
                
                [scCell.vTool setFrame:CGRectMake(0, scCell.vComment.frame.origin.y + scCell.vComment.bounds.size.height + 10, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
                
                [scCell.bottomLike setHidden:NO];
            }
            
            [scCell renderComment];
            
        }else{
            [scCell.vAllComment setHidden:YES];
            [scCell.vComment setHidden:YES];
            
            [scCell.vTool setFrame:CGRectMake(0, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height + 10, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
        }
        
        //===========Waiting=======
        [scCell.spinner setHidden:YES];
        [scCell.spinner stopAnimating];
    }
    
    return scCell;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"show-profile"]) {
//             load help screen
            NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            Friend *_friend = [storeIns getFriendByID:[query intValue]];
            
            if (_friend != nil) {
                NSString *key = @"tapCellIndex";
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_friend forKey:key];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postTapCellIndex" object:nil userInfo:dictionary];
            }

            NSLog(@"user post: %@", query);
        } else if ([[url host] hasPrefix:@"show-tag"]) {
            /* load settings screen */
            NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"Click Tag %@", query);
        }
    } else {
        /* deal with http links here */
    }
}

- (void) handleRefresh:(id)sender{
    [self setContentOffset:CGPointMake(0.0f, -60.0f) animated:YES];
    [refreshControl beginRefreshing];
    NSLog(@"change value");
    isEnd = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadNewWall" object:nil userInfo:nil];
//    [refreshControl endRefreshing];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 20;
    if(y > h + reload_distance) {
        if (!spinner.isAnimating && !isMoreData && !isEnd) {
            isMoreData = YES;
            NSLog(@"load more data");
            
            self.tableFooterView = spinner;
            [spinner startAnimating];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMoreWall" object:nil userInfo:nil];
            
        }
    }
    
    lastOffset = offset;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) {
        
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

- (void) stopLoadWall:(BOOL)_isEndData{
    isEnd = _isEndData;
    isMoreData = NO;
    [refreshControl endRefreshing];
    
    CGFloat contentOffset = self.contentOffset.y;
    if (contentOffset < 0) {
        [self setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });

    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [spinner stopAnimating];
            self.tableFooterView = nil;
            
        });
    } completion:^(BOOL finished) {
        [self setNeedsDisplay];
        [self reloadData];
    }];

}

/**
 *  calculation height row wall
 *
 *  @param indexPath index data
 *
 *  @return height row
 */
- (CGFloat) calculationHeightRow:(NSInteger)indexPath{
    DataWall *_wall = [storeIns.walls objectAtIndex:indexPath];
    
    //calculation height cell + spacing top and bottom
    NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, _wall.content];
    CGSize textSize = CGSizeMake(self.bounds.size.width - deltaWithStatus, 10000);
    CGSize sizeStatus = { 0 , 0 };
    CGSize sizeComment = { 0, 0 };
    sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    //if size status < 40 then equal 40 else....
    sizeStatus.height = sizeStatus.height < 40 ? 40 : sizeStatus.height;
    
    CGFloat heightLike = 40;
    CGFloat heightViewAllComment = 0;
    CGFloat heightVToolKit = 30;
    CGFloat heightImage = self.bounds.size.width;
    
    if (_wall.typePost == 0) {
        
        if ([_wall.comments count] > 0) {
            int max = 4;
            if ([_wall.comments count] < 4) {
                int count = (int)[_wall.comments count];
                max = count;
            }
            
            int count = (int)[_wall.comments count];
            for (int i = count - 1; i >= count - max; i--) {
                PostComment *postComment = (PostComment*)[_wall.comments objectAtIndex:i];
                NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, postComment.contentComment];
                CGSize tempSize = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
                sizeComment.height += tempSize.height + spacingLineComment;
                sizeComment.width += tempSize.width;
            }
            
            sizeComment.height += 10;
            
            if ([_wall.comments count] > 4) {
                heightViewAllComment = 40;
            }
        }
        
    }else if (_wall.typePost == 1){
        heightImage = 0;
        sizeStatus.height = sizeStatus.height < 60 ? 60 : sizeStatus.height;
        
        if ([_wall.comments count] > 0) {
            
            sizeComment.height = [self calculationHeightComemnt:indexPath];
            
            if ([_wall.comments count] > 4) {
                heightViewAllComment = 40;
            }
        }
    }
    
    CGFloat totalHeight = heightImage + heightLike + sizeStatus.height + sizeComment.height + heightViewAllComment + heightVToolKit + bottomSpacing + spacingViewAllComment;
    
    return totalHeight;
}

/**
 *  Calculation height 4 comment
 *
 *  @param indexPath index row
 *
 *  @return height row
 */
- (CGFloat) calculationHeightComemnt:(NSInteger)indexPath{
    DataWall *_wall = [storeIns.walls objectAtIndex:indexPath];
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width - deltaWithStatus, 10000);
    CGSize sizeComment = { 0, 0 };

    if ([_wall.comments count] > 0) {
        int max = 4;
        if ([_wall.comments count] < 4) {
            int count = (int)[_wall.comments count];
            max = count;
        }
        
        int count = (int)[_wall.comments count];
        for (int i = count - 1; i >= count - max; i--) {
            PostComment *postComment = (PostComment*)[_wall.comments objectAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, postComment.contentComment];
            CGSize tempSize = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
            sizeComment.height += tempSize.height + spacingLineComment;
            sizeComment.width += tempSize.width;
        }
        
    }
    
    CGFloat totalHeight = sizeComment.height + 10;
    
    return totalHeight;
}

- (void) onTick:(id)sender{
    
    NSArray *paths = [self indexPathsForVisibleRows];
    NSMutableSet *visibleCells = [NSMutableSet new];
    for (NSIndexPath *path in paths) {
        DataWall *_wall = [storeIns.walls objectAtIndex:path.row];
        SCWallTableViewCellV2 *scCell = (SCWallTableViewCellV2*)[self cellForRowAtIndexPath:path];
        
        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:storeIns.timeServer];
        NSDate *timeMessage = [helperIns convertStringToDate:_wall.time];
        NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
        
        NSTimeInterval deltaWall = [[NSDate date] timeIntervalSinceDate:_dateTimeMessage];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                                            fromDate:_dateTimeMessage
                                                              toDate:[NSDate date]
                                                             options:0];
    }
}
@end
