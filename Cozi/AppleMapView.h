//
//  AppleMapView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/9/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Friend.h"
#import "User.h"
#import "Helper.h"

@interface AppleMapView : UIView <MKMapViewDelegate>
{
    MKMapView                       *mapView;
}

- (void) addAnnotation:(CGFloat)latitude withLongitude:(CGFloat)longitude withFriend:(Friend *)_friend;
- (void) addAnnotation:(CGFloat)latitude withLongitude:(CGFloat)longitude withUser:(User *)_user;
@end
