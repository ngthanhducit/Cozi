//
//  CoziCoreData.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/4/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "CoziCoreData.h"

@implementation CoziCoreData

+ (id) shareInstance{
    static CoziCoreData   *shareIns = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareIns = [[CoziCoreData alloc] init];
    });
    
    return shareIns;
}

- (id) init{
    self = [super init];
    if (self) {
        helperIns = [Helper shareInstance];
    }
    
    return self;
}

- (NSManagedObjectContext *) managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

#pragma -mark Messenger Method

- (NSMutableArray *) getMessenger{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MessengerFriend"];
    NSMutableArray *messengers = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return messengers;
}

- (NSMutableArray *) getMessengerWithFriendID:(int)_friendID withUserID:(int)_userID{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MessengerFriend"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(friend_id = %i && user_id = %i)", _friendID, _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *messengers = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return messengers;
}

- (BOOL) isExistsMessenger:(int)_keyMessenger{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MessengerFriend"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key_send_message = %i)", _keyMessenger];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *messengers = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *messenger = (NSManagedObject*)[messengers lastObject];
    if (messenger == nil) {
        return NO;
    }
    
    return YES;
}

- (BOOL) saveMessenger:(Messenger *)_messenger{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //create new a managed object
    NSManagedObject *newMessenger = [NSEntityDescription insertNewObjectForEntityForName:@"MessengerFriend" inManagedObjectContext:context];
    [newMessenger setValue:[NSNumber numberWithInt:_messenger.senderID] forKey:@"sender_id"];
    [newMessenger setValue:[NSNumber numberWithInteger:_messenger.keySendMessage] forKey:@"key_send_message"];
    [newMessenger setValue:_messenger.strMessage forKey:@"str_messenger"];
    [newMessenger setValue:_messenger.strImage forKey:@"strImage"];
    [newMessenger setValue:[NSNumber numberWithInt:_messenger.typeMessage] forKey:@"type_messenger"];
    [newMessenger setValue:[NSNumber numberWithInt:_messenger.statusMessage] forKey:@"status_messenger"];
    [newMessenger setValue:_messenger.timeMessage forKey:@"time_messenger"];
    [newMessenger setValue:[helperIns convertNSDateToString:_messenger.timeServerMessage withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"time_server"];
    [newMessenger setValue:_messenger.urlImage forKey:@"url_image"];
    [newMessenger setValue:_messenger.amazonKey forKey:@"amazon_key"];
    [newMessenger setValue:_messenger.longitude forKey:@"longitude"];
    [newMessenger setValue:_messenger.latitude forKey:@"latitude"];
    [newMessenger setValue:[NSNumber numberWithInt:_messenger.friendID] forKey:@"friend_id"];
    [newMessenger setValue:[NSNumber numberWithInt:_messenger.userID] forKey:@"user_id"];
    [newMessenger setValue:[NSNumber numberWithInt:_messenger.timeOutMessenger] forKey:@"timeout_messenger"];
    [newMessenger setValue:[NSNumber numberWithBool:_messenger.isTimeOut] forKey:@"is_timeout"];
    
    NSString *strTimeServer = [newMessenger valueForKey:@"time_server"];
    NSError *error= nil;
    if (![context save:&error]) {
        NSLog(@"add new failed");
    }
    
    return YES;
}

- (BOOL) updateMessenger:(Messenger*)_messenger{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MessengerFriend"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key_send_message = %i)", _messenger.keySendMessage];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *messengers = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *messenger = (NSManagedObject*)[messengers lastObject];
    
    [messenger setValue:[NSNumber numberWithInt:_messenger.senderID] forKey:@"sender_id"];
    [messenger setValue:[NSNumber numberWithInteger:_messenger.keySendMessage] forKey:@"key_send_message"];
    [messenger setValue:_messenger.strMessage forKey:@"str_messenger"];
//    [messenger setValue:[NSNumber numberWithInt:_messenger.typeMessage] forKey:@"type_messenger"];
    [messenger setValue:[NSNumber numberWithInt:_messenger.statusMessage] forKey:@"status_messenger"];
    [messenger setValue:_messenger.timeMessage forKey:@"time_messenger"];
    [messenger setValue:[helperIns convertNSDateToString:_messenger.timeServerMessage withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"time_server"];
    [messenger setValue:_messenger.urlImage forKey:@"url_image"];
    [messenger setValue:_messenger.amazonKey forKey:@"amazon_key"];
    [messenger setValue:_messenger.longitude forKey:@"longitude"];
    [messenger setValue:_messenger.latitude forKey:@"latitude"];
    [messenger setValue:[NSNumber numberWithInt:_messenger.timeOutMessenger] forKey:@"timeout_messenger"];
    [messenger setValue:[NSNumber numberWithBool:_messenger.isTimeOut] forKey:@"is_timeout"];
    
    if (![context save:&error])
        return NO;
    
    return YES;
}

- (void) deleteMessenger:(int)_keyMessenger{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MessengerFriend"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key_send_message = %i)", _keyMessenger];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *messengers = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *messenger = (NSManagedObject*)[messengers lastObject];
    
    [context deleteObject:messenger];
}

