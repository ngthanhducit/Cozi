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

- (BOOL) isExistsMessenger:(NSString*)_keyMessenger{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MessengerFriend"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key_send_message = %@)", _keyMessenger];
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
    [newMessenger setValue:_messenger.keySendMessage forKey:@"key_send_message"];
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

    NSError *error= nil;
    if (![context save:&error]) {
        NSLog(@"add new failed");
    }
    
    return YES;
}

- (BOOL) updateMessenger:(Messenger*)_messenger{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MessengerFriend"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key_send_message = %@)", _messenger.keySendMessage];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *messengers = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *messenger = (NSManagedObject*)[messengers lastObject];
    
    [messenger setValue:[NSNumber numberWithInt:_messenger.senderID] forKey:@"sender_id"];
    [messenger setValue:_messenger.keySendMessage forKey:@"key_send_message"];
    [messenger setValue:_messenger.strMessage forKey:@"str_messenger"];
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

- (void) deleteMessenger:(NSString*)_keyMessenger{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MessengerFriend"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key_send_message = %@)", _keyMessenger];
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

    BOOL isExists = [self isExistsFriend:_friend.friendID withUserID:_friend.userID];
    if (!isExists) {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSManagedObject *newFriend = [NSEntityDescription insertNewObjectForEntityForName:@"UserFriend" inManagedObjectContext:context];
        [newFriend setValue:_friend.firstName forKey:@"first_name"];
        [newFriend setValue:[NSNumber numberWithInt:_friend.friendID] forKey:@"friend_id"];
        [newFriend setValue:_friend.gender forKey:@"gender"];
        //    [newFriend setValue:[NSNumber numberWithFloat:_friend.heightAvatar] forKey:@"height_avatar"];
        [newFriend setValue:_friend.lastName forKey:@"last_name"];
        //    [newFriend setValue:[NSNumber numberWithFloat:_friend.leftAvatar] forKey:@"left_avatar"];
        [newFriend setValue:_friend.nickName forKey:@"nick_name"];
        //    [newFriend setValue:[NSNumber numberWithFloat:_friend.scaleAvatar] forKey:@"scale_avatar"];
        [newFriend setValue:[NSNumber numberWithInt:_friend.statusFriend] forKey:@"status_friend"];
        //    [newFriend setValue:[NSNumber numberWithFloat:_friend.topAvatar] forKey:@"top_avatar"];
        [newFriend setValue:_friend.urlAvatar forKey:@"url_avatar"];
        [newFriend setValue:_friend.urlThumbnail forKey:@"url_thumbnail"];
        [newFriend setValue:[NSNumber numberWithInt:_friend.userID] forKey:@"user_id"];
        //    [newFriend setValue:[NSNumber numberWithFloat:_friend.widthAvatar] forKey:@"width_avatar"];
        [newFriend setValue:_friend.phoneNumber forKey:@"phone_number"];
        [newFriend setValue:[NSNumber numberWithInt:_friend.statusAddFriend] forKey:@"status_add_friend"];
        [newFriend setValue:_friend.userName forKey:@"user_name"];
        
        NSError *error = nil;
        if (![context save:&error]) {
            return NO;
        }
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
//    [friend setValue:[NSNumber numberWithFloat:_friend.heightAvatar] forKey:@"height_avatar"];
    [friend setValue:_friend.lastName forKey:@"last_name"];
//    [friend setValue:[NSNumber numberWithFloat:_friend.leftAvatar] forKey:@"left_avatar"];
    [friend setValue:_friend.nickName forKey:@"nick_name"];
//    [friend setValue:[NSNumber numberWithFloat:_friend.scaleAvatar] forKey:@"scale_avatar"];
    [friend setValue:[NSNumber numberWithInt:_friend.statusFriend] forKey:@"status_friend"];
//    [friend setValue:[NSNumber numberWithFloat:_friend.topAvatar] forKey:@"top_avatar"];
    [friend setValue:_friend.urlAvatar forKey:@"url_avatar"];
    [friend setValue:_friend.urlThumbnail forKey:@"url_thumbnail"];
    [friend setValue:[NSNumber numberWithInt:_friend.userID] forKey:@"user_id"];
//    [friend setValue:[NSNumber numberWithFloat:_friend.widthAvatar] forKey:@"width_avatar"];
    [friend setValue:_friend.phoneNumber forKey:@"phone_number"];
    [friend setValue:[NSNumber numberWithInt:_friend.statusAddFriend] forKey:@"status_add_friend"];
    [friend setValue:_friend.userName forKey:@"user_name"];
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (void) deleteFriend:(int)_friendID withUserID:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserFriend" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(friend_id = %i && user_id = %i)", _friendID, _userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *friends = [context executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *friend = (NSManagedObject*)[friends lastObject];
    
    if (friend != nil) {
        [context deleteObject:friend];
    }
    
    if (![friend.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
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

#pragma -mark Follower
- (NSMutableArray*) getFollower{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Follower"];
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (NSMutableArray*) getFollowerByUserID:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Follower"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id = %i", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *followers = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return followers;
}

- (NSMutableArray*) getFollowerByParentUserID:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Follower"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id = %i", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *followers = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return followers;
}

- (BOOL) isExistsFollower:(int)_userID withParentID:(int)_parentID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Follower"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i && parent_id = %i)", _userID, _parentID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *followers = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *follower = (NSManagedObject*)[followers lastObject];
    if (follower != nil) {
        return YES;
    }
    
    return NO;
}

- (BOOL) saveFollower:(FollowerUser *)_follower{
    NSManagedObjectContext  *context = [self managedObjectContext];
    NSManagedObject *newFollower = [NSEntityDescription insertNewObjectForEntityForName:@"Follower" inManagedObjectContext:context];
    [newFollower setValue:[NSNumber numberWithInt:_follower.parentUserID] forKey:@"parent_id"];
    [newFollower setValue:[NSNumber numberWithInt:_follower.userID] forKey:@"user_id"];
    [newFollower setValue:_follower.firstName forKey:@"first_name"];
    [newFollower setValue:_follower.lastName forKey:@"last_name"];
    [newFollower setValue:_follower.urlAvatar forKey:@"url_avatar"];
    [newFollower setValue:_follower.urlAvatarFull forKey:@"url_avatar_full"];
    [newFollower setValue:[NSNumber numberWithInt:_follower.parentUserID] forKey:@"parent_id"];
    [newFollower setValue:[NSNumber numberWithInt:_follower.statusFollow] forKey:@"status_follower"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) updateFollower:(FollowerUser *)_follower{
    NSManagedObjectContext  *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Follower"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _follower.userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *followers = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *follower = (NSManagedObject*)[followers lastObject];
    
    [follower setValue:_follower.firstName forKey:@"first_name"];
    [follower setValue:_follower.lastName forKey:@"last_name"];
    [follower setValue:_follower.urlAvatar forKey:@"url_avatar"];
    [follower setValue:_follower.urlAvatarFull forKey:@"url_avatar_full"];
    [follower setValue:[NSNumber numberWithInt:_follower.statusFollow] forKey:@"status_follower"];
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (void) deleteFollower:(int)_userID{
    NSManagedObjectContext  *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Follower"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *followers = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *follower = (NSManagedObject*)[followers lastObject];
    if (follower != nil) {
        [context deleteObject:follower];
    }
}

#pragma -mark POSTS
- (NSMutableArray*) getPosts{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Posts"];
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (NSMutableArray*) getPostsByUserID:(int)_userID{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Posts"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_post_id = %i", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *post = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return post;
}

- (NSMutableArray*) getPostsByUserID:(int)_userID withClientKey:(NSString*)_clientKey{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Posts"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_post_id = %i && client_key = %@", _userID, _clientKey];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *posts = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return posts;
}

- (BOOL) isExistsPost:(int)_userID withClientKey:(NSString*)_clientKey{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Posts"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_post_id = %i && client_key = %@", _userID, _clientKey];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *posts = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject * post = (NSManagedObject*)[posts lastObject];
    if (post) {
        return YES;
    }
    
    return NO;
}

- (BOOL) savePosts:(DataWall*)_posts{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newPost = [NSEntityDescription insertNewObjectForEntityForName:@"Posts" inManagedObjectContext:context];
    [newPost setValue:[NSNumber numberWithInt:_posts.userPostID] forKey:@"user_post_id"];
    [newPost setValue:[NSNumber numberWithInteger:_posts.codeType] forKey:@"code_type"];
    [newPost setValue:_posts.clientKey forKey:@"client_key"];
    [newPost setValue:_posts.content forKey:@"content_post"];
    [newPost setValue:_posts.firstName forKey:@"first_name"];
    [newPost setValue:_posts.lastName forKey:@"last_name"];
    [newPost setValue:[NSNumber numberWithBool:_posts.isLike] forKey:@"is_like"];
    [newPost setValue:[NSString stringWithFormat:@"%@|%@", _posts.longitude, _posts.latitude] forKey:@"location"];
    [newPost setValue:_posts.time forKey:@"time_post"];
    [newPost setValue:_posts.timeLike forKey:@"time_like"];
    [newPost setValue:_posts.urlFull forKey:@"url_image_full"];
    [newPost setValue:_posts.urlThumb forKey:@"url_image_thumb"];
    [newPost setValue:_posts.video forKey:@"url_video"];
    [newPost setValue:[NSNumber numberWithInt:_posts.userPostID] forKey:@"user_post_id"];
    [newPost setValue:_posts.urlAvatarThumb forKey:@"url_avatar_thumb"];
    [newPost setValue:_posts.urlAvatarFull forKey:@"url_avatar_full"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) updatePost:(DataWall*)_posts{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Posts"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_post_id = %i && client_key = %@)", _posts.userPostID, _posts.clientKey];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *posts = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *post = (NSManagedObject*)[posts lastObject];
    
    [post setValue:_posts.content forKey:@"content"];
    [post setValue:_posts.firstName forKey:@"first_name"];
    [post setValue:_posts.lastName forKey:@"last_name"];
    [post setValue:[NSNumber numberWithBool:_posts.isLike] forKey:@"is_like"];
    [post setValue:[NSString stringWithFormat:@"%@|%@", _posts.longitude, _posts.latitude] forKey:@"location"];
    [post setValue:_posts.time forKey:@"time_post"];
    [post setValue:_posts.timeLike forKey:@"time_like"];
    [post setValue:_posts.urlFull forKey:@"url_images_full"];
    [post setValue:_posts.urlThumb forKey:@"url_images_thumb"];
    [post setValue:_posts.video forKey:@"url_video"];
    [post setValue:_posts.urlAvatarThumb forKey:@"url_avatar_thumb"];
    [post setValue:_posts.urlAvatarFull forKey:@"url_avatar_full"];
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) deletePost:(int)_userID withClientKey:(NSString*)_clientKey{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Posts"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_post_id = %i && client_key = %@)", _userID, _clientKey];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *posts = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *post = (NSManagedObject*)[posts lastObject];
    if (post) {
        [context delete:post];
    }
    
    return YES;
}

#pragma -mark Friend Request
- (NSMutableArray*) getFriendRequest{
    NSManagedObjectContext  *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FriendRequest"];
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (NSMutableArray*) getFriendRequestWithUserID:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FriendRequest"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *friendRequest = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return friendRequest;
}

- (NSMutableArray*) getFriendRequestWithID:(int)_userID withFriendRequestID:(int)_friendRequestID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FriendRequest"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i && friend_request_id = %i)", _userID, _friendRequestID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *friendRequest = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return friendRequest;
}

- (BOOL) isExistsFriendRequest:(int)_userID withFriendRequestID:(int)_friendRequestID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FriendRequest"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i && friend_request_id = %i)", _userID, _friendRequestID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *friendRequests = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *request = (NSManagedObject*)[friendRequests lastObject];
    if (request) {
        return YES;
    }
    
    return NO;
}

