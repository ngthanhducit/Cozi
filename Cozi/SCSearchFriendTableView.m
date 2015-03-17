//
//  SCSearchFriendTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/11/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCSearchFriendTableView.h"

@implementation SCSearchFriendTableView

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

- (void) initData:(NSMutableArray *)_searchFriend{
    contactList = _searchFriend;
    [self generateSectionTitles];
}

- (void) setup{
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    
    contacts = [[NSMutableDictionary alloc] init];

    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self setUserInteractionEnabled:NO];
//    ((UIScrollView*)[self superview]).delaysContentTouches = NO;
//    ((UIScrollView*)[self superview]).delegate = self;
    [self setDelaysContentTouches:NO];
    [self setDelegate:self];
    [self setDataSource:self];
    self.sectionIndexBackgroundColor = [UIColor blackColor];
    self.sectionIndexColor = [UIColor whiteColor];
}

//- (BOOL) touchesShouldCancelInContentView:(UIView *)view{
//    if ([view isKindOfClass:[UIButton class]]) {
//        return YES;
//    }
//    
//    return [super touchesShouldCancelInContentView:view];
//}

#pragma -mark UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [contactIndex count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [contactIndex objectAtIndex:section];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, tableView.frame.size.width, 17)];
    [label setFont:[helperIns getFontLight:12.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor grayColor]];
    [label setBackgroundColor:[UIColor whiteColor]];
    
    NSString *string =[contactIndex objectAtIndex:section];
    /* Section header is in 0th index... */
    
    [label setText:string];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sectionTitle = [contactIndex objectAtIndex:section];
    NSArray *sectionContacts = [contacts objectForKey:sectionTitle];
    
    return [sectionContacts count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    SCSearchFriendTableViewCell *scCell = nil;
    
    scCell = (SCSearchFriendTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCSearchFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [scCell setBackgroundColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1]];
    
    NSString *sectionTitle = [contactIndex objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contacts objectForKey:sectionTitle];
    
    UserSearch *_userSearch = [sectionContacts objectAtIndex:indexPath.row];

    [scCell.imgAvatar setImage:[helperIns getDefaultAvatar]];
    
    if (_userSearch.imgThumbnail) {
        
        scCell.imgAvatar.image = _userSearch.imgThumbnail;
        
    }else{
        if (![_userSearch.urlAvatar isEqualToString:@""]) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_userSearch.urlAvatar] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
                if (image && finished) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [scCell.imgAvatar setImage:image];
                        _userSearch.imgThumbnail = image;
                    });
                }
                
            }];
        }

    }
    
    [scCell.lblFullName setText:[NSString stringWithFormat:@"%@ %@", _userSearch.firstName, _userSearch.lastName]];
    
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddFriend:)];
    [tap setNumberOfTapsRequired:1];
    [tap  setNumberOfTouchesRequired:1];
    [scCell.vAddFriend addGestureRecognizer:tap];
    
    [scCell.btnAddFriend addTarget:self action:@selector(btnAddFriendClick:) forControlEvents:UIControlEventTouchUpInside];
    [scCell.btnAddFriend setTag:[indexPath section] * 1000 + [indexPath row]];
    BOOL isFriend = [storeIns isFriend:_userSearch.friendID];
    if (isFriend) {
//        [scCell.btnAddFriend setEnabled:NO];
        [scCell.vAddFriend setHidden:YES];
        [scCell.btnAddFriend setHidden:NO];
        
        [scCell.btnAddFriend setUserInteractionEnabled:NO];
        [scCell.btnAddFriend setBackgroundColor:[UIColor purpleColor]];
        [scCell.btnAddFriend setTitle:@"ADDED" forState:UIControlStateNormal];
        
        _userSearch.isAddFriend = 0;
    }else{
        [scCell.vAddFriend setHidden:YES];
        [scCell.btnAddFriend setHidden:NO];
        
        [scCell.btnAddFriend setUserInteractionEnabled:YES];
        [scCell.btnAddFriend setBackgroundColor:[UIColor clearColor]];
        [scCell.btnAddFriend setTitle:@"ADD" forState:UIControlStateNormal];
        
        if (_userSearch.isAddFriend == 1) {
            [scCell.btnAddFriend setHidden:YES];
            [scCell.vAddFriend setHidden:NO];
            UIActivityIndicatorView *waiting = (UIActivityIndicatorView*)[scCell.vAddFriend viewWithTag:6666];
            [waiting startAnimating];
        }else{
            [scCell.vAddFriend setHidden:YES];
            [scCell.btnAddFriend setHidden:NO];
        }
        
    }
    
    for (UIView *currentView in tableView.subviews) {
        if ([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }

    
    return scCell;
}

- (void)setCellColor:(UIColor *)color ForCell:(SCSearchFriendTableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

-(void) generateSectionTitles {
    
    NSArray *alphaArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    
    contactIndex = [[NSMutableArray alloc] init];
    
    for (NSString *character in alphaArray) {
        
        if ([self stringPrefix:character isInArray:contactList]) {
            
            [contactIndex addObject:character];
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [storeIns playSoundPress];
    
    NSString *sectionTitle = [contactIndex objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contacts objectForKey:sectionTitle];
    UserSearch *_userSearch = [sectionContacts objectAtIndex:indexPath.row];
    
    if (storeIns.user.userID == _userSearch.friendID) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
    }else{
        NSString *key = @"tapFriend";
        NSNumber *nFriend = [NSNumber numberWithInt:_userSearch.friendID];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:nFriend forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
    }
    
}

-(BOOL)stringPrefix:(NSString *)prefix isInArray:(NSArray *)array {
    
    BOOL result = FALSE;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (Friend *str in array) {
        __weak NSString *_strTemp = [str.firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSRange prefixRange = [_strTemp rangeOfString:prefix options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
        if (prefixRange.location != NSNotFound) {
            [temp addObject:str];
            result = TRUE;
        }
    }
    
    if (temp != nil && [temp count] > 0) {
        [contacts setValue:temp forKey:prefix];
    }
    
    return result;
}

-(BOOL)stringPrefix:(NSString *)prefix isInNSString:(NSString *)str {
    
    BOOL result = FALSE;
    
    NSRange prefixRange = [str rangeOfString:prefix options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
    if (prefixRange.location != NSNotFound) {
        result = TRUE;
    }
    
    return result;
}

- (void) tapAddFriend:(UITapGestureRecognizer*)recognizer{
    [storeIns playSoundPress];
    
    CGPoint tapLocation = [recognizer locationInView:self];
    NSIndexPath *tapIndexPath = [self indexPathForRowAtPoint:tapLocation];
    SCSearchFriendTableViewCell *scCell = (SCSearchFriendTableViewCell*)[self cellForRowAtIndexPath:tapIndexPath];
    
    UIView *vAddFriend = scCell.vAddFriend;
    UIActivityIndicatorView *waiting = (UIActivityIndicatorView*)[vAddFriend viewWithTag:6666];
    if (waiting.isAnimating) {
        [waiting stopAnimating];
        [scCell.vAddFriend setBackgroundColor:[UIColor clearColor]];
    }else{
        [waiting startAnimating];
        [scCell.vAddFriend setBackgroundColor:[UIColor orangeColor]];
    }
    
//    UILabel *lblText = (UILabel*)[vAddFriend viewWithTag:7777];

}

- (void) btnAddFriendClick:(id)sender{
    [storeIns playSoundPress];
    UIButton *btnAddFriend = (UIButton*)sender;
    [btnAddFriend setHighlighted:YES];

    int section = [btnAddFriend tag] / 1000;
    int row = [btnAddFriend tag] % 1000;
    
    NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    SCSearchFriendTableViewCell *scCell = (SCSearchFriendTableViewCell*)[self cellForRowAtIndexPath:_indexPath];
    [scCell.vAddFriend setHidden:NO];
    [scCell.btnAddFriend setHidden:YES];
    UIActivityIndicatorView *waiting = (UIActivityIndicatorView*)[scCell.vAddFriend viewWithTag:6666];
    [waiting startAnimating];

    NSString *sectionTitle = [contactIndex objectAtIndex:section];
    NSArray *sectionContacts = [contacts objectForKey:sectionTitle];
    UserSearch *_userSearch = [sectionContacts objectAtIndex:row];
    [_userSearch setIsAddFriend:1];
    
    NSString *key = @"addFriend";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_userSearch forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationAddFriend" object:nil userInfo:dictionary];

}

@end
