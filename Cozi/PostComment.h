//
//  PostComment.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/29/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostComment : NSObject

@property (nonatomic, strong) NSDate                    *dateComment;
@property (nonatomic) NSInteger                 userCommentId;
@property (nonatomic, strong) NSString                  *userNameComment;
@property (nonatomic, strong) NSString                  *firstName;
@property (nonatomic, strong) NSString                  *lastName;
@property (nonatomic, strong) NSString                  *contentComment;
@property (nonatomic, strong) NSString                  *urlImageComment;
@property (nonatomic, strong) NSMutableArray            *commentLikes;
@end
