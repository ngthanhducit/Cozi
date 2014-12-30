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

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _top=[self getHeaderHeight];
        _avartaH=frame.size.height/3;
        _searchH=30;
        [self initVariable];
        
        [self drawFriend];
    }
    
    return self;
}


- (void) initVariable{
    self.storeIns = [Store shareInstance];
    
    self.itemInsets = UIEdgeInsetsMake(10.0f, 20.0f, 10.0f, 20.0f);
    self.itemSize = CGSizeMake(110.0f, 110.0f);
    self.interItemSpacingY = 10.0f;
    self.numberOfColumns = 2;
}

-(void) drawAvatar{
    
//    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"tam_tit" ofType:@"jpg"];
//    NSData *data=[NSData dataWithContentsOfFile:filePath];
//    UIImage *uImg=[[UIImage alloc] initWithData:data];
    
//    UIImage *uImg=[[UIImage alloc] initWithData:self.userIns.avatar];
    
    ImageRender *render=[[ImageRender alloc] init];
    CGRect rect=CGRectMake(0, 0, self.frame.size.width, _avartaH);
    UIImage *sImg=[render cutImageByRect:self.userIns.avatar frame:rect];
    
    _avarta=[[UIImageView alloc] initWithFrame:CGRectMake(0, _top, self.bounds.size.width, _avartaH)];
    if (_avarta != nil) {
        [_avarta setImage:sImg];
        [self addSubview:_avarta];
    }

    
    [self drawFriend];
}

-(void) drawFriend
{
    int top=_top;
    int h=self.frame.size.height-top;
    int fViewH=self.bounds.size.height;
    Helper *hp=[Helper shareInstance];
    
    _mScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, top, self.bounds.size.width, h)];
    [_mScroll setShowsHorizontalScrollIndicator:NO];
    [_mScroll setShowsVerticalScrollIndicator:NO];
    [_mScroll setContentSize:CGSizeMake(self.bounds.size.width, _avartaH+_searchH+fViewH)];
    [_mScroll setDelegate:self];
    [self addSubview:_mScroll];
    
    UIView *transView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _avartaH)];
    [_mScroll addSubview:transView];
    
    friendView=[[UIView alloc] initWithFrame:CGRectMake(0, _avartaH+_searchH, self.bounds.size.width, fViewH)];
    friendView.backgroundColor=[UIColor whiteColor];
    [_mScroll addSubview:friendView];
    
    CGFloat columns = friendView.bounds.size.width / (self.itemSize.width + self.itemInsets.left + self.interItemSpacingY);
    CGFloat _columnFlood = floor(columns);
    CGFloat _columnMinus = columns - _columnFlood;
    CGFloat _columnResult = 0.0;
    if (_columnMinus > 0.8) {
        _columnResult = round(columns);
    }else{
        _columnResult = _columnFlood;
    }
    
    CGFloat widthCell = (friendView.bounds.size.width / _columnResult) - 25;
    widthCell = widthCell < 100 ? 100 : widthCell;
    
    self.itemSize = CGSizeMake(widthCell, widthCell);
    
    SCCollectionViewLayout *layout = [[SCCollectionViewLayout alloc] initWithData:self.itemInsets withItemSize:self.itemSize withSpacingY:self.interItemSpacingY withColumns:_columnResult];
    
    self.scCollection = [[SCCollectionViewController alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, fViewH + 10) collectionViewLayout:layout];
    [self.scCollection setBackgroundColor:[UIColor clearColor]];
    [self.scCollection setScrollEnabled:NO];
    [friendView addSubview:self.scCollection];
    
    _searchView=[[UIView alloc] initWithFrame:CGRectMake(0, _avartaH, self.bounds.size.width, _searchH)];
    _searchView.backgroundColor=[hp colorWithHex:0x00a6aa];
    [_mScroll addSubview:_searchView];
}

- (void) setContentSizeContent:(CGSize)contentSize{
    if (contentSize.height >= self.bounds.size.height) {
        [friendView setFrame:CGRectMake(0, _avartaH+_searchH, self.bounds.size.width, contentSize.height)];
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
            [_searchView setTransform:CGAffineTransformMakeTranslation(0, delta)];
        }
        else{
            [_searchView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        }
    }
}

- (void) initMyInfo:(User *)_myUser{
    Helper *hp=[Helper shareInstance];
    [self.viewInfo removeFromSuperview];
    
    self.userIns = _myUser;
    
    self.viewInfo = [[UIView alloc] init];
    [self.viewInfo setBackgroundColor:[UIColor clearColor]];
    
    CGSize textSize = { 260.0, 10000.0 };
    
    self.lblFirstName = [[UILabel alloc] init];
    [self.lblFirstName setBackgroundColor:[UIColor clearColor]];
    [self.lblFirstName setTextColor:[UIColor whiteColor]];
    [self.lblFirstName setTextAlignment:NSTextAlignmentLeft];
    [self.lblFirstName setText:[_myUser.firstname uppercaseString]];
    [self.lblFirstName setFont:[hp getFontThin:23.0f]];
    
    CGSize sizeFirstName = [[self.lblFirstName.text uppercaseString] sizeWithFont:[hp getFontThin:23.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    [self.viewInfo addSubview:self.lblFirstName];
    
    [self.lblFirstName setFrame:CGRectMake(0, 0, sizeFirstName.width, sizeFirstName.height)];
    
    self.lblLastName= [[UILabel alloc] init];
    [self.lblLastName setBackgroundColor:[UIColor clearColor]];
    [self.lblLastName setTextAlignment:NSTextAlignmentRight];
    [self.lblLastName setTextColor:[UIColor whiteColor]];
    [self.lblLastName setFont:[hp getFontThin:23.0f]];
    [self.lblLastName setText:[_myUser.lastName uppercaseString]];
    
    CGSize sizeLastName = [[self.lblLastName.text uppercaseString] sizeWithFont:[hp getFontThin:23.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    [self.viewInfo addSubview:self.lblLastName];
    
    [self.lblLastName setFrame:CGRectMake(self.lblFirstName.bounds.size.width + 3, 0, sizeLastName.width, sizeLastName.height)];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"LLLL d"];
    NSString *strTime = [[DateFormatter stringFromDate:[NSDate date]] uppercaseString];
    
    self.lblLocationInfo = [[UILabel alloc] init];
    [self.lblLocationInfo setBackgroundColor:[UIColor clearColor]];
    [self.lblLocationInfo setTextColor:[UIColor whiteColor]];
    [self.lblLocationInfo setTextAlignment:NSTextAlignmentLeft];
    [self.lblLocationInfo setFont:[hp getFontThin:15.0f]];
    [self.lblLocationInfo setText:[NSString stringWithFormat:@"%@ | HO CHI MINH CITY", strTime]];
    
    CGSize sizeLocationInfo = [[self.lblLocationInfo.text uppercaseString] sizeWithFont:[hp getFontThin:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.lblLocationInfo setFrame:CGRectMake(0, self.lblFirstName.bounds.size.height, sizeLocationInfo.width, sizeLocationInfo.height)];
    
    [self.viewInfo addSubview:self.lblLocationInfo];
    
    CGFloat h = self.lblFirstName.bounds.size.height + self.lblLocationInfo.bounds.size.height;
    CGFloat margin = (self._headPanel.bounds.size.height - h) / 2;
    [self.viewInfo setFrame:CGRectMake(70, margin, self.bounds.size.width - 70, self.lblFirstName.bounds.size.height + self.lblLocationInfo.bounds.size.height)];
    
    [self._headPanel addSubview:self.viewInfo];
}
@end
