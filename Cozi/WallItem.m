//
//  WallItem.m
//  VPix
//
//  Created by khoa ngo on 11/27/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "WallItem.h"
#import "ImageRender.h"

const int _infoHight = 160;

@implementation WallItem

@synthesize itemID;

-(id) initWithImg:(NSData*)img avatar:(NSData*)avatar width:(int)width {
    self=[super init];
    _width=width;
    [self setImage:img];
    [self setAvatar:avatar];

    self.backgroundColor=[UIColor blackColor];
    return self;
}

-(id) initWithImg:(NSData*)img avatar:(NSData*)avatar withFullName:(NSString*)_fullName width:(int)width{
    self=[super init];
    helperIns = [Helper shareInstance];
    
    _width=width;
    fullName = _fullName;
    
    [self setImage:img];
    [self setAvatar:avatar];
    
    self.backgroundColor=[UIColor clearColor];
    return self;
}

-(id) initWithImg:(DataWall*)_dataWall withAvatar:(NSData*)avatar width:(int)width{
    
    self=[super init];
    helperIns = [Helper shareInstance];
    
    _width = width;
    
    fullName = _dataWall.fullName;
    dataWall = _dataWall;
    
    NSData *img = UIImageJPEGRepresentation([_dataWall.images lastObject], 1);
    
    [self setImage:img];
    [self setAvatar:avatar];
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
    
}

-(void) setImage:(NSData*)imgData{
    
    UIImage *img=[UIImage imageWithData:imgData];
    
    _imgH=_width*img.size.height/img.size.width;
    _imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, _imgH)];
    [_imgV setImage:img];
    [self addSubview:_imgV];
    
    UITapGestureRecognizer *singTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
    [singTap setNumberOfTapsRequired:1];
    [_imgV addGestureRecognizer:singTap];
    [_imgV setUserInteractionEnabled:YES];

    _info =[[UIView alloc] initWithFrame:CGRectMake(0, _imgH, _width, _infoHight)];
//    [_info setBackgroundColor:[UIColor blackColor]];
    [_info setBackgroundColor:[UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1]];
//    [_info setAlpha:0.7];
    
    [self addSubview:_info];
    
    UIView *viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 80)];
    [viewInfo
     setBackgroundColor:[UIColor clearColor]];
    [_info addSubview:viewInfo];
    
    UIImageView *imgLikeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like"]];
    [imgLikeView setBackgroundColor:[UIColor orangeColor]];
    [imgLikeView setFrame:CGRectMake(5, 0, 30, 30)];
    [viewInfo addSubview:imgLikeView];
    
    UILabel *lblLike = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, (_width / 2) - 70, 30)];
    [lblLike setText:@"100"];
    [lblLike setFont:[helperIns getFontLight:12.0f]];
    [lblLike setTextColor:[UIColor whiteColor]];
    [lblLike setBackgroundColor:[UIColor clearColor]];
    [viewInfo addSubview:lblLike];

    UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake((_width / 2) + 40, 0, (_width / 2) - 80, 30)];
    [lblComment setBackgroundColor:[UIColor clearColor]];
    [lblComment setTextAlignment:NSTextAlignmentRight];
    [lblComment setText:@"12"];
    [lblComment setFont:[helperIns getFontLight:12.0f]];
    [lblComment setTextColor:[UIColor whiteColor]];
    [viewInfo addSubview:lblComment];
    
    UIImageView *imgComment = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment"]];
    [imgComment setBackgroundColor:[UIColor orangeColor]];
    [imgComment setFrame:CGRectMake(lblComment.frame.origin.x + lblComment.bounds.size.width + 5, 0, 30, 30)];
    [viewInfo addSubview:imgComment];
    
    UILabel *lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, _width, 30)];
    [lblFullName setText:fullName];
    [lblFullName setTextAlignment:NSTextAlignmentCenter];
    [lblFullName setTextColor:[UIColor whiteColor]];
    [lblFullName setFont:[helperIns getFontLight:15.0f]];
    [lblFullName setBackgroundColor:[UIColor clearColor]];
    [viewInfo addSubview:lblFullName];
    
    CGSize textSize = CGSizeMake(_width, 10000);
    
    CGSize size = [@"25 minute ago" sizeWithFont:[helperIns getFontThin:12.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, _width, size.height)];
    [lblTime setText:@"25 minute ago"];
    [lblTime setBackgroundColor:[UIColor clearColor]];
    [lblTime setTextAlignment:NSTextAlignmentCenter];
    [lblTime setTextColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [lblTime setFont:[helperIns getFontLight:12.0f]];
    
    [viewInfo addSubview:lblTime];
    
    CGFloat h = lblLike.bounds.size.height + lblFullName.bounds.size.height + size.height;
    UIView *viewStatus = [[UIView alloc] initWithFrame:CGRectMake(0, h, _width, _infoHight - h)];
    [viewStatus setBackgroundColor:[UIColor clearColor]];
    [_info addSubview:viewStatus];
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _infoHight - h)];
    [lblContent setNumberOfLines:0];
    [lblContent setBackgroundColor:[UIColor clearColor]];
