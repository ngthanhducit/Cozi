//
//  Wall.m
//  VPix
//
//  Created by khoa ngo on 11/27/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "Wall.h"
#import "ImageRender.h"

const int _infoH=300;
@implementation Wall

-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    _allBlock=[[NSMutableArray alloc] init];
    
    _detailView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _detailView.backgroundColor=[UIColor clearColor];
    _paddingView=[[UIView alloc] initWithFrame:frame];
    _paddingView.backgroundColor=[UIColor blackColor];
    _detailView.backgroundColor=[UIColor blackColor];
    [_paddingView setAlpha:0.0];
    [_detailView addSubview:_paddingView];
    _imgView =[[UIImageView alloc] init];
    UITapGestureRecognizer *tapRecog=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDetaiView)];
    [tapRecog setNumberOfTapsRequired:1];
    [_imgView addGestureRecognizer:tapRecog];
    [_imgView setUserInteractionEnabled:YES];
    [_detailView addSubview:_imgView];
    _infoView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _infoH)];
    _infoView.backgroundColor=[UIColor yellowColor];
    [_detailView addSubview:_infoView];
    
    [self addSubview:_detailView];
    [_detailView setHidden:YES];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    return self;
}

-(void) addWallItem:(NSData*)imgData avatar:(NSData*)avatar itemId:(int)itemId{

    int top=0;
    for (WallItem *item in _allBlock) {
        top+=[item getHeight];
    }
    WallItem *item=[[WallItem alloc] initWithImg:imgData avatar:avatar width:self.frame.size.width];
    item.itemID=itemId;
    item.frame=CGRectMake(0, top, self.frame.size.width, [item getHeight]) ;
    [item setClickListener:self selector:@selector(itemClick:)];
    [self addSubview:item];
    
    [self setContentSize:CGSizeMake(self.frame.size.width, top+[item getHeight])];
    [_allBlock addObject:item];
    
}

-(void) addWallItem:(NSData*)imgData avatar:(NSData*)avatar withFullName:(NSString*)_fullName itemId:(int)itemId{
    
    int top=0;
    for (WallItem *item in _allBlock) {
        top+=[item getHeight];
    }
    
    WallItem *item = [[WallItem alloc] initWithImg:imgData avatar:avatar withFullName:_fullName width:self.frame.size.width];
//    WallItem *item=[[WallItem alloc] initWithImg:imgData avatar:avatar width:self.frame.size.width];
    
    item.itemID=itemId;
    item.frame=CGRectMake(0, top, self.frame.size.width, [item getHeight]) ;
    [item setClickListener:self selector:@selector(itemClick:)];
    [self addSubview:item];
    
    [self setContentSize:CGSizeMake(self.frame.size.width, top+[item getHeight])];
    [_allBlock addObject:item];
    
}

-(void) addWallItem:(DataWall*)_dataWall avatar:(NSData*)avatar{
    
    int top=0;
    for (WallItemV7 *item in _allBlock) {
        top+=[item getHeight] + 10;
    }
    
//    WallItem *item = [[WallItem alloc] initWithImg:_dataWall withAvatar:avatar width:self.frame.size.width];
    WallItemV7 *item = [[WallItemV7 alloc] initWithData:_dataWall withAvatar:avatar withWidth:self.frame.size.width - 20];
    
//    item.itemID=_dataWall.userPostID;
    
    item.frame=CGRectMake(10, top + 10, self.frame.size.width - 20, [item getHeight]) ;
//    [item setClickListener:self selector:@selector(itemClick:)];
    [self addSubview:item];
    
    [self setContentSize:CGSizeMake(self.frame.size.width, top + [item getHeight] + 10)];
    [_allBlock addObject:item];
    
}

-(void) insertWallItem:(NSData*)imgData avatar:(NSData*)avatar withFullName:(NSString*)_fullName itemId:(int)itemId{
    
    WallItem *item = [[WallItem alloc] initWithImg:imgData avatar:avatar withFullName:_fullName width:self.frame.size.width];
    
    item.itemID=itemId;
    [item setClickListener:self selector:@selector(itemClick:)];
    [self addSubview:item];

//    [_allBlock addObject:item];
    [_allBlock insertObject:item atIndex:0];
    
    int top=0;
    for (WallItem *item in _allBlock) {
        item.frame=CGRectMake(0, top, self.frame.size.width, [item getHeight]);
        top+=[item getHeight];
    }
    
//    int top=0;
//    for (int i = 0; i < (int)[_allBlock count]; i++) {
//        WallItem *_item = [_allBlock objectAtIndex:i];
//        _item.frame=CGRectMake(0, i * [_item getHeight], self.frame.size.width, [item getHeight]);
//    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width, top)];
}

-(void) itemClick:(WallItem*)item{
    NSLog(@"item id: %d",item.itemID);
    UIImage *img=[item getImg];
    int imgH=[item getImgH];
    int top= item.frame.origin.y;
    int imgPading;
    
    CGRect rect=_detailView.frame;

    if(imgH>self.frame.size.height)
    {
        //image longer than screen
        _paddingView.frame=CGRectMake(0, 0, 0, 0);
        imgPading=0;
    }
    else{
        _paddingView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imgPading=(self.frame.size.height-imgH)/2;
    }
    
    top-=imgPading;


    rect.origin.y=top;

    [_detailView setFrame:rect];
    _imgView.frame=CGRectMake(0, imgPading, self.frame.size.width  , imgH);
    [_imgView setImage:img];
    [self bringSubviewToFront:_detailView];
    [_detailView setHidden:NO];
    _infoView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, _infoH);
    [_detailView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    self.scrollEnabled=NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        [_paddingView setAlpha:1.0];
        _detailView.frame=CGRectMake(0, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finish){
        [_detailView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height+_infoH)];
    }];
}

-(void) closeDetaiView{
    [_detailView setHidden:YES];
    self.scrollEnabled=YES;
}
@end
