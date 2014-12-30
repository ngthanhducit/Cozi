//
//  ImageSelected.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/13/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageSelected : NSObject
{
    
}
@property (nonatomic)           BOOL                isSelected;
@property (nonatomic, strong) UIImage               *imgShow;
@property (nonatomic) int                               index;
@end