- (BOOL) saveFriendRequest:(UserSearch*)_friendRequest{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newFriendRequest = [NSEntityDescription insertNewObjectForEntityForName:@"FriendRequest" inManagedObjectContext:context];
    [newFriendRequest setValue:[NSNumber numberWithInt:_friendRequest.userID] forKey:@"user_id"];
    [newFriendRequest setValue:[NSNumber numberWithInt:_friendRequest.friendID] forKey:@"friend_request_id"];
    [newFriendRequest setValue:[NSString stringWithFormat:@"%@ %@", _friendRequest.firstName, _friendRequest.lastName] forKey:@"nick_name"];
    [newFriendRequest setValue:_friendRequest.urlAvatar forKey:@"url_thumbnail"];
    [newFriendRequest setValue:_friendRequest.urlAvatarFull forKey:@"url_avatar"];
    [newFriendRequest setValue:_friendRequest.userName forKey:@"user_name"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) updateFriendRequest:(UserSearch*)_friendRequest{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FriendRequest"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i && friend_request_id = %i)", _friendRequest.userID, _friendRequest.friendID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *friendRequest = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *request = (NSManagedObject*)[friendRequest lastObject];
    
    [request setValue:[NSString stringWithFormat:@"%@ %@", _friendRequest.firstName, _friendRequest.lastName] forKey:@"nick_name"];
    [request setValue:_friendRequest.urlAvatar forKey:@"url_thumbnail"];
    [request setValue:_friendRequest.urlAvatarFull forKey:@"url_avatar"];
    [request setValue:_friendRequest.userName forKey:@"user_name"];
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (void) deleteFriendRequest:(int)_userID withFriendRequestID:(int)_friendRequestID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FriendRequest"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i && friend_request_id = %i)", _userID, _friendRequestID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *friendRequest = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *request = (NSManagedObject*)[friendRequest lastObject];
    if (request) {
        [context delete:request];
    }
}

#pragma -mark Group Chat
//Group Chat
- (NSMutableArray*) getGroupChat{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChat"];
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (NSMutableArray*) getGroupChatWithUserID:(int)_userID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChat"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i)", _userID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *groupChats = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return groupChats;
}

- (NSMutableArray*) getGroupChatWithID:(int)_userID withGroupChatID:(int)_groupChatID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChat"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i && recent_id = %i)", _userID, _groupChatID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *groupChats = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return groupChats;
}