#pragma -mark Friend Method
- (NSMutableArray *) getFriends{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserFriend"];
    NSMutableArray *friends = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return friends;
}

- (NSMutableArray *) getFriendsWithUserID:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserFriend"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *friends = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return friends;
}

- (BOOL)isExistsFriend:(int)_friendID withUserID:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserFriend"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(friend_id = %i && user_id = %i)", _friendID, _userID];
    [fetchRequest setPredicate:predicate];
    NSMutableArray *friends = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *friend = (NSManagedObject*)[friends lastObject];
    
    if (friend == nil) {
        return NO;
    }
    
    return YES;
}

- (BOOL) saveFriend:(Friend *)_friend{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newFriend = [NSEntityDescription insertNewObjectForEntityForName:@"UserFriend" inManagedObjectContext:context];
    [newFriend setValue:_friend.firstName forKey:@"first_name"];
    [newFriend setValue:[NSNumber numberWithInt:_friend.friendID] forKey:@"friend_id"];
    [newFriend setValue:_friend.gender forKey:@"gender"];
    [newFriend setValue:[NSNumber numberWithFloat:_friend.heightAvatar] forKey:@"height_avatar"];
    [newFriend setValue:_friend.lastName forKey:@"last_name"];
    [newFriend setValue:[NSNumber numberWithFloat:_friend.leftAvatar] forKey:@"left_avatar"];
    [newFriend setValue:_friend.nickName forKey:@"nick_name"];
    [newFriend setValue:[NSNumber numberWithFloat:_friend.scaleAvatar] forKey:@"scale_avatar"];
    [newFriend setValue:[NSNumber numberWithInt:_friend.statusFriend] forKey:@"status_friend"];
    [newFriend setValue:[NSNumber numberWithFloat:_friend.topAvatar] forKey:@"top_avatar"];
    [newFriend setValue:_friend.urlAvatar forKey:@"url_avatar"];
    [newFriend setValue:_friend.urlThumbnail forKey:@"url_thumbnail"];
    [newFriend setValue:[NSNumber numberWithInt:_friend.userID] forKey:@"user_id"];
    [newFriend setValue:[NSNumber numberWithFloat:_friend.widthAvatar] forKey:@"width_avatar"];
    [newFriend setValue:_friend.phoneNumber forKey:@"phone_number"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) updateFriend:(Friend *)_friend{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserFriend"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(friend_id = %i)", _friend.friendID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *friends = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *friend = (NSManagedObject*)[friends lastObject];
    
    [friend setValue:_friend.firstName forKey:@"first_name"];
    [friend setValue:[NSNumber numberWithInt:_friend.friendID] forKey:@"friend_id"];
    [friend setValue:_friend.gender forKey:@"gender"];
    [friend setValue:[NSNumber numberWithFloat:_friend.heightAvatar] forKey:@"height_avatar"];
    [friend setValue:_friend.lastName forKey:@"last_name"];
    [friend setValue:[NSNumber numberWithFloat:_friend.leftAvatar] forKey:@"left_avatar"];
    [friend setValue:_friend.nickName forKey:@"nick_name"];
    [friend setValue:[NSNumber numberWithFloat:_friend.scaleAvatar] forKey:@"scale_avatar"];
    [friend setValue:[NSNumber numberWithInt:_friend.statusFriend] forKey:@"status_friend"];
    [friend setValue:[NSNumber numberWithFloat:_friend.topAvatar] forKey:@"top_avatar"];
    [friend setValue:_friend.urlAvatar forKey:@"url_avatar"];
    [friend setValue:_friend.urlThumbnail forKey:@"url_thumbnail"];
    [friend setValue:[NSNumber numberWithInt:_friend.userID] forKey:@"user_id"];
    [friend setValue:[NSNumber numberWithFloat:_friend.widthAvatar] forKey:@"width_avatar"];
    [friend setValue:_friend.phoneNumber forKey:@"phone_number"];
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (void) deleteFriend:(int)_friendID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserFriend" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(friend_id = %i)", _friendID];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *friends = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *friend = (NSManagedObject*)[friends lastObject];
    if (friend != nil) {
        [context deleteObject:friend];
    }
}

