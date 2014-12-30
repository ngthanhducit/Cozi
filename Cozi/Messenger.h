//
//  Messenger.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface Messenger : NSObject

@property (nonatomic        ) int          senderID;
@property (nonatomic        ) NSInteger    keySendMessage;//client render key
@property (nonatomic, strong) NSString     *strMessage;
@property (nonatomic, strong) NSString      *strImage;
@property (nonatomic        ) int          typeMessage;//0: text - 1: image - 2: Location
@property (nonatomic        ) int          statusMessage;//0: da gui - 1: server da nhan - 2: da xem - 3: error
@property (nonatomic, strong) NSString     *timeMessage;
@property (nonatomic, strong) NSDate     *timeServerMessage;//Send Success
@property (nonatomic, strong) NSData       *dataImage;
@property (nonatomic, strong) UIImage      *thumnail;
@property (nonatomic, strong) UIImage      *thumnailBlur;
@property (nonatomic        ) int          friendID;
@property (nonatomic)           int         userID;
@property (nonatomic, strong) NSString     *amazonKey;
@property (nonatomic, strong) NSString     *longitude;
@property (nonatomic, strong) NSString     *latitude;
@property (nonatomic, strong) NSString      *urlImage;
@property (nonatomic) int           timeOutMessenger;
@property (nonatomic) BOOL              isTimeOut;
@end
