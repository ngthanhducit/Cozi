//
//  AppleMapView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/9/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "AppleMapView.h"

@implementation AppleMapView

//@synthesize mapView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{
    Helper *helperIns = [Helper shareInstance];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 40)];
    [mapView setDelegate:self];
    
    [self addSubview:mapView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
    [bottomView setBackgroundColor:[UIColor orangeColor]];
//    [self addSubview:bottomView];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setTitle:@"CLOSE" forState:UIControlStateNormal];
    [btnClose.titleLabel setFont:[helperIns getFontLight:15]];
    [btnClose setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [btnClose setFrame:CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40)];
    
    [btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btnClose addTarget:self action:@selector(closeMap) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnClose];
}

- (void) addAnnotation:(CGFloat)latitude withLongitude:(CGFloat)longitude withFriend:(Friend *)_friend{
    CLLocation  *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    MKCoordinateRegion mkr;
    mkr.center = location.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.0144927536;
    span.longitudeDelta = 0.0144927536;
    mkr.span = span;
    
    [mapView setRegion:mkr animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = _friend.nickName;
//    point.subtitle = @"I'm here!!!";
    
    [mapView addAnnotation:point];
}

- (void) addAnnotation:(CGFloat)latitude withLongitude:(CGFloat)longitude withUser:(User *)_user{
    
}

- (void) closeMap{
    [self removeFromSuperview];
}
@end


