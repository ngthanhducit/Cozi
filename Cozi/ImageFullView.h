//
//  ImageFullView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/9/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SCPhotoPreview.h"

@interface ImageFullView : UIView <UIScrollViewDelegate>
{
    NSMutableArray                  *imageList;
    int                             pageIndex;
    Helper                          *helperIns;
    NSURL                           *urlImage;
    UIActivityIndicatorView         *waitingLoad;
    SCPhotoPreview                  *photoPreview;
}

@property (nonatomic, strong) UIScrollView            *mainScroll;
//@property (nonatomic, weak) UIScrollView            *imgScroll;
@property (nonatomic, strong) UIImageView             *imageView;

- (void) initWithUrl:(NSURL*)_urlImage;
- (void) initWithImage:(UIImage*)_img;
- (void) initWithData:(UIImage *)_img;
- (void) initWithData:(NSMutableArray*)_imgList withIndexSelect:(int)_index;
@end