- (BOOL) isExistsGroupChat:(int)_userID withGroupChatID:(int)_groupChatID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChat"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id = %i && recent_id = %i", _userID, _groupChatID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *groupChats = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *groupChat = (NSManagedObject*)[groupChats lastObject];
    
    if (groupChat) {
        return YES;
    }
    
    return NO;
}

- (BOOL) saveGroupChat:(Recent*)_recent{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newGroupChat = [NSEntityDescription insertNewObjectForEntityForName:@"GroupChat" inManagedObjectContext:context];
    [newGroupChat setValue:_recent.nameRecent forKey:@"name_recent"];
    [newGroupChat setValue:[NSNumber numberWithInt:_recent.recentID] forKey:@"recent_id"];
    [newGroupChat setValue:[NSNumber numberWithInt:_recent.typeRecent] forKey:@"type_recent"];
    [newGroupChat setValue:_recent.urlThumbnail forKey:@"url_thumbnail"];
    [newGroupChat setValue:[NSNumber numberWithInt:_recent.userID] forKey:@"user_id"];
    
    
    NSError *error = nil;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) updateGroupChat:(Recent*)_recent{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChat"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i && recent_id = %i)", _recent.userID, _recent.recentID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *groupChats = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *request = (NSManagedObject*)[groupChats lastObject];
    
    [request setValue:_recent.nameRecent forKey:@"name_recent"];
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (void) deleteGroupChat:(int)_userID withGroupChatID:(int)_groupChatID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChat"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id = %i && recent_id = %i)", _userID, _groupChatID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *groupChats = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *request = (NSManagedObject*)[groupChats lastObject];
    if (request) {
        [context delete:request];
    }
}

