//
//  SCContactTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/9/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCContactTableView.h"

@implementation SCContactTableView

const CGSize        sizeIconContact = { 35 , 35};

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
    
    [self setBackgroundColor:[UIColor blackColor]];
    
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
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor blackColor]];
    
    NSString *string =[contactIndex objectAtIndex:section];
    /* Section header is in 0th index... */
    
    [label setText:string];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor blackColor]];
    
    CALayer *topTitle = [CALayer layer];
    [topTitle setFrame:CGRectMake(0.0f, 0, tableView.frame.size.width, 0.5f)];
    [topTitle setBackgroundColor:[UIColor whiteColor].CGColor];
    [view.layer addSublayer:topTitle];

    CALayer *bottomTitle = [CALayer layer];
    [bottomTitle setFrame:CGRectMake(0.0f, 18, tableView.frame.size.width, 0.5f)];
    [bottomTitle setBackgroundColor:[UIColor whiteColor].CGColor];
    [view.layer addSublayer:bottomTitle];
    
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
        cell = [[SCContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell setBackgroundColor:[UIColor blackColor]];
    
    NSString *sectionTitle = [contactIndex objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contacts objectForKey:sectionTitle];
    Friend *_friend = [sectionContacts objectAtIndex:indexPath.row];

    if (_friend.statusFriend == 0) {
        [cell.iconContact setImage:_friend.thumbnailOffline];
    }else{
        [cell.iconContact setImage:_friend.thumbnail];
    }
    
    [cell.iconContact setFrame:CGRectMake(10, (cell.bounds.size.height / 2) - (sizeIconContact.height / 2), sizeIconContact.width, sizeIconContact.height)];
    [cell.iconContact setBackgroundColor:[UIColor grayColor]];
    [cell.iconContact setContentMode:UIViewContentModeScaleAspectFill];
    [cell.iconContact setAutoresizingMask:UIViewAutoresizingNone];
    cell.iconContact.layer.borderWidth = 0.0f;
    [cell.iconContact setClipsToBounds:YES];
    cell.iconContact.layer.cornerRadius = cell.iconContact.bounds.size.height / 2;

    [cell.lblFullName setText:_friend.nickName];
    [cell.lblFullName setBackgroundColor:[UIColor blackColor]];
    [cell.lblFullName setFont:[helperIns getFontLight:13.0f]];
    [cell.lblFullName setTextColor:[UIColor whiteColor]];
    [cell.lblFullName setFrame:CGRectMake(60, 0, cell.bounds.size.width - 60, cell.bounds.size.height)];
    
    return cell;
}


- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
    return contactIndex;
}

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
    
//    NSString *dictObj = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    NSString *key = @"tapCellIndex";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_friend forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postTapCellIndex" object:nil userInfo:dictionary];

}

-(BOOL)stringPrefix:(NSString *)prefix isInArray:(NSArray *)array {
    
    BOOL result = FALSE;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (Friend *str in array) {
        NSString *_strTemp = [str.nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

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

@end
