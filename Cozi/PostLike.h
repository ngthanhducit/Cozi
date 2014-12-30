//
//  PostLike.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/29/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostLike : NSObject

@property (nonatomic, strong) NSDate                *dateLike;
@property (nonatomic) NSInteger             userLikeId;
@property (nonatomic, strong) NSString              *userNameLike;
@property (nonatomic, strong) NSString              *firstName;
@property (nonatomic, strong) NSString              *lastName;
@end