#pragma -mark Group Chat Friend
- (NSMutableArray*) getGroupChatFriend{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChatFriends"];
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (NSMutableArray*) getGroupChatFriendWithGroupID:(int)_groupID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChatFriends"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friend_group_chat_id = %i", _groupID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (BOOL) isExistsGroupChatFriend:(int)_groupChatFriendID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChatFriends"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friend_group_chat_id = %i", _groupChatFriendID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *groupChats = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *groupChat = (NSManagedObject*)[groupChats lastObject];
    
    if (groupChat) {
        return YES;
    }
    
    return NO;
}

- (BOOL) saveGroupChatFriend:(Recent *)_recent{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (_recent.friendRecent) {
        int count = (int)[_recent.friendRecent count];
        for (int i = 0; i < count; i++) {
            Friend *_friend = [_recent.friendRecent objectAtIndex:i];
         
            NSManagedObject *newGroupChatFriend = [NSEntityDescription insertNewObjectForEntityForName:@"GroupChatFriends" inManagedObjectContext:context];
            
            [newGroupChatFriend setValue:[NSNumber numberWithInt:_recent.recentID] forKey:@"friend_group_chat_id"];
            [newGroupChatFriend setValue:[NSNumber numberWithInt:_friend.friendID] forKey:@"friend_id"];
            [newGroupChatFriend setValue:_friend.nickName forKey:@"nick_name"];
            [newGroupChatFriend setValue:_friend.urlThumbnail forKey:@"url_thumbnail"];
            [newGroupChatFriend setValue:_friend.urlAvatar forKey:@"url_avatar"];
            [newGroupChatFriend setValue:_friend.userName forKey:@"user_name"];
            
            NSError *error = nil;
            if (![context save:&error]) {
                return NO;
            }

        }
    }
    
    
    return YES;
}

- (BOOL) updateGroupChatFriend:(Friend*)_friend withGroupChatID:(int)_groupChatID;{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChatFriends"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(friend_group_chat_id = %i && friend_id = %i)", _groupChatID, _friend.friendID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *groupChats = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *request = (NSManagedObject*)[groupChats lastObject];
    
    [request setValue:_friend.nickName forKey:@"nick_name"];
    [request setValue:_friend.urlThumbnail forKey:@"url_thumbnail"];
    [request setValue:_friend.urlAvatar forKey:@"url_avatar"];
    [request setValue:_friend.userName forKey:@"user_name"];
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (void) deleteGroupChatFriend:(int)_groupID withFriendID:(int)_friendID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupChatFriends"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(friend_group_chat_id = %i && friend_id = %i)", _groupID, _friendID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *groupChats = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *request = (NSManagedObject*)[groupChats lastObject];
    if (request) {
        [context delete:request];
    }
}

