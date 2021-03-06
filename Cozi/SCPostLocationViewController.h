//
//  SCPostLocationViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/13/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCPostParentViewController.h"
#import "SCSearchBarV2.h"
#import "SCNearTableView.h"
#import "NearLocation.h"
#import "TriangleView.h"
#import "Mapbox.h"
#import "NetworkController.h"
#import "SCActivityIndicatorView.h"

@interface SCPostLocationViewController : SCPostParentViewController <UISearchDisplayDelegate, UISearchBarDelegate, UITextFieldDelegate, MKMapViewDelegate>
{
    UISearchDisplayController	*searchDisplayController;
//    RMMapView                   *mapView;
//    MKMapView                   *mapView;
    CLLocation                  *lastLocation;
    UIView          *vSearch;
    UIView *vNearTitle;
    CGFloat         yNear;
    CGFloat         hNear;
    int             indexNear;
    NSString               *_clientKeyID;
    NetworkController       *networkControllerIns;
    BOOL                    isFinishLoadMap;
}

@property (nonatomic, strong) MKMapView                 *mapView;
@property (nonatomic, strong) SCActivityIndicatorView   *waiting;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) UIView                    *vBlur;
@property (nonatomic, strong) UIView                    *vMaps;
@property (nonatomic, strong) UIView                    *vNear;
@property (nonatomic, strong) UIView                    *vButton;
@property (nonatomic, strong) SCNearTableView           *tbNearLocation;
@property (nonatomic, strong) UIButton                  *btnPostLocation;
@property (nonatomic, strong) NSMutableArray            *nearItems;
@property (nonatomic, strong) UIView                    *vMarket;
@property (nonatomic, strong) UIImageView               *imgMarket;
@end
