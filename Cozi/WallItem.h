//
//  WallItem.h
//  VPix
//
//  Created by khoa ngo on 11/27/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "DataWall.h"

@interface WallItem : UIView
{
    int _imgH,_itemID,_width;
    UIImageView *_imgV,*_avatar;
    UIView *_info;
    NSObject *_wall;
    NSString            *fullName;
    DataWall                *dataWall;
    SEL _itemClickSEL;
    Helper          *helperIns;
}
@property int itemID;

-(id) initWithImg:(NSData*)img avatar:(NSData*)avatar width:(int)width;
-(id) initWithImg:(NSData*)img avatar:(NSData*)avatar withFullName:(NSString*)_fullName width:(int)width;
-(id) initWithImg:(DataWall*)_dataWall withAvatar:(NSData*)avatar width:(int)width;

-(UIView*) getInfoView;
-(int) getHeight;
-(void) setClickListener:(NSObject*)listener selector:(SEL)selector;
-(UIImage*) getImg;
-(int) getImgH;
@end
