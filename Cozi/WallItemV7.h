//
//  WallItemV7.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/23/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataWall.h"
#import "Helper.h"

@interface WallItemV7 : UIView
{
    Helper              *helperIns;
    
    CGSize              sizeScreen;
    CGFloat             widthBlock;
    DataWall            *wallData;
    NSData              *avatarData;
    
    UIView          *vImages;
    UIView          *vLike;
    UIView          *vProfile;
    UIView          *vStatus;
    UIView          *vComment;
}

- (id) initWithData:(DataWall*)_dataWall withAvatar:(NSData*)_avatarData withWidth:(CGFloat)width;
-(int) getHeight;
@end
