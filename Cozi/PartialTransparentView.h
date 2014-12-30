//
//  PartialTransparentView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/28/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartialTransparentView : UIView
{
    NSArray *rectsArray;
    UIColor *backgroundColor;
    UIImage                   *imgViewCapture;
}

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)color andTransparentRects:(NSArray*)rects imageBackground:(UIImageView*) image;
@end
