//
//  WallV6.h
//  VPix
//
//  Created by khoa ngo on 11/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallV6 : UIScrollView
{
    NSMutableArray *_allItems;
}
-(void) addItem:(UIImage*)img itemId:(int)itemId;
@end
