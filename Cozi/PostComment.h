//
//  PostComment.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/29/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostComment : NSObject

@property (nonatomic, strong) NSDate         *dateComment;
@property (nonatomic        ) NSInteger      userCommentId;
@property (nonatomic, copy) NSString        *urlAvatarThumb;
@property (nonatomic, copy) NSString        *urlAvatarFull;
@property (nonatomic, copy) NSString         *commentClientKey;
@property (nonatomic, copy) NSString         *postClientKey;
@property (nonatomic, copy  ) NSString       *userNameComment;
@property (nonatomic, copy  ) NSString       *firstName;
@property (nonatomic, copy  ) NSString       *lastName;
@property (nonatomic, copy  ) NSString       *contentComment;
@property (nonatomic, copy  ) NSString       *urlImageComment;
@property (nonatomic, strong) NSMutableArray *commentLikes;
@property (nonatomic) BOOL          isLikeComment;
@end
