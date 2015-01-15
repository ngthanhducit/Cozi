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

@property (nonatomic ) int   userPostID;
@property (nonatomic, strong) NSString                  *fullName;
@property (nonatomic, strong) NSString                  *content;
@property (nonatomic, strong) UIImage                   *thumb;
@property (nonatomic, strong) NSMutableArray            *images;
@property (nonatomic, strong) NSData                    *imgData;
@property (nonatomic, strong) NSString                  *video;
@property (nonatomic, strong) NSString                  *longitude;
@property (nonatomic, strong) NSString                  *latitude;
@property (nonatomic, strong) NSString                  *time;
@property (nonatomic, strong) NSString                  *clientKey;
@property (nonatomic, strong) NSString                  *firstName;
@property (nonatomic, strong) NSString                  *lastName;
@property (nonatomic, strong) NSMutableArray            *comments;
@property (nonatomic, strong) NSMutableArray            *likes;
@property (nonatomic) int                               typePost; //0: image with title or not - 1: title
@property (nonatomic) BOOL                              isLike;
@property (nonatomic, strong) NSString                  *timeLike;
@property (nonatomic, strong) NSString                  *urlFull;
@property (nonatomic, strong) NSString                  *urlThumb;
@end
