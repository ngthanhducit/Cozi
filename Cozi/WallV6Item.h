//
//  WallV6Item.h
//  VPix
//
//  Created by khoa ngo on 11/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallV6Item : UIImageView{
    SEL _clickSEL;
    NSObject *_target;
}
@property int itemId;
-(void) addClickListener:(NSObject*)target selector:(SEL)selector;
@end