#pragma -mark User Method
- (NSMutableArray *) getUser{
    NSManagedObjectContext  *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserLogin"];
    NSMutableArray *users = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return users;
}

- (NSManagedObject*) getUserByUserID:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserLogin"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *users = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *user = (NSManagedObject*)[users lastObject];
    
    return user;
}

- (BOOL) isExistsUser:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserLogin"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *users = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *user = (NSManagedObject*)[users lastObject];
    if (user != nil) {
        return YES;
    }
    
    return NO;
}

- (BOOL) saveUser:(User *)_user{
    NSManagedObjectContext  *context = [self managedObjectContext];
    NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserLogin" inManagedObjectContext:context];
    [newUser setValue:_user.accessKey forKey:@"access_key"];
    [newUser setValue:_user.birthDay forKey:@"birth_day"];
    [newUser setValue:_user.firstname forKey:@"first_name"];
    [newUser setValue:_user.gender forKey:@"gender"];
    [newUser setValue:[NSNumber numberWithFloat:_user.heightAvatar] forKey:@"height_avatar"];
    [newUser setValue:_user.lastName forKey:@"last_name"];
    [newUser setValue:[NSNumber numberWithFloat:_user.leftAvatar] forKey:@"left_avatar"];
    [newUser setValue:_user.nickName forKey:@"nick_name"];
    [newUser setValue:_user.phoneNumber forKey:@"phone_number"];
    [newUser setValue:[NSNumber numberWithFloat:_user.scaleAvatar] forKey:@"scale_avatar"];
    [newUser setValue:_user.timeServer forKey:@"time_server"];
    [newUser setValue:[NSNumber numberWithFloat:_user.topAvatar] forKey:@"top_avatar"];
    [newUser setValue:_user.urlAvatar forKey:@"url_avatar"];
    [newUser setValue:_user.urlThumbnail forKey:@"url_thumbnail"];
    [newUser setValue:[NSNumber numberWithInt:_user.userID] forKey:@"user_id"];
    [newUser setValue:[NSNumber numberWithInt:_user.statusUser] forKey:@"user_status"];
    [newUser setValue:[NSNumber numberWithFloat:_user.widthAvatar] forKey:@"width_avatar"];
    [newUser setValue:[NSNumber numberWithInt:0] forKey:@"key_send_messenger"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) updateUser:(User*)_user{
    NSManagedObjectContext  *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserLogin"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _user.userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *user = (NSManagedObject*)[users lastObject];
    
    [user setValue:_user.accessKey forKey:@"access_key"];
    [user setValue:_user.birthDay forKey:@"birth_day"];
    [user setValue:_user.firstname forKey:@"first_name"];
    [user setValue:_user.gender forKey:@"gender"];
    [user setValue:[NSNumber numberWithFloat:_user.heightAvatar] forKey:@"height_avatar"];
    [user setValue:_user.lastName forKey:@"last_name"];
    [user setValue:[NSNumber numberWithFloat:_user.leftAvatar] forKey:@"left_avatar"];
    [user setValue:_user.nickName forKey:@"nick_name"];
    [user setValue:_user.phoneNumber forKey:@"phone_number"];
    [user setValue:[NSNumber numberWithFloat:_user.scaleAvatar] forKey:@"scale_avatar"];
    [user setValue:_user.timeServer forKey:@"time_server"];
    [user setValue:[NSNumber numberWithFloat:_user.topAvatar] forKey:@"top_avatar"];
    [user setValue:_user.urlAvatar forKey:@"url_avatar"];
    [user setValue:_user.urlThumbnail forKey:@"url_thumbnail"];
    [user setValue:[NSNumber numberWithInt:_user.userID] forKey:@"user_id"];
    [user setValue:[NSNumber numberWithInt:_user.statusUser] forKey:@"user_status"];
    [user setValue:[NSNumber numberWithFloat:_user.widthAvatar] forKey:@"width_avatar"];
    [user setValue:[NSNumber numberWithInteger:_user.keySendMessenger] forKey:@"key_send_messenger"];
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (void) deleteUser:(int)_userID{
    NSManagedObjectContext  *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserLogin"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *user = (NSManagedObject*)[users lastObject];
    if (user != nil) {
        [context deleteObject:user];
    }
}
@end