//    [lblContent setText:@"Happy Birthday ban nhe, chuc ban rat nhieu hanh phuc va tien ban vao tui moi ngay. Happy Birthday ban nhe, chuc ban rat nhieu hanh phuc va tien ban vao tui moi ngay."];
    [lblContent setText:dataWall.content];
    [lblContent setTextColor:[UIColor whiteColor]];
    [lblContent setTextAlignment:NSTextAlignmentCenter];
    [lblContent setFont:[helperIns getFontLight:15.0f]];
    
    [viewStatus addSubview:lblContent];
    
}

//-(void) setAvatar:(NSData*)avatar{
//    UIImage *img=[UIImage imageWithData:avatar];
//    ImageRender *render=[[ImageRender alloc] init];
//    img=[render circularScaleAndCropImage:img frame:CGRectMake(0, 0, 80, 80)];
//
//    _avatar=[[UIImageView alloc] initWithFrame:CGRectMake((_width-80)/2, _imgH-40, 80, 80)];
//    [_avatar setImage:img];
//    
//    [self addSubview:_avatar];
//}

-(void) setAvatar:(NSData*)avatar{
    UIImage *img=[UIImage imageWithData:avatar];
    ImageRender *render=[[ImageRender alloc] init];
    img=[render circularScaleAndCropImage:img frame:CGRectMake(0, 0, 60, 60)];
    
    UIView *shadowImage = [[UIView alloc] initWithFrame:CGRectMake((_width-60)/2, _imgH-30, 60, 60)];
    [shadowImage setBackgroundColor:[UIColor grayColor]];
    [shadowImage setContentMode:UIViewContentModeScaleAspectFill];
    [shadowImage setAutoresizingMask:UIViewAutoresizingNone];
    [shadowImage setClipsToBounds:NO];
    shadowImage.layer.cornerRadius = CGRectGetHeight(shadowImage.frame)/2;
    shadowImage.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowImage.layer.shadowOffset = CGSizeMake(2.5, 2.5);
    shadowImage.layer.shadowOpacity = 1;
    shadowImage.layer.shadowRadius = 2.5;
    
//    _avatar=[[UIImageView alloc] initWithFrame:CGRectMake((_width-80)/2, _imgH-40, 80, 80)];
    _avatar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [_avatar setImage:img];
    
    [shadowImage addSubview:_avatar];
    [self addSubview:shadowImage];
//    [self addSubview:_avatar];
}

-(UIView*) getInfoView{
    return _info;
}

-(int) getHeight{
    return _imgH+_infoHight;
}

-(void) setClickListener:(NSObject*)listener selector:(SEL)selector{
    _wall=listener;
    _itemClickSEL=selector;
}
-(UIImage*) getImg{
    return _imgV.image;
}
-(int) getImgH
{
    return _imgH;
}
-(void)imgClick{
    if(_wall==nil)
    {
        return;
    }
    [_wall performSelector:_itemClickSEL withObject:self];
}
@end
