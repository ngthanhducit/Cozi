//
//  Wall.h
//  VPix
//
//  Created by khoa ngo on 11/27/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallItem.h"
#import "WallItemV7.h"

@interface Wall : UIScrollView{
    NSMutableArray *_allBlock;
    UIView *_infoView,*_paddingView;
    UIScrollView*_detailView;
    UIImageView *_imgView;
}


-(void) addWallItem:(NSData*)imgData avatar:(NSData*)avatar itemId:(int)itemId;
-(void) addWallItem:(NSData*)imgData avatar:(NSData*)avatar withFullName:(NSString*)_fullName itemId:(int)itemId;
-(void) addWallItem:(DataWall*)_dataWall avatar:(NSData*)avatar;
-(void) insertWallItem:(NSData*)imgData avatar:(NSData*)avatar withFullName:(NSString*)_fullName itemId:(int)itemId;
@end

