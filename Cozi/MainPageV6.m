//
//  MainPageV6.m
//  VPix
//
//  Created by khoa ngo on 11/11/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "MainPageV6.h"
#import "ImageRender.h"
#import "SCCollectionViewLayout.h"
#import "Helper.h"

@implementation MainPageV6

@synthesize scCollection;
@synthesize itemInsets;
@synthesize itemSize;
@synthesize interItemSpacingY;
@synthesize numberOfColumns;

@synthesize viewInfo;
@synthesize lblFirstName;
@synthesize lblLastName;
@synthesize lblLocationInfo;
@synthesize userIns;
@synthesize storeIns;
@synthesize btnFollow;
@synthesize btnEditProfile;
@synthesize vFollowingUser;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _top=[self getHeaderHeight];
        _avartaH=frame.size.width;
        _searchH=160;
        [self initVariable];
    }
    
    return self;
}


- (void) initVariable{
    self.storeIns = [Store shareInstance];
    
    self.itemInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.itemSize = CGSizeMake(100.0f, 100.0f);
    self.interItemSpacingY = 4.0f;
    self.numberOfColumns = 3;
}

- (void) initFriend:(Profile *)_profile{
    waitingLoadAvatar = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [waitingLoadAvatar setFrame:CGRectMake(0, _top, self.bounds.size.width, _avartaH)];
    [self addSubview:waitingLoadAvatar];
    [waitingLoadAvatar startAnimating];
    
    profile = _profile;
    if (profile.imgAvatar) {
        [self drawAvatar:profile.imgAvatar];
    }else{
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_profile.avatar] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            profile.imgAvatar = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self drawAvatar:profile.imgAvatar];
            });
            
        }];
    }
    
    //check is profile public then render post history
    //else then show private history
    
    [self drawFriend];
    
    [lblFollowers setText:[NSString stringWithFormat:@"%i", profile.countFollower]];
    [lblFollowing setText:[NSString stringWithFormat:@"%i", profile.countFollowing]];
    [lblPosts setText:[NSString stringWithFormat:@"%i", profile.countPost]];
    
    [self initViewFollowing];
    [self initButtonFollowUser];
    
    BOOL isFollowing = [storeIns isFollowing:profile.userID];
    if (isFollowing) {
        [self.btnFollow setHidden:YES];
        [self.vFollowingUser setHidden:NO];
    }else{
        [self.btnFollow setHidden:NO];
        [self.vFollowingUser setHidden:YES];
    }
    
}

- (void) initUser:(User *)_user{
    user = _user;
    
    [self drawAvatar:user.avatar];
    
    [self drawFriend];
    
    [lblFollowers setText:[NSString stringWithFormat:@"%i", (int)[self.storeIns.listFollower count]]];
    [lblFollowing setText:[NSString stringWithFormat:@"%i", (int)[self.storeIns.listFollowing count]]];
    [lblPosts setText:[NSString stringWithFormat:@"%i", profile.countPost]];
    
    [self initEditProfile];
}

- (void) setNoisesHistory:(NSMutableArray*)_items{
    [waitingLoadHistory stopAnimating];
    
    items = _items;
    
    int fViewH=self.bounds.size.height;
    
    CGFloat columns = friendView.bounds.size.width / (self.itemSize.width + self.itemInsets.left + self.interItemSpacingY);
    CGFloat _columnFlood = floor(columns);
    CGFloat _columnMinus = columns - _columnFlood;
    CGFloat _columnResult = 0.0;
    if (_columnMinus > 0.8) {
        _columnResult = round(columns);
    }else{
        _columnResult = _columnFlood;
    }
    
    CGFloat widthCell = ((friendView.bounds.size.width - 8) / _columnResult);
    widthCell = widthCell < 100 ? 100 : widthCell;
    
    self.itemSize = CGSizeMake(widthCell, widthCell);

    double row = round([items count] / _columnResult);
    row += 2;
    CGFloat hContent = ((row) * widthCell);
    if (hContent < fViewH) {
        hContent = fViewH;
    }
    
    SCCollectionViewLayout *layout = [[SCCollectionViewLayout alloc] initWithData:self.itemInsets withItemSize:self.itemSize withSpacingY:self.interItemSpacingY withColumns:_columnResult];
    
    self.scCollection = [[SCNoiseCollectionView alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, hContent) collectionViewLayout:layout];
    [self.scCollection setFrame:CGRectMake(0, 0, self.bounds.size.width, hContent)];
    [self.scCollection initData:items withType:1];
    [self.scCollection setBackgroundColor:[UIColor whiteColor]];
    [self.scCollection setShowsHorizontalScrollIndicator:YES];
    [self.scCollection setShowsVerticalScrollIndicator:YES];
    [self.scCollection setScrollEnabled:NO];
    
    [friendView addSubview:self.scCollection];
    
    [friendView setFrame:CGRectMake(friendView.frame.origin.x, friendView.frame.origin.y, friendView.bounds.size.width, hContent)];
    
    [self setContentSizeContent:CGSizeMake(self.bounds.size.width, hContent)];
    
    [_mScroll setContentSize:CGSizeMake(self.bounds.size.width, _avartaH + _searchH + hContent)];
    
    [self.scCollection reloadData];
}

