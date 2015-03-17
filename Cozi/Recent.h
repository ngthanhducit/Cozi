//
//  Recent.h
//  Cozi
//
//  Created by ChjpCoj on 3/4/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Friend.h"

@interface Recent : NSObject
{
    
}

@property (nonatomic) int           userID;
@property (nonatomic) int           recentID;
@property (nonatomic) int           typeRecent; //0: single chat - 1: group chat
@property (nonatomic, strong) UIImage       *thumbnail;
@property (nonatomic, strong) NSString      *urlThumbnail;
@property (nonatomic, strong) NSString      *nameRecent;
@property (nonatomic, strong) Friend        *friendIns;
//Store list user in group chat
@property (nonatomic, strong) NSMutableArray    *friendRecent;
//Using for group chat
@property (nonatomic, strong) NSMutableArray    *messengerRecent;

@end
