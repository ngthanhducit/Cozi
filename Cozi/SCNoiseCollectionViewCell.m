//
//  SCNoiseCollectionViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCNoiseCollectionViewCell.h"

@implementation SCNoiseCollectionViewCell

@synthesize imgView;
@synthesize shadowImage;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.shadowImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 70, 70)];
        
        [self.shadowImage addSubview:imgView];
        
        [self.contentView addSubview:self.shadowImage];
    }
    
    return self;
}

@end