-(void) drawAvatar:(UIImage*)_imgAvatar{

    _avarta=[[UIImageView alloc] initWithFrame:CGRectMake(0, _top, self.bounds.size.width, _avartaH)];
    if (_avarta != nil) {
        [_avarta setImage:_imgAvatar];
        _avarta.layer.zPosition = -1;
        [self addSubview:_avarta];
    }
    
    [waitingLoadAvatar stopAnimating];
}

-(void) drawFriend
{
    int top=_top;
    int h=self.frame.size.height-top;
    int fViewH=self.bounds.size.height;

    _mScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, top, self.bounds.size.width, h)];
    [_mScroll setShowsHorizontalScrollIndicator:NO];
    [_mScroll setShowsVerticalScrollIndicator:NO];
    [_mScroll setContentSize:CGSizeMake(self.bounds.size.width, _avartaH + _searchH + fViewH)];
    [_mScroll setDelegate:self];
    [self addSubview:_mScroll];
    
    UIView *transView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _avartaH)];
    [_mScroll addSubview:transView];
    
    friendView=[[UIView alloc] initWithFrame:CGRectMake(0, _avartaH + _searchH, self.bounds.size.width, fViewH)];
    [friendView setBackgroundColor:[UIColor whiteColor]];
    [_mScroll addSubview:friendView];
    
    waitingLoadHistory = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [waitingLoadHistory setFrame:friendView.bounds];
    [waitingLoadHistory setBackgroundColor:[UIColor clearColor]];
    [friendView addSubview:waitingLoadHistory];
    [waitingLoadHistory startAnimating];
    
    [self initFollow];
    
//    [self initEditProfile];
    
    [self initPostHistoryHeader];
}

