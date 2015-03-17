//
//  DataWall.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/19/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataWall : NSObject
{
    
}

@property (nonatomic, assign ) int            userPostID;
@property (nonatomic, copy   ) NSString       *fullName;
@property (nonatomic, copy   ) NSString       *content;
@property (nonatomic, strong ) UIImage        *thumb;
@property (nonatomic, strong ) UIImage        *imgMaps;
@property (nonatomic, strong   ) NSMutableArray *images;
@property (nonatomic, copy   ) NSString       *video;
@property (nonatomic, copy   ) NSString       *longitude;
@property (nonatomic, copy   ) NSString       *latitude;
@property (nonatomic, copy   ) NSString       *time;
@property (nonatomic, strong) NSDate          *datePost;
@property (nonatomic, copy   ) NSString       *clientKey;
@property (nonatomic, copy   ) NSString       *firstName;
@property (nonatomic, copy   ) NSString       *lastName;
@property (nonatomic, strong ) NSMutableArray *comments;
@property (nonatomic, strong ) NSMutableArray *likes;
//@property (nonatomic, assign ) int            typePost;//0: image with title or not - 1: title
@property (nonatomic, assign ) BOOL           isLike;
@property (nonatomic, copy   ) NSString       *timeLike;
@property (nonatomic, copy   ) NSString       *urlFull;
@property (nonatomic, copy   ) NSString       *urlThumb;
@property (nonatomic, assign ) int            codeType;
@property (nonatomic, strong) NSString        *urlAvatarThumb;
@property (nonatomic, strong) NSString        *urlAvatarFull;
@end
