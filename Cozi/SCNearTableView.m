//
//  SCNearTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/14/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCNearTableView.h"

@implementation SCNearTableView

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

- (void) setData:(NSMutableArray*)items{
    _nearItems = items;
}

- (void) addData:(NSMutableArray*)items{
    if (_nearItems != nil) {
        int count = (int)[items count];
        for (int i = 0; i < count; i++) {
            [_nearItems addObject:[items objectAtIndex:i]];
        }
    }else{
        _nearItems = [NSMutableArray new];
        _nearItems = items;
    }
}

- (void) setup{
    helperIns = [Helper shareInstance];
    hRow = 50;
    _nearItems = [NSMutableArray new];
//    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else
        return [_nearItems count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hRow;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    SCNearTableViewCell *scCell = nil;
    
    scCell = (SCNearTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (scCell == nil) {
        scCell = [[SCNearTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        
        CGSize textSize = { self.bounds.size.width, 10000.0 };
        CGSize sizeName = [@"SEND MY LOCATION" sizeWithFont:[helperIns getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize sizeVincity = [@"100 m" sizeWithFont:[helperIns getFontThin:11.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat h = sizeName.height + sizeVincity.height;
        CGFloat y = (hRow / 2) - (h / 2);
        
        [scCell.lblName setText:@"SEND MY LOCATION"];
        [scCell.lblName setFrame:CGRectMake(20, y, scCell.lblName.bounds.size.width, sizeName.height)];
        [scCell.lblName setFont:[helperIns getFontLight:11.0f]];
        
        [scCell.lblVincity setText:@"100 m"];
        [scCell.lblVincity setFrame:CGRectMake(20, y + sizeName.height, scCell.lblVincity.bounds.size.width, sizeVincity.height)];
        [scCell.lblVincity setFont:[helperIns getFontLight:11.0f]];
        [scCell.lblVincity setTextColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
        
        return scCell;
    }else if(indexPath.section == 1){
        NearLocation *_near = [_nearItems objectAtIndex:indexPath.row];
        
        NSArray *subName = [_near.nearName componentsSeparatedByString:@" "];
        CGSize textSize = { self.bounds.size.width, 10000.0 };
        CGSize sizeName = [[subName objectAtIndex:0] sizeWithFont:[helperIns getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize sizeVincity = [_near.vicinity sizeWithFont:[helperIns getFontThin:11.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat h = sizeName.height + sizeVincity.height;
        CGFloat y = (hRow / 2) - (h / 2);
        
        [scCell.lblName setText:_near.nearName];
        [scCell.lblName setFont:[helperIns getFontLight:15.0f]];
        [scCell.lblName setFrame:CGRectMake(20, y, scCell.lblName.bounds.size.width, sizeName.height)];
        
        [scCell.lblVincity setText:_near.vicinity];
        [scCell.lblVincity setFont:[helperIns getFontLight:11.0f]];
        [scCell.lblVincity setFrame:CGRectMake(20, y + sizeName.height, scCell.lblVincity.bounds.size.width, sizeVincity.height)];
        [scCell.lblVincity setTextColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
        
        return scCell;
    }
    
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SCNearTableViewCell *cell = (SCNearTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    UIColor *c = [UIColor whiteColor];
    NSAttributedString *textAttribute = [[NSAttributedString alloc] initWithString:cell.lblName.text attributes:@{ NSForegroundColorAttributeName : c }];
    [cell.lblName setAttributedText:textAttribute];

    NSAttributedString *vincityAttribute = [[NSAttributedString alloc] initWithString:cell.lblVincity.text attributes:@{ NSForegroundColorAttributeName : c }];
    [cell.lblVincity setAttributedText:vincityAttribute];
    
//    NSNumber *index = [[NSNumber alloc] initWithInteger:indexPath.row];
//    NSString *key = @"NearLocationIndex";
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:index forKey:key];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectNearLocation" object:nil userInfo:nil];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    SCNearTableViewCell *cell = (SCNearTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.lblName setTextColor:[UIColor blackColor]];
    [cell.lblVincity setTextColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
}

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Add your Colour.
//    SCNearTableViewCell *cell = (SCNearTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [self setCellColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] ForCell:cell];  //highlight colour
//}

//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Reset Colour.
//    SCNearTableViewCell *cell = (SCNearTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell.lblName setTextColor:[UIColor blackColor]];
//    [cell.lblVincity setTextColor:[UIColor redColor]];
//    
////    [self setCellColor:[UIColor colorWithWhite:1 alpha:1.000] ForCell:cell]; //normal color
//}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}
@end