- (void) initFollow{
    Helper *hp = [Helper shareInstance];
    
    _followInfo=[[UIView alloc] initWithFrame:CGRectMake(0, _avartaH, self.bounds.size.width, _searchH)];
    _followInfo.backgroundColor=[UIColor clearColor];
    [_mScroll addSubview:_followInfo];
    
    UIView *vFollow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, (_searchH / 2) - 20)];
    [vFollow setBackgroundColor:[UIColor blackColor]];
    [_followInfo addSubview:vFollow];
    
    vFollowers = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 3, vFollow.bounds.size.height)];
    [vFollowers setBackgroundColor:[UIColor clearColor]];
    [vFollow addSubview:vFollowers];
    
    UITapGestureRecognizer *tapFollowers = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followersTap:)];
    [tapFollowers setNumberOfTapsRequired:1];
    [tapFollowers setNumberOfTouchesRequired:1];
    [vFollowers addGestureRecognizer:tapFollowers];
    
    CGSize size = { self.bounds.size.width, self.bounds.size.height };
    CGSize sizeTotalFollower = [@"198" sizeWithFont:[hp getFontLight:25.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize sizeTextFollower = [@"FOLLOWERS" sizeWithFont:[hp getFontLight:13.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat h = sizeTotalFollower.height + sizeTextFollower.height;
    
    lblFollowers = [[UILabel alloc] initWithFrame:CGRectMake(0, (vFollowers.bounds.size.height / 2) - (h / 2), vFollowers.bounds.size.width, sizeTotalFollower.height)];
    [lblFollowers setTextAlignment:NSTextAlignmentCenter];
    [lblFollowers setText:@"198"];
    [lblFollowers setTextColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor"]]];
    [lblFollowers setFont:[hp getFontLight:25.0f]];
    [vFollowers addSubview:lblFollowers];
    
    UILabel *lblTextFollowers = [[UILabel alloc] initWithFrame:CGRectMake(0, lblFollowers.bounds.size.height, vFollowers.bounds.size.width, sizeTextFollower.height)];
    [lblTextFollowers setTextAlignment:NSTextAlignmentCenter];
    [lblTextFollowers setText:@"FOLLOWERS"];
    [lblTextFollowers setTextColor:[UIColor whiteColor]];
    [lblTextFollowers setFont:[hp getFontLight:13.0f]];
    [vFollowers addSubview:lblTextFollowers];
    
    vFollowing = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 3, 0 , self.bounds.size.width / 3, vFollow.bounds.size.height)];
    [vFollowing setBackgroundColor:[UIColor clearColor]];
    [vFollow addSubview:vFollowing];
    
    UITapGestureRecognizer *tapFollowing = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followingTap:)];
    [tapFollowing setNumberOfTouchesRequired:1];
    [tapFollowing setNumberOfTapsRequired:1];
    [vFollowing addGestureRecognizer:tapFollowing];
    
    lblFollowing = [[UILabel alloc] initWithFrame:CGRectMake(0, (vFollowing.bounds.size.height / 2) - (h / 2), vFollowing.bounds.size.width, sizeTotalFollower.height)];
    [lblFollowing setTextAlignment:NSTextAlignmentCenter];
    [lblFollowing setText:@"12"];
    [lblFollowing setTextColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor"]]];
    [lblFollowing setFont:[hp getFontLight:25.0f]];
    [vFollowing addSubview:lblFollowing];
    
    UILabel *lblTextFollowing = [[UILabel alloc] initWithFrame:CGRectMake(0, lblFollowing.bounds.size.height, vFollowing.bounds.size.width, sizeTextFollower.height)];
    [lblTextFollowing setTextAlignment:NSTextAlignmentCenter];
    [lblTextFollowing setText:@"FOLLOWING"];
    [lblTextFollowing setTextColor:[UIColor whiteColor]];
    [lblTextFollowing setFont:[hp getFontLight:13.0f]];
    [vFollowing addSubview:lblTextFollowing];
    
    vPosts = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width / 3) * 2, 0, self.bounds.size.width / 3, vFollow.bounds.size.height)];
    [vPosts setBackgroundColor:[UIColor clearColor]];
    [vFollow addSubview:vPosts];
    
    UITapGestureRecognizer *tapPosts = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postsTap:)];
    [tapPosts setNumberOfTapsRequired:1];
    [tapPosts setNumberOfTouchesRequired:1];
    [vPosts addGestureRecognizer:tapPosts];
    
    lblPosts = [[UILabel alloc] initWithFrame:CGRectMake(0, (vPosts.bounds.size.height / 2) - (h / 2), vPosts.bounds.size.width, sizeTotalFollower.height)];
    [lblPosts setTextAlignment:NSTextAlignmentCenter];
    [lblPosts setText:@"69"];
    [lblPosts setTextColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor"]]];
    [lblPosts setFont:[hp getFontLight:25.0f]];
    [vPosts addSubview:lblPosts];
    
    UILabel *lblTextPost = [[UILabel alloc] initWithFrame:CGRectMake(0, lblPosts.bounds.size.height, vPosts.bounds.size.width, sizeTextFollower.height)];
    [lblTextPost setTextAlignment:NSTextAlignmentCenter];
    [lblTextPost setText:@"POST"];
    [lblTextPost setTextColor:[UIColor whiteColor]];
    [lblTextPost setFont:[hp getFontLight:13.0f]];
    [vPosts addSubview:lblTextPost];
    
    vAddFollow = [[UIView alloc] initWithFrame:CGRectMake(0, (_searchH / 2) - 20, self.bounds.size.width, (_searchH / 2) - 20)];
    [vAddFollow setBackgroundColor:[UIColor whiteColor]];
    [_followInfo addSubview:vAddFollow];
}

- (void) initViewFollowing{
    Helper *hp=[Helper shareInstance];
    
    self.vFollowingUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vAddFollow.bounds.size.width, vAddFollow.bounds.size.height)];
    [self.vFollowingUser setBackgroundColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor"]]];
    [self.vFollowingUser setUserInteractionEnabled:YES];
    [vAddFollow addSubview:self.vFollowingUser];
    
    CGSize sizeText = { self.bounds.size.width, CGFLOAT_MAX };
    CGSize sizeFollowing = [@"FOLLOWING" sizeWithFont:[hp getFontLight:18.0f] constrainedToSize:sizeText];
    
    CGFloat totalWidthSize = sizeFollowing.width + 30;
    
    UILabel *lblTitleFB = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width / 2) - (totalWidthSize / 2), vFollowingUser.bounds.size.height / 2 - 15, sizeFollowing.width, 30)];
    [lblTitleFB setText:@"FOLLOWING"];
    [lblTitleFB setFont:[hp getFontLight:18.0f]];
    [lblTitleFB setTextColor:[UIColor whiteColor]];
    [lblTitleFB setBackgroundColor:[UIColor clearColor]];
    [vFollowingUser addSubview:lblTitleFB];
    
    UIImageView *imgSelectFB = [[UIImageView alloc] initWithImage:[hp getImageFromSVGName:@"icon-TickWhite-V2.svg"]];
    [imgSelectFB setFrame:CGRectMake(lblTitleFB.frame.origin.x + sizeFollowing.width, vFollowingUser.bounds.size.height / 2 - 15, 30, 30)];
    [vFollowingUser addSubview:imgSelectFB];
}

