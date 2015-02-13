//
//  PostLike.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/29/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostLike : NSObject

@property (nonatomic, strong) NSDate    *dateLike;
@property (nonatomic        ) NSInteger userLikeId;
@property (nonatomic, copy) NSString        *urlAvatarThumb;
@property (nonatomic, copy) NSString        *urlAvatarFull;
@property (nonatomic, copy  ) NSString  *userNameLike;
@property (nonatomic, copy  ) NSString  *firstName;
@property (nonatomic, copy  ) NSString  *lastName;
@end
