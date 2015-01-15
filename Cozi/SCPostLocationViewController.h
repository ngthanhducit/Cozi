//
//  SCPostLocationViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/13/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCPostParentViewController.h"
#import "SCSearchBarV2.h"
#import "SCNearTableView.h"
#import "NearLocation.h"
#import "TriangleView.h"
#import "Mapbox.h"

@interface SCPostLocationViewController : SCPostParentViewController <UISearchDisplayDelegate, UISearchBarDelegate, UITextFieldDelegate, RMMapViewDelegate, UIGestureRecognizerDelegate>
{
//    CGFloat                 hHeader;
//    Helper                  *helperIns;
//    Store                   *storeIns;
    UISearchDisplayController	*searchDisplayController;
    RMMapView                   *mapView;
    CLLocation                  *lastLocation;
    UIView          *vSearch;
    UIView *vNearTitle;
    CGFloat         yNear;
    CGFloat         hNear;
}

@property (nonatomic, strong) UIActivityIndicatorView   *waiting;
@property (nonatomic, strong) UISearchDisplayController	*searchDisplayController;
@property (nonatomic, strong) UIView                    *vBlur;
@property (nonatomic, strong) UIView                    *vMaps;
@property (nonatomic, strong) UIView                    *vNear;
@property (nonatomic, strong) UIView                    *vButton;
@property (nonatomic, strong) SCNearTableView           *tbNearLocation;
@property (nonatomic, strong) UIButton                  *btnPostLocation;
@property (nonatomic, strong) NSMutableArray            *nearItems;
@property (nonatomic, strong) UIView                    *vMarket;
@property (nonatomic, strong) UIImageView               *imgMarket;
//@property (nonatomic, strong) UIButton                  *btnClose;
//@property (nonatomic, strong) UIView                    *vHeader;
@end