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
    isOnTick = YES;
    spacing = 10;
    bottomSpacing = 50;
    deltaWithStatus = 60;
    spacingViewAllComment  = 10;
    spacingLineComment = 20;
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    networkControllerIns = [NetworkController shareInstance];
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setUserInteractionEnabled:YES];
//    [self setShowsHorizontalScrollIndicator:NO];
//    [self setShowsVerticalScrollIndicator:NO];
    [self setDelegate:self];
    [self setDataSource:self];
    
    self.bounces = YES;
    self.alwaysBounceVertical = YES;
    
    NSTimer *_timerTick = [[NSTimer alloc] initWithFireDate:storeIns.timeServer interval:60.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:_timerTick forMode:NSDefaultRunLoopMode];

}

- (void) initWithData:(NSMutableArray *)_data withType:(int)_type{
    if (_type == 1) {
        self.tableFooterView = nil;
        self.tableHeaderView = nil;
    }else{
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:refreshControl];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [spinner stopAnimating];
        spinner.hidesWhenStopped = NO;
        spinner.frame = CGRectMake(0, 0, 320, 44);
        //self.tableFooterView = spinner;
        
    }
    
    items = _data;
    type = _type;
}

#pragma -mark UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (type == 0) {
        return [storeIns.walls count];
    }else{
        return [items count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DataWall *_wall;
    if (type == 0) {
        _wall = [storeIns.walls objectAtIndex:section];
    }else{
        _wall = [items objectAtIndex:section];
    }

    SCHeaderFooterView *header = [[SCHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [header initWithData:_wall withSection:section];
    
    NSString *_timeCountDown = [self calTimeCoundDown:_wall.time];
    [header.lblTime setText:_timeCountDown];
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat totalHeight = [self calculationHeightRow:indexPath.section];
    
    return totalHeight;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"CellWall";
    SCWallTableViewCellV2 *scCell = nil;
    
    scCell = (SCWallTableViewCellV2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DataWall *_wall;
    if (type == 0) {
        _wall = [storeIns.walls objectAtIndex:indexPath.section];
    }else{
        _wall = [items objectAtIndex:indexPath.section];
    }
    
    if (scCell == nil) {
        scCell = [[SCWallTableViewCellV2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [scCell.btnMore setTag:indexPath.section];
    [scCell.btnMore addTarget:self action:@selector(btnMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [scCell.btnLike setTag:1000 + indexPath.section];
    [scCell.btnLike addTarget:self action:@selector(btnLike:) forControlEvents:UIControlEventTouchUpInside];
    
    [scCell.btnComment setTag:2000 + indexPath.section];
    [scCell.btnComment addTarget:self action:@selector(btnComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [scCell.vAllComment setTag:3000 + indexPath.section];
    
    [scCell.vLike setTag:4000 + indexPath.section];
    
    UITapGestureRecognizer *tapLikes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLikes:)];
    [tapLikes setNumberOfTapsRequired:1];
    [tapLikes setNumberOfTouchesRequired:1];
    [scCell.vLike addGestureRecognizer:tapLikes];
    
    if (_wall.isLike) {
        [scCell.btnLike setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    }else{
        [scCell.btnLike setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GrayColor1"]]];
    }
    
    _wall.content = [_wall.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_wall.codeType == 1) {  //image and text
        [scCell.lblStatusTextOnly setHidden:YES];
        [scCell.lblStatus setHidden:NO];
        [scCell.bottomStatusTextOnly setHidden:YES];
        [scCell.vImages setHidden:NO];
        
        [scCell.imgView sd_setImageWithURL:[NSURL URLWithString:_wall.urlFull] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];

        CGFloat heightMain = [self calculationHeightRow:indexPath.section];
        
        [scCell.mainView setFrame:CGRectMake(0, 0, scCell.bounds.size.width, heightMain)];
        [scCell.mainView setBackgroundColor:[UIColor whiteColor]];
        
        [scCell setWallData:_wall];
        
        //=========STATUS============
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@", _wall.firstName, _wall.lastName, _wall.content];
        [scCell setNickNameText:[NSString stringWithFormat:@"%@ %@", _wall.firstName, _wall.lastName]];
        [scCell setStatusText:_wall.content];
        
        [scCell setTextStatus];
        
        //calculation height cell + spacing top and bottom
        CGSize textSize = CGSizeMake(self.bounds.size.width - deltaWithStatus, 10000);
        CGSize sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];

        if (sizeStatus.height < 40) {
            if (sizeStatus.height > 20) {
                [scCell.imgQuotes setFrame:CGRectMake(scCell.imgQuotes.frame.origin.x, 5, scCell.imgQuotes.bounds.size.width, scCell.imgQuotes.bounds.size.height)];
            }else{
                [scCell.imgQuotes setFrame:CGRectMake(scCell.imgQuotes.frame.origin.x, 13, scCell.imgQuotes.bounds.size.width, scCell.imgQuotes.bounds.size.height)];
            }

            sizeStatus.height = 40;

        }else{
            [scCell.imgQuotes setFrame:CGRectMake(scCell.imgQuotes.frame.origin.x, 5, scCell.imgQuotes.bounds.size.width, scCell.imgQuotes.bounds.size.height)];
        }
        
        sizeStatus.height = sizeStatus.height < 40 ? 40 : sizeStatus.height;
        
        //============LIKE===========
        
        [scCell.vLike setFrame:CGRectMake(0, scCell.vImages.bounds.size.height, self.bounds.size.width, scCell.vLike.bounds.size.height)];
        
        [scCell.lblLike setText:[NSString stringWithFormat:@"%i LIKES", (int)[_wall.likes count]]];
        
        [scCell.vStatus setFrame:CGRectMake(scCell.vStatus.frame.origin.x, scCell.vLike.frame.origin.y + scCell.vLike.bounds.size.height, scCell.vStatus.bounds.size.width, sizeStatus.height + spacing)];
        [scCell.vStatus setBackgroundColor:[UIColor clearColor]];
        
        [scCell.lblStatus setFrame:CGRectMake(scCell.lblStatus.frame.origin.x, spacing, scCell.lblStatus.bounds.size.width, sizeStatus.height)];
        [scCell.lblStatus setBackgroundColor:[UIColor clearColor]];
        [scCell.lblStatus setDelegate:self];
        scCell.lblStatus.userInteractionEnabled = YES;
//        scCell.lblStatus.text = str;
//        scCell.lblStatus.textAlignment = NSTextAlignmentLeft;

//        //==========set hidden quotes
        [scCell.bottomLike setHidden:NO];
        [scCell.imgQuotes setHidden:NO];
        [scCell.imgQuotesWhite setHidden:YES];
        [scCell.imgQuotesWhiteRight setHidden:YES];

        //===========COMMENT=============
        if ([_wall.comments count] > 0) {
            [scCell.vComment setHidden:NO];
            if ([_wall.comments count] > 4) {
                [scCell.vAllComment setHidden:NO];
                
                [scCell.vAllComment setFrame:CGRectMake(scCell.vAllComment.frame.origin.x, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height + spacingViewAllComment, scCell.lblViewAllComment.bounds.size.width, 40)];
                [scCell.lblViewAllComment setText:[NSString stringWithFormat:@"View all %i comments", (int)[_wall.comments count]]];
                
                CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
                
                [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vAllComment.frame.origin.y + scCell.vAllComment.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
                
                [scCell.vTool setFrame:CGRectMake(0, scCell.vComment.frame.origin.y + scCell.vComment.bounds.size.height, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
                
                UITapGestureRecognizer  *tapViewAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapViewAll setNumberOfTapsRequired:1];
                [tapViewAll setNumberOfTouchesRequired:1];
                [scCell.vAllComment addGestureRecognizer:tapViewAll];

                UITapGestureRecognizer  *tapLableAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapLableAll setNumberOfTapsRequired:1];
                [tapLableAll setNumberOfTouchesRequired:1];
                [scCell.lblViewAllComment addGestureRecognizer:tapLableAll];
                
                UITapGestureRecognizer  *tapImageComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapImageComment setNumberOfTapsRequired:1];
                [tapImageComment setNumberOfTouchesRequired:1];
                [scCell.iconViewAllComment addGestureRecognizer:tapImageComment];

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
    
    }else if (_wall.codeType == 0){ //text only
        [scCell.lblStatusTextOnly setHidden:NO];
        [scCell.lblStatus setHidden:YES];
        [scCell.bottomStatusTextOnly setHidden:NO];
        [scCell.vImages setHidden:YES];
        
        CGFloat heightMain = [self calculationHeightRow:indexPath.section];
        
        [scCell.mainView setFrame:CGRectMake(0, 0, scCell.bounds.size.width, heightMain)];
        [scCell.mainView setBackgroundColor:[UIColor whiteColor]];
        
        [scCell setWallData:_wall];
        
        //=========STATUS============
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@", _wall.firstName, _wall.lastName, _wall.content];
        [scCell setNickNameText:[NSString stringWithFormat:@"%@ %@", _wall.firstName, _wall.lastName]];
        [scCell setStatusText:_wall.content];
        
        [scCell setTextStatus];
        
        //calculation height cell + spacing top and bottom
        CGSize textSize = CGSizeMake(self.bounds.size.width - deltaWithStatus, 10000);
        CGSize sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
        
        if (sizeStatus.height < 60) {
            sizeStatus.height = 60;
        }
        
        [scCell.lblStatusTextOnly setFrame:CGRectMake(scCell.lblStatusTextOnly.frame.origin.x, 10, scCell.lblStatusTextOnly.bounds.size.width, sizeStatus.height)];
        [scCell.lblStatusTextOnly setDelegate:self];
        scCell.lblStatusTextOnly.userInteractionEnabled = YES;
        
        //============LIKE===========
        
        [scCell.lblLike setText:[NSString stringWithFormat:@"%i LIKES", (int)[_wall.likes count]]];
        
        [scCell.vStatus setFrame:CGRectMake(scCell.vStatus.frame.origin.x, 0, scCell.vStatus.bounds.size.width, scCell.lblStatusTextOnly.bounds.size.height + spacing + spacing)];
//        [scCell.vStatus setBackgroundColor:[UIColor lightGrayColor]];
        
        //set line botton status view
        [scCell.bottomStatusTextOnly setFrame:CGRectMake(scCell.bottomStatusTextOnly.frame.origin.x, scCell.vStatus.bounds.size.height - 0.5, scCell.bottomStatusTextOnly.bounds.size.width, scCell.bottomStatusTextOnly.bounds.size.height)];
        
        [scCell.vLike setFrame:CGRectMake(scCell.vLike.frame.origin.x, scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height, scCell.vLike.bounds.size.width , scCell.vLike.bounds.size.height)];
        
        //==========set hidden quotes
        [scCell.imgQuotes setHidden:YES];
        [scCell.imgQuotesWhite setHidden:NO];
        [scCell.imgQuotesWhiteRight setHidden:NO];
        [scCell.imgQuotesWhite setFrame:CGRectMake(0, ((sizeStatus.height / 2 + spacing)) - (scCell.imgQuotesWhite.bounds.size.height / 2), scCell.imgQuotesWhite.bounds.size.width, scCell.imgQuotesWhite.bounds.size.height)];
        [scCell.imgQuotesWhiteRight setFrame:CGRectMake(scCell.imgQuotesWhiteRight.frame.origin.x, ((sizeStatus.height / 2) + spacing) - (scCell.imgQuotesWhite.bounds.size.height / 2), scCell.imgQuotesWhiteRight.bounds.size.width, scCell.imgQuotesWhiteRight.bounds.size.height)];
        
        //===========COMMENT=============
        if ([_wall.comments count] > 0) {
            [scCell.vComment setHidden:NO];
            
            if ([_wall.comments count] > 4) {
                [scCell.vAllComment setHidden:NO];
                
                [scCell.vAllComment setFrame:CGRectMake(scCell.vAllComment.frame.origin.x, scCell.vLike.frame.origin.y + scCell.vLike.bounds.size.height + spacingViewAllComment, scCell.lblViewAllComment.bounds.size.width, 40)];
                [scCell.lblViewAllComment setText:[NSString stringWithFormat:@"View all %i comments", (int)[_wall.comments count]]];
                
                CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
                
                [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vAllComment.frame.origin.y + scCell.vAllComment.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
                
                [scCell.vTool setFrame:CGRectMake(0, scCell.vComment.frame.origin.y + scCell.vComment.bounds.size.height, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
                
                UITapGestureRecognizer  *tapViewAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapViewAll setNumberOfTapsRequired:1];
                [tapViewAll setNumberOfTouchesRequired:1];
                [scCell.vAllComment addGestureRecognizer:tapViewAll];
                
                UITapGestureRecognizer  *tapLableAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapLableAll setNumberOfTapsRequired:1];
                [tapLableAll setNumberOfTouchesRequired:1];
                [scCell.lblViewAllComment addGestureRecognizer:tapLableAll];
                
                UITapGestureRecognizer  *tapImageComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapImageComment setNumberOfTapsRequired:1];
                [tapImageComment setNumberOfTouchesRequired:1];
                [scCell.iconViewAllComment addGestureRecognizer:tapImageComment];

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
            
            [scCell.vTool setFrame:CGRectMake(0, scCell.vStatus.frame.origin.y + scCell.vLike.bounds.size.height + scCell.vStatus.bounds.size.height, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
            [scCell.bottomLike setHidden:YES];
        }
        
        //===========Waiting=======
        [scCell.spinner setHidden:YES];
//        [scCell.spinner stopAnimating];
    }else if (_wall.codeType == 2){ //location
      
        NSString *strMap = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _wall.latitude, _wall.longitude, @"%7c" , _wall.latitude, _wall.longitude];

        [scCell.imgView sd_setImageWithURL:[NSURL URLWithString:strMap] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
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
        if (![_wall.content isEqualToString:@""]) {
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@", _wall.firstName, _wall.lastName, _wall.content];
            [scCell setNickNameText:[NSString stringWithFormat:@"%@ %@", _wall.firstName, _wall.lastName]];
            [scCell setStatusText:_wall.content];
            
            [scCell setTextStatus];
            
            //calculation height cell + spacing top and bottom
            CGSize textSize = CGSizeMake(self.bounds.size.width - deltaWithStatus, 10000);
            CGSize sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
            
            if (sizeStatus.height < 40) {
                sizeStatus.height = 40;
                [scCell.imgQuotes setFrame:CGRectMake(scCell.imgQuotes.frame.origin.x, 5, scCell.imgQuotes.bounds.size.width, scCell.imgQuotes.bounds.size.height)];
            }else{
                [scCell.imgQuotes setFrame:CGRectMake(scCell.imgQuotes.frame.origin.x, 5, scCell.imgQuotes.bounds.size.width, scCell.imgQuotes.bounds.size.height)];
            }
            
            [scCell.lblStatus setFrame:CGRectMake(scCell.lblStatus.frame.origin.x, 0, scCell.lblStatus.bounds.size.width, sizeStatus.height)];
            [scCell.lblStatus setBackgroundColor:[UIColor clearColor]];
            [scCell.lblStatus setDelegate:self];
            scCell.lblStatus.userInteractionEnabled = YES;
            
            [scCell.vStatus setFrame:CGRectMake(scCell.vStatus.frame.origin.x, scCell.vStatus.frame.origin.y + spacing, scCell.vStatus.bounds.size.width, scCell.lblStatus.bounds.size.height)];
        }
        
        //============LIKE===========
        
        [scCell.lblLike setText:[NSString stringWithFormat:@"%i LIKES", (int)[_wall.likes count]]];
        
        //==========set hidden quotes
        [scCell.bottomLike setHidden:NO];
        [scCell.imgQuotes setHidden:NO];
        [scCell.imgQuotesWhite setHidden:YES];
        [scCell.imgQuotesWhiteRight setHidden:YES];
        
        //===========View Distance==============
        CGFloat yDistance = scCell.vStatus.frame.origin.y + scCell.vStatus.bounds.size.height;
        
        [scCell.vDistance setFrame:CGRectMake(0, yDistance , self.bounds.size.width, 60)];
        [scCell.vDistance setBackgroundColor:[UIColor purpleColor]];
        
        //===========COMMENT=============
        if ([_wall.comments count] > 0) {
            if ([_wall.comments count] > 4) {
                [scCell.vAllComment setHidden:NO];
                
                [scCell.vAllComment setFrame:CGRectMake(scCell.vAllComment.frame.origin.x, scCell.vDistance.frame.origin.y + scCell.vDistance.bounds.size.height + spacingViewAllComment, scCell.lblViewAllComment.bounds.size.width, 40)];
                [scCell.lblViewAllComment setText:[NSString stringWithFormat:@"View all %i comments", (int)[_wall.comments count]]];
                
                CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
                
                [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vAllComment.frame.origin.y + scCell.vAllComment.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
                
                [scCell.vTool setFrame:CGRectMake(0, scCell.vComment.frame.origin.y + scCell.vComment.bounds.size.height, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
                
                UITapGestureRecognizer  *tapViewAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapViewAll setNumberOfTapsRequired:1];
                [tapViewAll setNumberOfTouchesRequired:1];
                [scCell.vAllComment addGestureRecognizer:tapViewAll];
                
                UITapGestureRecognizer  *tapLableAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapLableAll setNumberOfTapsRequired:1];
                [tapLableAll setNumberOfTouchesRequired:1];
                [scCell.lblViewAllComment addGestureRecognizer:tapLableAll];
                
                UITapGestureRecognizer  *tapImageComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAllComment:)];
                [tapImageComment setNumberOfTapsRequired:1];
                [tapImageComment setNumberOfTouchesRequired:1];
                [scCell.iconViewAllComment addGestureRecognizer:tapImageComment];

            }else{
                
                [scCell.vAllComment setHidden:YES];
                
                CGFloat heightComment = [self calculationHeightComemnt:indexPath.section];
                
                [scCell.vComment setFrame:CGRectMake(scCell.vComment.frame.origin.x, scCell.vDistance.frame.origin.y + scCell.vDistance.bounds.size.height, scCell.vComment.bounds.size.width, heightComment)];
                
                [scCell.vTool setFrame:CGRectMake(0, scCell.vComment.frame.origin.y + scCell.vComment.bounds.size.height + 10, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
            }
            
            [scCell renderComment];
            
        }else{
            [scCell.vAllComment setHidden:YES];
            [scCell.vComment setHidden:YES];
            
            [scCell.vTool setFrame:CGRectMake(0, scCell.vDistance.frame.origin.y + scCell.vDistance.bounds.size.height + 10, scCell.vTool.bounds.size.width, scCell.vTool.bounds.size.height)];
        }
        
        //===========Waiting=======
        if (!_wall.imgMaps) {
            [scCell.spinner setHidden:NO];
            [scCell.spinner startAnimating];
        }else{
            [scCell.spinner setHidden:YES];
            [scCell.spinner stopAnimating];
        }
        
    }
    
    return scCell;
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
                NSNumber *contentUser = [NSNumber numberWithInt:[query intValue]];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:contentUser forKey:key];
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

- (void) handleRefresh:(id)sender{
    [self setContentOffset:CGPointMake(0.0f, -60.0f) animated:YES];
    [refreshControl beginRefreshing];

    isEnd = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadNewWall" object:nil userInfo:nil];
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

- (void) stopRefesh{
    [refreshControl endRefreshing];
    
    CGFloat contentOffset = self.contentOffset.y;
    if (contentOffset < 0) {
        [self setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    }
    
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [spinner stopAnimating];
            self.tableFooterView = nil;
            
        });
    } completion:^(BOOL finished) {

    }];
}

- (void) stopLoadWall:(BOOL)_isEndData{
    isEnd = _isEndData;
    isMoreData = NO;
    [refreshControl endRefreshing];
    
    CGFloat contentOffset = self.contentOffset.y;
    if (contentOffset < 0) {
        [self setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    }

    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [spinner stopAnimating];
            self.tableFooterView = nil;
            
        });
    } completion:^(BOOL finished) {
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
    DataWall *_wall;
    if (type == 0) {
        _wall = [storeIns.walls objectAtIndex:indexPath];
    }else{
        _wall = [items objectAtIndex:indexPath];
    }
    
    //calculation height cell + spacing top and bottom
    NSString *str = [NSString stringWithFormat:@"%@ %@", _wall.fullName, _wall.content];
    CGSize textSize = CGSizeMake(self.bounds.size.width - deltaWithStatus, 10000);

    CGSize sizeComment = { 0, 0 };
    
    CGSize sizeStatus = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    
    //if size status < 40 then equal 40 else....
    sizeStatus.height = sizeStatus.height < 40 ? 40 : sizeStatus.height;
    
    CGFloat heightLike = 40;
    CGFloat heightViewAllComment = 0;
    CGFloat heightVToolKit = 30;
    CGFloat heightImage = self.bounds.size.width;
    CGFloat hDistance = 0;
    
    if (_wall.codeType == 1) {
        
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
        
    }else if (_wall.codeType == 0){
        heightImage = 0;
        sizeStatus.height = sizeStatus.height < 60 ? 60 : sizeStatus.height;
        
        if ([_wall.comments count] > 0) {
            
            sizeComment.height = [self calculationHeightComemnt:indexPath];
            
            if ([_wall.comments count] > 4) {
                heightViewAllComment = 40;
            }else{
                spacingViewAllComment = 0;
            }
        }else{
            spacingViewAllComment = 0;
        }
    }else if (_wall.codeType == 2){
        hDistance = 60;
        sizeStatus.height = sizeStatus.height < 60 ? 60 : sizeStatus.height;
        
        if ([_wall.comments count] > 0) {
            
            sizeComment.height = [self calculationHeightComemnt:indexPath];
            
            if ([_wall.comments count] > 4) {
                heightViewAllComment = 40;
            }else{
                spacingViewAllComment = 0;
            }
        }else{
            spacingViewAllComment = 0;
        }
        
    }
    
    CGFloat totalHeight = heightImage + heightLike + sizeStatus.height + sizeComment.height + heightViewAllComment + heightVToolKit + bottomSpacing + spacingViewAllComment + hDistance;
    
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
    DataWall *_wall;
    if (type == 0) {
        _wall = [storeIns.walls objectAtIndex:indexPath];
    }else{
        _wall = [items objectAtIndex:indexPath];
    }
    
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

- (void) stopStartOnTick:(BOOL)_isTick{
    isOnTick = _isTick;
}

- (void) onTick:(id)sender{
    
    if (isOnTick) {
        NSArray *paths = [self indexPathsForVisibleRows];
        
        for (NSIndexPath *path in paths) {
            DataWall *_wall;
            if (type == 0) {
                _wall = [storeIns.walls objectAtIndex:path.section];
            }else{
                _wall = [items objectAtIndex:path.section];
            }
            
            NSString *_timeCountDown = [self calTimeCoundDown:_wall.time];
            
            SCHeaderFooterView *viewHeader = (SCHeaderFooterView*)[self headerViewForSection:path.section];
            
            viewHeader.lblTime.text = _timeCountDown;
            
        }
    }
}

- (NSString*)calTimeCoundDown:(NSString*)strTime{
    NSDate *timeMessage = [helperIns convertStringToDate:strTime];
    
    NSDate *_endTimeMessage = [timeMessage dateByAddingTimeInterval:86400];
    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:storeIns.timeServer];
    
    NSDate *newDate = [_endTimeMessage dateByAddingTimeInterval:deltaTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *todayComps = [calendar components:(NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:_endTimeMessage];
    
    NSDateComponents *comps = [calendar components:(NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:newDate];
    
    comps.minute = todayComps.minute;
    comps.second = todayComps.second;
    
    NSDate *date = [calendar dateFromComponents:comps];
    
    NSDate *fromDate;
    NSDate *toDate;
    
    [calendar rangeOfUnit:(NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit) startDate:&fromDate
                 interval:NULL forDate:[NSDate date]];
    [calendar rangeOfUnit:(NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit) startDate:&toDate
                 interval:NULL forDate:date];
    
    NSDateComponents *difference = [calendar components:(NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit)
                                               fromDate:fromDate toDate:toDate options:0];
    
    NSInteger h = [difference hour];
    NSInteger m = [difference minute];
//    NSInteger s = [difference second];
    
    NSString *sHour, *sMinute, *sSecond;
    sHour = [NSString stringWithFormat:@"%i", h];
    sMinute = [NSString stringWithFormat:@"%i", m];
//    sSecond = [NSString stringWithFormat:@"%i", s];
    
//    if (s < 10) {
//        sSecond = [NSString stringWithFormat:@"0%i", s];
//    }
    
    if (m < 10) {
        sMinute = [NSString stringWithFormat:@"0%i", m];
    }
    
    if (h < 10) {
        sHour = [NSString stringWithFormat:@"0%i", h];
    }
    
    return [NSString stringWithFormat:@"%@:%@", sHour, sMinute];
}

- (void) btnMore:(id)sender{
    UIButton *btnMore = (UIButton*)sender;
    NSInteger _tagButton = btnMore.tag;
    NSLog(@"button click: %i", (int)_tagButton);
    
    DataWall *_wall;
    if (type == 0) {
        _wall = [storeIns.walls objectAtIndex:_tagButton];
    }else{
        _wall = [items objectAtIndex:_tagButton];
    }

    if (_wall.userPostID == storeIns.user.userID) {
        NSString *destructiveTitle = @"Delete"; //Action Sheet Button Titles
        NSString *other1 = @"Edit";
        NSString *share = @"Share";
        NSString *cancelTitle = @"Cancel";
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:destructiveTitle
                                      otherButtonTitles:share, other1, nil];
        
        [actionSheet showInView:self];
    }else{

        NSString *destructiveTitle = @"Report Inappropriate"; //Action Sheet Button Titles
        NSString *other1 = @"Copy Share URL";
        NSString *cancelTitle = @"Cancel";
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:destructiveTitle
                                      otherButtonTitles:other1, nil];
        
        [actionSheet showInView:self];
    }
    
}

- (void) btnLike:(id)sender{
    UIButton *btnLike = (UIButton*)sender;
    NSInteger _tagButton = btnLike.tag;
    
    NSArray *paths = [self indexPathsForVisibleRows];
    
    for (NSIndexPath *path in paths) {
        if (path.section == (_tagButton - 1000)) {
            DataWall *_wall;
            if (type == 0) {
                _wall = [storeIns.walls objectAtIndex:(_tagButton - 1000)];
            }else{
                _wall = [items objectAtIndex:(_tagButton - 1000)];
            }
            
            if (!_wall.isLike) {
                
                [_wall setIsLike:YES];
                [networkControllerIns addPostLike:_wall];
            }else{
                
                [_wall setIsLike:NO];
                [networkControllerIns removePostLike:_wall];
            }
        }
    }
}

- (void) btnComment:(id)sender{
    UIButton *btnComment = (UIButton*)sender;
    NSInteger _tagButton = btnComment.tag - 2000;
    DataWall *_wall ;
    if (type == 0) {
        _wall = [storeIns.walls objectAtIndex:_tagButton];
    }else{
        _wall = [items objectAtIndex:_tagButton];
    }
    
    if (_wall && _wall.userPostID > 0) {
        NSString *key = @"tapCommentInfo";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_wall forKey:key];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationTapComment" object:nil userInfo:dictionary];
    }
}

- (void) tapViewAllComment:(UIGestureRecognizer*)recognizer{
    UIView *viewAllComment = recognizer.view;
    
    NSInteger _tagComment = viewAllComment.tag - 3000;
    DataWall *_wall ;
    if (type == 0) {
        _wall = [storeIns.walls objectAtIndex:_tagComment];
    }else{
        _wall = [items objectAtIndex:_tagComment];
    }
    
    if (_wall && _wall.userPostID > 0) {
        NSString *key = @"tapCommentInfo";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_wall forKey:key];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationTapAllComment" object:nil userInfo:dictionary];
    }
}

- (void) tapLikes:(UIGestureRecognizer*)recognizer{
    UIView *viewLikes = recognizer.view;
    
    NSInteger _tagComment = viewLikes.tag - 4000;
    DataWall *_wall ;
    if (type == 0) {
        _wall = [storeIns.walls objectAtIndex:_tagComment];
    }else{
        _wall = [items objectAtIndex:_tagComment];
    }
    
    if (_wall && _wall.userPostID > 0) {
        NSString *key = @"tapLikesInfo";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_wall forKey:key];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationTapLikes" object:nil userInfo:dictionary];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            
        }
            break;
            
        case 1:
            
            break;
            
        default:
            break;
    }
}

@end