- (void) initButtonFollowUser{
    Helper *hp=[Helper shareInstance];
    
    CGSize size = { self.bounds.size.width, self.bounds.size.height };
    
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor"]]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [hp imageWithView:triangleJoinNow];
    
    self.btnFollow = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnFollow setBackgroundColor:[UIColor whiteColor]];
    [self.btnFollow setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnFollow.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnFollow setContentMode:UIViewContentModeCenter];
    [self.btnFollow setFrame:CGRectMake(0, 0, vAddFollow.bounds.size.width, vAddFollow.bounds.size.height)];
    [self.btnFollow setTitle:[NSString stringWithFormat:@"FOLLOW %@ %@", [profile.firstName uppercaseString], [profile.lastName uppercaseString]] forState:UIControlStateNormal];
    [self.btnFollow.titleLabel setFont:[hp getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnFollow.titleLabel.text sizeWithFont:[hp getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnFollow setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnFollow.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [vAddFollow addSubview:self.btnFollow];
    
    self.waitingFollow = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.waitingFollow setFrame:vAddFollow.bounds];
    [vAddFollow addSubview:self.waitingFollow];
}

- (void) initEditProfile{
    Helper *hp=[Helper shareInstance];
    
    CGSize size = { self.bounds.size.width, self.bounds.size.height };
    
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor"]]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [hp imageWithView:triangleJoinNow];
    
    self.btnEditProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnEditProfile setBackgroundColor:[UIColor whiteColor]];
    [self.btnEditProfile setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnEditProfile.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnEditProfile setContentMode:UIViewContentModeCenter];
    [self.btnEditProfile setFrame:CGRectMake(0, 0, vAddFollow.bounds.size.width, vAddFollow.bounds.size.height)];
    [self.btnEditProfile setTitle:@"EDIT YOUR PROFILE" forState:UIControlStateNormal];
    [self.btnEditProfile.titleLabel setFont:[hp getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnEditProfile.titleLabel.text sizeWithFont:[hp getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnEditProfile setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnEditProfile.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.btnEditProfile setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [vAddFollow addSubview:self.btnEditProfile];
}

- (void) initPostHistoryHeader{
    Helper      *hp = [Helper shareInstance];
    
    UIView *hFriendView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, self.bounds.size.width, 40)];
    [hFriendView setBackgroundColor:[UIColor blackColor]];
    [_followInfo addSubview:hFriendView];
    
    UIImage *img = [hp getImageFromSVGName:@"icon-PhotosBlue.svg"];
    UIImageView *imgPostHistory = [[UIImageView alloc] initWithImage:img];
    [imgPostHistory setFrame:CGRectMake(10, 10, 20, 20)];
    [hFriendView addSubview:imgPostHistory];
    
    UILabel *lblPostHistory = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.bounds.size.width - 40, 40)];
    [lblPostHistory setText:@"POST HISTORY"];
    [lblPostHistory setTextColor:[UIColor whiteColor]];
    [lblPostHistory setFont:[hp getFontLight:20.0f]];
    [lblPostHistory setTextAlignment:NSTextAlignmentLeft];
    [hFriendView addSubview:lblPostHistory];
    
}

- (void) setContentSizeContent:(CGSize)contentSize{
    if (contentSize.height >= self.bounds.size.height) {
        [self.scCollection setFrame:CGRectMake(0, 0, self.bounds.size.width, contentSize.height)];
        [_mScroll setContentSize:CGSizeMake(self.bounds.size.width, _avartaH+_searchH+contentSize.height)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float y = scrollView.contentOffset.y;

    if (y < 0) {
        float num=-1*y;
        float nH=num+_avartaH;
        
        float scaleY=nH/_avartaH;
        int n=_avartaH*scaleY;
        int n1=self.frame.size.width*scaleY;
        _avarta.frame=CGRectMake(y, _top, n1, n);
    }
    else
    {
        if(y>_avartaH)
        {
            int delta=y-_avartaH;
//            _searchView.frame=CGRectMake(0, _avartaH+delta, self.frame.size.width, _searchH);
            [_followInfo setTransform:CGAffineTransformMakeTranslation(0, delta)];
        }
        else{
            [_followInfo setTransform:CGAffineTransformMakeTranslation(0, 0)];
        }
    }
}

- (void) followersTap:(UITapGestureRecognizer*)recognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationTapFollowers" object:nil];
}

- (void) followingTap:(UITapGestureRecognizer*)recognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationTapFollowing" object:nil];
}

- (void) postsTap:(UITapGestureRecognizer*)recognizer{
    NSLog(@"tap posts");
//    [_mScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [_followInfo setTransform:CGAffineTransformMakeTranslation(0, 0)];
//    [UIView animateWithDuration:0.2 animations:^{
//        [_followInfo setFrame:CGRectMake(0, 0, _followInfo.bounds.size.width, _followInfo.bounds.size.height)];
//    }];
}
@end
