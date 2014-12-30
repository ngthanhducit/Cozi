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
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
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
//    [view setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1]];
    [view setBackgroundColor:[UIColor purpleColor]];
    [view setAlpha:0.8];
    
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
    
    /* Create custom view to display section header... */
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width, 10000);
    CGSize sizeFullName = { 0 , 0 };
    
    sizeFullName = [_wall.fullName sizeWithFont:[helperIns getFontLight:13.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(55, 20 - (sizeFullName.height / 2), sizeFullName.width + 80, sizeFullName.height)];
    [lblFullName setFont:[helperIns getFontLight:13.0f]];
    [lblFullName setTextAlignment:NSTextAlignmentCenter];
    [lblFullName setTextColor:[UIColor blackColor]];
    [lblFullName setBackgroundColor:[UIColor clearColor]];
    
    NSString *string = [NSString stringWithFormat:@"%@ - %@", _wall.fullName, _wall.clientKey];
    /* Section header is in 0th index... */
    
    [lblFullName setText:string];
    
    [view addSubview:lblFullName];
    
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
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DataWall *_wall = [storeIns.walls objectAtIndex:indexPath.section];
    
//    //calculation height cell + spacing top and bottom
//    NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, _wall.content];
//    CGSize textSize = CGSizeMake(self.bounds.size.width - 20, 10000);
//    CGSize sizeStatus = { 0 , 0 };
//    CGSize sizeComment = { 0, 0 };
//    sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
//    
//    CGFloat heightLike = 0;
//    CGFloat heightStatus = sizeStatus.height;
//    CGFloat heightViewAllComment = 0;
//    
//    if ([_wall.likes count] > 0) {
//        heightLike = 20;
//    }
//    
//    if ([_wall.comments count] > 0) {
//        int max = 4;
//        if ([_wall.comments count] < 4) {
//            int count = (int)[_wall.comments count];
//            max = count;
//        }
//        
//        int count = (int)[_wall.comments count];
//        for (int i = count - 1; i > count - max; i--) {
//            PostComment *postComment = (PostComment*)[_wall.comments objectAtIndex:i];
//            NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, postComment.contentComment];
//            CGSize tempSize = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
//            sizeComment.height += tempSize.height;
//            sizeComment.width += tempSize.width;
//        }
//        
//        heightViewAllComment = 20;
//    }
//    
//    CGFloat totalHeight = (self.bounds.size.width) + heightLike + heightStatus + sizeComment.height + heightViewAllComment + spacing;
    
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
    
    [scCell.imgView setImage:[_wall.images lastObject]];
    
    CGFloat heightStatus = 18.5;
    
    CGFloat heightMain = [self calculationHeightRow:indexPath.section];
    
    [scCell.mainView setFrame:CGRectMake(0, 0, scCell.bounds.size.width, heightMain)];
    [scCell.mainView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1]];
    
    [scCell.vTool setFrame:CGRectMake(0, (heightMain - scCell.vTool.bounds.size.height), scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
    
    Friend *_friend = [storeIns getFriendByID:_wall.userPostID];
    if (_friend) {
        _wall.fullName = _friend.nickName;
        
        scCell.imgAvatar.image = _friend.thumbnail;
    }else{
        
        _wall.fullName = storeIns.user.nickName;
        scCell.imgAvatar.image = storeIns.user.thumbnail;
    }
    
    [scCell setWallData:_wall];
    
    NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, _wall.content];
    [scCell setNickNameText:_wall.fullName];
    [scCell setStatusText:_wall.content];
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width - 20, 10000);
    CGSize sizeStatus = { 0 , 0 };
    sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    [scCell.lblStatus setFrame:CGRectMake(0, 0, scCell.lblStatus.bounds.size.width, sizeStatus.height)];
    [scCell.lblStatus setDelegate:self];
    scCell.lblStatus.userInteractionEnabled = YES;
    
    //============
    
    if ([_wall.likes count] > 0) {
        [scCell.lblLike setHidden:NO];
        [scCell.vLike setHidden:NO];
        
        [scCell.lblLike setText:[NSString stringWithFormat:@"%i likes", (int)[_wall.likes count]]];
        [scCell.vStatus setFrame:CGRectMake(scCell.vStatus.frame.origin.x, scCell.vStatus.frame.origin.y, scCell.vStatus.bounds.size.width, scCell.lblStatus.bounds.size.height)];
    }else{
        [scCell.lblLike setHidden:YES];
        [scCell.vLike setHidden:YES];
        [scCell.vStatus setFrame:CGRectMake(scCell.vStatus.frame.origin.x, scCell.vStatus.frame.origin.y - 20, scCell.vStatus.bounds.size.width, scCell.lblStatus.bounds.size.height)];
    }
    
    //===========
    if ([_wall.comments count] > 0) {
        if ([_wall.comments count] > 4) {
            [scCell.lblViewAllComment setFrame:CGRectMake(scCell.lblViewAllComment.frame.origin.x, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height, scCell.lblViewAllComment.bounds.size.width, scCell.lblViewAllComment.bounds.size.height)];
            [scCell.lblViewAllComment setText:[NSString stringWithFormat:@"View all %i comments", (int)[_wall.comments count]]];
            
            CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
            
            [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.lblViewAllComment.frame.origin.y + scCell.lblViewAllComment.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
        }else{

            [scCell.lblViewAllComment setHidden:YES];
            
            CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
            
            [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
        }
        
        [scCell renderComment];
    }else{
        [scCell.lblViewAllComment setHidden:YES];
        [scCell.vComment setHidden:YES];
    }
    
    //Waiting=======
    if (![_wall.images count] > 0) {
        [scCell.spinner setHidden:NO];
        [scCell.spinner startAnimating];
    }else{
        [scCell.spinner setHidden:YES];
        [scCell.spinner stopAnimating];
    }
    
    return scCell;
}

- (UIView*) buildAgreeTextViewFromString:(NSString *)localizedString{
    UIView      *result = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 0)];
    
    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"^tt^"];
    
    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    for (NSUInteger i = 0; i < msgChunkCount; i++)
    {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
        if ([chunk isEqualToString:@""])
        {
            continue;     // skip this loop if the chunk is empty
        }
        
        // 3. Determine what type of word this is:
        BOOL isUserPost = [chunk hasPrefix:@"!"];
        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"#"];
        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"@"];
        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink | isUserPost);
        
        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [[UILabel alloc] init];
        label.font = [helperIns getFontLight:14.0f];
        label.text = chunk;
        [label setTextColor:[UIColor blackColor]];
        label.userInteractionEnabled = isLink;
        
        if (isLink)
        {
            label.textColor = [UIColor colorWithRed:110/255.0f green:181/255.0f blue:229/255.0f alpha:1.0];
            label.highlightedTextColor = [UIColor yellowColor];
            
            // 5. Set tap gesture for this clickable text:
            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:selectorAction];
            [label addGestureRecognizer:tapGesture];
            
            if (isUserPost) label.text = [label.text stringByReplacingOccurrencesOfString:@"!" withString:@""];
        }
        else
        {
            label.textColor = [UIColor blackColor];
        }
        
        // 6. Lay out the labels so it forms a complete sentence again:
        
        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:
        
        [label sizeToFit];
        
        if (result.frame.size.width < wordLocation.x + label.bounds.size.width)
        {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line
            
            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
                                                                options:NSRegularExpressionSearch];
            if (startingWhiteSpaceRange.location == 0)
            {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
                                                                 withString:@""];
                [label sizeToFit];
            }
        }
        
        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x,
                                 wordLocation.y,
                                 label.frame.size.width,
                                 label.frame.size.height);
        // Show this label:
        [result addSubview:label];
        
        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }

    [result setFrame:CGRectMake(0, 0, self.bounds.size.width, wordLocation.y + 18.5)];
    
    return result;
}

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"User tapped on the Terms of Service link");
    }
}

- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"User tapped on the Privacy Policy link");
    }
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
    NSLog(@"change value");
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
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        if (!spinner.isAnimating) {

            NSLog(@"load more data");
            
            self.tableFooterView = spinner;
            [spinner startAnimating];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMoreWall" object:nil userInfo:nil];
            
        }
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) {
        
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    isMoreData = NO;

    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [spinner stopAnimating];
        self.tableFooterView = nil;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) stopLoadWall{
    
    isMoreData = NO;
    [refreshControl endRefreshing];
}

- (CGFloat) calculationHeightRow:(NSInteger)indexPath{
    DataWall *_wall = [storeIns.walls objectAtIndex:indexPath];
    
    //calculation height cell + spacing top and bottom
    NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, _wall.content];
    CGSize textSize = CGSizeMake(self.bounds.size.width - 20, 10000);
    CGSize sizeStatus = { 0 , 0 };
    CGSize sizeComment = { 0, 0 };
    sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat heightLike = 0;
    CGFloat heightViewAllComment = 0;
    
    if ([_wall.likes count] > 0) {
        heightLike = 20;
    }
    
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
            sizeComment.height += tempSize.height;
            sizeComment.width += tempSize.width;
        }
        
        if ([_wall.comments count] > 4) {
            heightViewAllComment = 20;
        }
    }
    
    CGFloat totalHeight = (self.bounds.size.width) + heightLike + sizeStatus.height + sizeComment.height + heightViewAllComment + spacing + 40;
    
    return totalHeight;
}

- (CGFloat) calculationHeightComemnt:(NSInteger)indexPath{
    DataWall *_wall = [storeIns.walls objectAtIndex:indexPath];
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width - 20, 10000);
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
            sizeComment.height += tempSize.height;
            sizeComment.width += tempSize.width;
        }
        
    }
    
    CGFloat totalHeight = sizeComment.height;
    
    return totalHeight;
}
@end
