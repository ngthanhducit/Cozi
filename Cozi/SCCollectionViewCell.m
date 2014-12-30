//
//  SCCollectionViewCell.m
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/23/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "SCCollectionViewCell.h"

@implementation SCCollectionViewCell

@synthesize viewBorder;
@synthesize imgView;
@synthesize lblName;
@synthesize borderLine;
@synthesize shadowImage;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.imgNotify = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        self.shadowImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        
        self.viewBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 70, 70)];
        
        [self.shadowImage addSubview:imgView];
        
        self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 15)];
        
        self.borderLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        [self.borderLine setHidden:YES];
        
        [self.contentView addSubview:self.viewBorder];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.borderLine];
//        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.shadowImage];
        [self.contentView addSubview:self.imgNotify];
    }
    
    return self;
}
@end
