//
//  SCWallTableView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/24/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCWallTableView.h"

@implementation SCWallTableView

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{
    storeIns = [Store shareInstance];
    helperIns = [Helper shareInstance];
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:[UIColor clearColor]];

}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [storeIns.walls count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DataWall *_wall = [storeIns.walls objectAtIndex:indexPath.row];
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width - 20, 10000);
    CGSize sizeStatus = { 0 , 0 };
    
    sizeStatus = [_wall.content sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGFloat totalHeight = (self.bounds.size.width - 20) + 40 + 60 + sizeStatus.height + 60 + /* 20 = spacing top and bottom */20;
    NSLog(@"height row %f", totalHeight);
    return totalHeight;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";

    SCWallTableViewCell *scCell = nil;
    
    scCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    DataWall *_wall = [storeIns.walls objectAtIndex:indexPath.row];
    
    if (scCell == nil) {
        scCell = [[SCWallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    [scCell setFrame:CGRectMake(0, 0, scCell.bounds.size.width
//                                , scCell.bounds.size.height)];
    
    NSLog(@"height: %f", scCell.bounds.size.height) ;
    
    [scCell.imgView setImage:[_wall.images lastObject]];
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width - 20, 10000);
    CGSize sizeStatus = { 0 , 0 };
    
    sizeStatus = [_wall.content sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    [scCell.mainView setFrame:CGRectMake(10, 10, scCell.bounds.size.width - 20
                                         , (self.bounds.size.width - 20) + 40 + 60 + sizeStatus.height + 60 + /* 20 = spacing top and bottom */10)];
    
    Friend *_friend = [storeIns getFriendByID:_wall.userPostID];
    if (_friend) {
        _wall.fullName = _friend.nickName;
        
        scCell.imgAvatar.image = _friend.thumbnail;
    }else{
        
        _wall.fullName = storeIns.user.nickName;
        scCell.imgAvatar.image = storeIns.user.thumbnail;
    }
    
    scCell.lblFullName.text = _wall.fullName;
    
    [scCell.lblStatus setText:_wall.content];
    [scCell.lblStatus setFrame:CGRectMake(10, 10, scCell.bounds.size.width, sizeStatus.height)];
    
    [scCell setBackgroundColor:[UIColor clearColor]];
    
    return scCell;
}
@end
