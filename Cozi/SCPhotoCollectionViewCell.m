//
//  SCPhotoCollectionViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPhotoCollectionViewCell.h"

@implementation SCPhotoCollectionViewCell

@synthesize imgView;
@synthesize shadowImage;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.shadowImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 80)];
        
        [self.shadowImage addSubview:imgView];
        
        [self.contentView addSubview:self.shadowImage];
    }
    
    return self;
}

@end
