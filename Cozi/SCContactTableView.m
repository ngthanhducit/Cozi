//
//  SCContactTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/9/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCContactTableView.h"

@implementation SCContactTableView

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

- (void) initData:(NSMutableArray *)_contactList{
    contactList = _contactList;
    [self generateSectionTitles];
}

- (void) setup{
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    
    contacts = [[NSMutableDictionary alloc] init];
    selectList = [[NSMutableArray alloc] init];
    selectCell = [[NSMutableArray alloc] init];
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    self.sectionIndexBackgroundColor = [UIColor blackColor];
    self.sectionIndexColor = [UIColor whiteColor];
}

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
//    [label setTextColor:[UIColor lightGrayColor]];
//    [label setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
    
    NSString *string =[contactIndex objectAtIndex:section];
    /* Section header is in 0th index... */
    
    [label setText:string];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    
//    CALayer *topTitle = [CALayer layer];
//    [topTitle setFrame:CGRectMake(0.0f, 0, tableView.frame.size.width, 0.5f)];
//    [topTitle setBackgroundColor:[UIColor whiteColor].CGColor];
//    [view.layer addSublayer:topTitle];
//
//    CALayer *bottomTitle = [CALayer layer];
//    [bottomTitle setFrame:CGRectMake(0.0f, 18, tableView.frame.size.width, 0.5f)];
//    [bottomTitle setBackgroundColor:[UIColor whiteColor].CGColor];
//    [view.layer addSublayer:bottomTitle];
    
    return view;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sectionTitle = [contactIndex objectAtIndex:section];
    NSArray *sectionContacts = [contacts objectForKey:sectionTitle];
    
    return [sectionContacts count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    SCContactTableViewCell *cell = nil;

    cell = (SCContactTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SCContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

//    [cell setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    
    NSString *sectionTitle = [contactIndex objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contacts objectForKey:sectionTitle];
    __weak Friend *_friend = [sectionContacts objectAtIndex:indexPath.row];

//    if (_friend.statusFriend == 0) {
//        [cell.iconContact setImage:_friend.thumbnailOffline];
//    }else{
//        [cell.iconContact sd_setImageWithURL:[NSURL URLWithString:_friend.urlThumbnail] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    }
    
    if (![_friend.urlThumbnail isEqualToString:@""]) {
        [cell.iconContact sd_setImageWithURL:[NSURL URLWithString:_friend.urlThumbnail]];
    }else{
        
    }

    [cell.lblFullName setText:_friend.nickName];
    
    return cell;
}


//- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return contactIndex;
//}

- (void)setCellColor:(UIColor *)color ForCell:(SCContactTableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

-(void) generateSectionTitles {
    
    NSArray *alphaArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    contactIndex = [[NSMutableArray alloc] init];
    
    for (NSString *character in alphaArray) {
        
        if ([self stringPrefix:character isInArray:contactList]) {
            
            [contactIndex addObject:character];
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *sectionTitle = [contactIndex objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contacts objectForKey:sectionTitle];
    Friend *_friend = [sectionContacts objectAtIndex:indexPath.row];
    
    BOOL isExists = NO;
    if ([selectList count] > 0) {
        int count = (int)[selectList count];
        for (int i = 0; i < count; i++) {
            Friend *temp = (Friend*)[selectList objectAtIndex:i];
            if (temp.friendID == _friend.friendID) {
                [selectList removeObjectAtIndex:i];
                [selectCell removeObjectAtIndex:i];
                isExists= YES;
                break;
            }
        }
    }
    
    SCContactTableViewCell *cell = (SCContactTableViewCell*)[self cellForRowAtIndexPath:indexPath];
    if (!isExists) {
        [selectList addObject:_friend];
        [selectCell addObject:cell];
        [self setCellColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] ForCell:cell];
        [cell.imgViewCheck setHidden:NO];
        [cell.lblFullName setTextColor:[UIColor whiteColor]];
    }else{
        [self setCellColor:[UIColor lightGrayColor] ForCell:cell];
        [cell.imgViewCheck setHidden:YES];
        [cell.lblFullName setTextColor:[UIColor purpleColor]];
    }
    
    NSString *key = @"countSelect";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:(int)[selectList count]] forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCountSelect" object:nil userInfo:dictionary];
}

-(BOOL)stringPrefix:(NSString *)prefix isInArray:(NSArray *)array {
    
    BOOL result = FALSE;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (Friend *str in array) {
        __weak NSString *_strTemp = [str.nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

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

- (NSMutableArray*) getSelectList{
    return selectList;
}

- (void) resetCell{
    if ([selectCell count] > 0) {
        int count = (int)[selectCell count];
        for (int i = 0; i < count; i++) {
            SCContactTableViewCell *cell = (SCContactTableViewCell*)[selectCell objectAtIndex:i];
            [self setCellColor:[UIColor lightGrayColor] ForCell:cell];
            [cell.imgViewCheck setHidden:YES];
            [cell.lblFullName setTextColor:[UIColor purpleColor]];
        }
    }
    
    [selectList removeAllObjects];
}
@end
