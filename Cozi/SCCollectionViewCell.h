//
//  SCCollectionViewCell.h
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/23/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface SCCollectionViewCell : UICollectionViewCell
{
    
}

@property (nonatomic, strong) UIView                    *shadowImage;
@property (nonatomic, strong) UIView                    *viewBorder;
@property (nonatomic, strong) UIView                    *borderLine;
@property (nonatomic, strong) UIImageView               *imgView;
@property (nonatomic, strong) UIView                    *vBorderNotify;
@property (nonatomic, strong) UIImageView               *imgNotify;
@property (nonatomic, strong) UILabel                   *lblName;

@end