#pragma -mark Group Chat Message
//Group Chat Message
- (NSMutableArray*) getGroupChatMessage{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupMessages"];
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (NSMutableArray*) getGroupChatMessageWithGroupID:(int)_groupID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupMessages"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_id = %i", _groupID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (NSMutableArray*) getGroupChatMessageWithUserID:(int)_groupID withFriendID:(int)_friendID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupMessages"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_id = %i && friend_id = %i", _groupID, _friendID];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *result = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return result;
}

- (BOOL) isExistsGroupChatMessage:(NSString*)_keyMessage{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupMessages"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key_send_message = %@", _keyMessage];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *groupChats = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *groupChat = (NSManagedObject*)[groupChats lastObject];
    
    if (groupChat) {
        return YES;
    }
    
    return NO;
}

- (BOOL) saveGroupChatMessage:(Messenger*)_message withGroupID:(int)_groupID{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //create new a managed object
    NSManagedObject *newMessenger = [NSEntityDescription insertNewObjectForEntityForName:@"GroupMessages" inManagedObjectContext:context];
    
    [newMessenger setValue:[NSNumber numberWithInt:_groupID] forKey:@"group_id"];
    [newMessenger setValue:_message.keySendMessage forKey:@"key_send_message"];
    [newMessenger setValue:_message.strMessage forKey:@"str_messenger"];
    [newMessenger setValue:_message.strImage forKey:@"strImage"];
    [newMessenger setValue:[NSNumber numberWithInt:_message.typeMessage] forKey:@"type_messenger"];
    [newMessenger setValue:[NSNumber numberWithInt:_message.statusMessage] forKey:@"status_messenger"];
    [newMessenger setValue:_message.timeMessage forKey:@"time_messenger"];
    [newMessenger setValue:[helperIns convertNSDateToString:_message.timeServerMessage withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"time_server"];
    [newMessenger setValue:_message.urlImage forKey:@"url_image"];
    [newMessenger setValue:_message.amazonKey forKey:@"amazon_key"];
    [newMessenger setValue:_message.longitude forKey:@"longitude"];
    [newMessenger setValue:_message.latitude forKey:@"latitude"];
    [newMessenger setValue:[NSNumber numberWithInt:_message.friendID] forKey:@"friend_id"];
    [newMessenger setValue:[NSNumber numberWithInt:_message.userID] forKey:@"user_id"];
    [newMessenger setValue:[NSNumber numberWithInt:_message.timeOutMessenger] forKey:@"timeout_messenger"];
    [newMessenger setValue:[NSNumber numberWithBool:_message.isTimeOut] forKey:@"is_timeout"];
    
    NSError *error= nil;
    if (![context save:&error]) {
        NSLog(@"add new failed");
    }
    
    return YES;
}

- (BOOL) updateGroupChatMessage:(Messenger*)_message{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupMessages"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key_send_message = %@)", _message.keySendMessage];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *messengers = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *messenger = (NSManagedObject*)[messengers lastObject];
    
    [messenger setValue:_message.strMessage forKey:@"str_messenger"];
    [messenger setValue:[NSNumber numberWithInt:_message.statusMessage] forKey:@"status_messenger"];
    [messenger setValue:_message.timeMessage forKey:@"time_messenger"];
    [messenger setValue:[helperIns convertNSDateToString:_message.timeServerMessage withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"time_server"];
    [messenger setValue:_message.urlImage forKey:@"url_image"];
    [messenger setValue:_message.amazonKey forKey:@"amazon_key"];
    [messenger setValue:_message.longitude forKey:@"longitude"];
    [messenger setValue:_message.latitude forKey:@"latitude"];
    [messenger setValue:[NSNumber numberWithInt:_message.timeOutMessenger] forKey:@"timeout_messenger"];
    [messenger setValue:[NSNumber numberWithBool:_message.isTimeOut] forKey:@"is_timeout"];
    
    if (![context save:&error])
        return NO;
    
    return YES;
}

- (void) deleteGroupChatMessage:(NSString*)_keyMessage{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GroupMessages"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key_send_message = %@)", _keyMessage];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *messengers = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *messenger = (NSManagedObject*)[messengers lastObject];
    
    [context deleteObject:messenger];
}
@end
