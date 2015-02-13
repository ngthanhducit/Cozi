//
//  SCPostLocationViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/13/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPostLocationViewController.h"
#import "AppDelegate.h"

@interface SCPostLocationViewController ()

@end

@implementation SCPostLocationViewController

@synthesize vBlur;
@synthesize searchDisplayController;
@synthesize vMaps;
@synthesize vNear;
@synthesize tbNearLocation;
@synthesize btnClose;
@synthesize btnPostLocation;
@synthesize nearItems;
@synthesize vMarket;
@synthesize imgMarket;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNotification];
    [self setupUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.lblTitle setText:@"LOCATION"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) setupNotification{
    self.nearItems = [NSMutableArray new];
    networkControllerIns = [NetworkController shareInstance];
    
    lastLocation = [[CLLocation alloc] initWithLatitude:[[storeIns getlatitude] floatValue] longitude:[[storeIns getLongitude] floatValue]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNearLocation:) name:@"SelectNearLocation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setResultAddWall:) name:@"setResultAddWall" object:nil];
}

- (void) setupUI{
    vSearch = [[UIView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, hHeader)];
    [vSearch setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:vSearch];

    SCSearchBarV2 *searchBar = [[SCSearchBarV2 alloc] initWithFrame:CGRectMake(0, 0, vSearch.bounds.size.width, vSearch.bounds.size.height)];
    [searchBar setDelegate:self];
    [searchBar setPlaceholder:@"SEARCH"];
    
    [vSearch addSubview:searchBar];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.vMaps = [[UIView alloc] initWithFrame:CGRectMake(0, hHeader + (vSearch.bounds.size.height), self.view.bounds.size.width, self.view.bounds.size.height / 3)];
        [self.vMaps setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.vMaps];
        
        RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"ngthanhducit.kok79pln"];
        mapView = [[RMMapView alloc] initWithFrame:self.vMaps.bounds andTilesource:tileSource];
        [mapView setShowsUserLocation:YES];
        
        [mapView setDelegate:self];
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([[storeIns getlatitude] doubleValue], [[storeIns getLongitude] doubleValue]);
        [mapView setCenterCoordinate:center];
        mapView.zoom = 15;
        
        [self.vMaps addSubview:mapView];
        
        self.vMarket = [[UIView alloc] initWithFrame:self.vMaps.bounds];
        [self.vMarket setBackgroundColor:[UIColor clearColor]];
        [self.vMarket setUserInteractionEnabled:NO];
        [self.vMarket setAlpha:0.5];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.vMaps addSubview:self.vMarket];
        });
        
    });
    
    UIImage *img = [helperIns getImageFromSVGName:@"icon-LocationGreen.svg"];
    self.imgMarket = [[UIImageView alloc] initWithImage:img];
    [self.imgMarket setFrame:CGRectMake((self.vMaps.bounds.size.width / 2) - 15, (self.vMaps.bounds.size.height / 2) - 15, 30, 30)];
    [self.vMarket addSubview:self.imgMarket];
    
    self.vButton = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 80)];
    [self.vButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.vButton];
    
    yNear = hHeader + (vSearch.bounds.size.height) + self.vMaps.bounds.size.height;
    hNear = self.view.bounds.size.height - (hHeader + vSearch.bounds.size.height + self.vMaps.bounds.size.height);
    
    self.vNear = [[UIView alloc] initWithFrame:CGRectMake(0, yNear, self.view.bounds.size.width, hNear)];
    [self.vNear setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.vNear];
    
    vNearTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vNear.bounds.size.width, 30)];
    [vNearTitle setBackgroundColor:[UIColor blackColor]];
    [self.vNear addSubview:vNearTitle];
    
    UIImage *imgNear = [helperIns getImageFromSVGName:@"icon-MapBlue.svg"];
    UIImageView *imgNearView = [[UIImageView alloc] initWithImage:imgNear];
    [imgNearView setFrame:CGRectMake(10, 5, vNearTitle.bounds.size.height - 10, vNearTitle.bounds.size.height - 10)];
    [vNearTitle addSubview:imgNearView];
    
    UILabel *lblNear = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, vNearTitle.bounds.size.width, vNearTitle.bounds.size.height)];
    [lblNear setText:@"NEAR BY LOCATIONS"];
    [lblNear setTextColor:[UIColor whiteColor]];
    [lblNear setFont:[helperIns getFontLight:15.0f]];
    [vNearTitle addSubview:lblNear];
    
    self.tbNearLocation = [[SCNearTableView alloc] initWithFrame:CGRectMake(0, vNearTitle.bounds.size.height, self.view.bounds.size.width, self.vNear.bounds.size.height - vNearTitle.bounds.size.height) style:UITableViewStylePlain];
    [self.tbNearLocation setBackgroundColor:[UIColor clearColor]];
    [self.vNear addSubview:self.tbNearLocation];
    
    self.waiting = [[UIActivityIndicatorView alloc] initWithFrame:self.tbNearLocation.bounds];
    [self.waiting setHidden:YES];
    [self.vNear addSubview:self.waiting];
    
    self.vBlur = [[UIView alloc] initWithFrame:CGRectMake(0, hHeader * 2, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader * 2))];
    [self.vBlur setUserInteractionEnabled:YES];
    [self.vBlur setBackgroundColor:[UIColor lightGrayColor]];
    [self.vBlur setAlpha:0.6];
    [self.vBlur setHidden:YES];
    [self.view addSubview:self.vBlur];
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor whiteColor]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [helperIns imageWithView:triangleJoinNow];
    
    self.btnPostLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPostLocation setBackgroundColor:[UIColor blackColor]];
    [self.btnPostLocation setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnPostLocation.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnPostLocation setContentMode:UIViewContentModeCenter];
    [self.btnPostLocation setFrame:CGRectMake(0, 0, self.vButton.bounds.size.width, self.vButton.bounds.size.height)];
    [self.btnPostLocation setTitle:@"SEND LOCATION" forState:UIControlStateNormal];
    [self.btnPostLocation addTarget:self action:@selector(btnSendLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPostLocation.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnPostLocation.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnPostLocation setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnPostLocation.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.btnPostLocation setTitleColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] forState:UIControlStateNormal];

    [self.vButton addSubview:self.btnPostLocation];

}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (![searchBar.text isEqualToString:@""]) {
        [self downloadLocation:searchBar.text];
    }

    [self.view endEditing:YES];
}

- (void) downloadLocation:(NSString*)_strKeywork{

    _strKeywork = [_strKeywork stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=50000&keyword=%@&key=%@", [storeIns getlatitude], [storeIns getLongitude], _strKeywork, storeIns.keyGoogleMaps];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    [self downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            // Convert the returned data into a dictionary.
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{

                NSArray *dic = [returnedDict objectForKey:@"results"];
                if (dic != nil && [dic count] > 0) {
                    int count = (int)[dic count];
                    for (int i = 0; i < count; i++) {
                        NSDictionary *data = [dic objectAtIndex:i];
                        NearLocation *_near = [NearLocation new];
                        _near.nearName = [data objectForKey:@"name"];
                        _near.vicinity = [data objectForKey:@"vicinity"];
                        
                        [self.nearItems addObject:_near];
                    }
                }
                
                [self.tbNearLocation setData:self.nearItems];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tbNearLocation reloadData];
                });

                
                NSLog(@"%@", dic);
                
            }
        }
    }];
    
}

- (void) downloadLocation:(NSString*)_latitude withLongitude:(NSString*)_longitude{
    
    [self.waiting setHidden:NO];
    
    self.nearItems = [NSMutableArray new];
    
    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=500&key=%@", _latitude, _longitude, storeIns.keyGoogleMaps];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    [self downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            
            // Convert the returned data into a dictionary.
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                
                NSArray *dic = [returnedDict objectForKey:@"results"];
                if (dic != nil && [dic count] > 0) {
                    int count = (int)[dic count];
                    for (int i = 0; i < count; i++) {
                        NSDictionary *data = [dic objectAtIndex:i];
                        NearLocation *_near = [NearLocation new];
                        _near.nearName = [data objectForKey:@"name"];
                        _near.vicinity = [data objectForKey:@"vicinity"];
                        NSDictionary *subGeometry = [data objectForKey:@"geometry"];
                        NSDictionary *subLocation = [subGeometry objectForKey:@"location"];
                        
                        _near.lat = [subLocation objectForKey:@"lat"];
                        _near.lng = [subLocation objectForKey:@"lng"];
                        
                        [self.nearItems addObject:_near];
                    }
                }
                
                NSString *nextToken = [returnedDict objectForKey:@"next_page_token"];
                
                [self.tbNearLocation setData:self.nearItems];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tbNearLocation reloadData];
                    [self.waiting setHidden:YES];
                    if (nextToken != nil) {
                        [self downloadLocationWithNextPage:url withToken:nextToken];
                    }

                });
                
            }
        }
    }];
    
}

- (void) downloadLocationWithNextPage:(NSURL*)_url withToken:(NSString*)_nextPageToken{
    
    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=500&key=%@&pagetoken=%@", [storeIns getlatitude], [storeIns getLongitude], storeIns.keyGoogleMaps, _nextPageToken];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    [self downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            // Convert the returned data into a dictionary.
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                
                NSArray *dic = [returnedDict objectForKey:@"results"];
                if (dic != nil && [dic count] > 0) {
                    int count = (int)[dic count];
                    for (int i = 0; i < count; i++) {
                        NSDictionary *data = [dic objectAtIndex:i];
                        NearLocation *_near = [NearLocation new];
                        _near.nearName = [data objectForKey:@"name"];
                        _near.vicinity = [data objectForKey:@"vicinity"];
                        
                        [self.nearItems addObject:_near];
                    }
                }
                
                NSString *nextToken = [returnedDict objectForKey:@""];

                [self.tbNearLocation addData:self.nearItems];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tbNearLocation reloadData];
                    
                    if (nextToken != nil) {
                        [self downloadLocationWithNextPage:url withToken:nextToken];
                    }

                });
                
            }
        }
    }];
    
}

- (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %d", HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.view == self.vBlur) {
        [self.view endEditing:YES];
    }
}

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{

    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.vBlur setHidden:NO];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.vBlur setHidden:YES];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma -mark RMMapView Delegate
- (void) mapView:(RMMapView *)mapView didUpdateUserLocation:(RMUserLocation *)userLocation{
    CLLocationCoordinate2D l = CLLocationCoordinate2DMake([[storeIns getlatitude] doubleValue], [[storeIns getLongitude] doubleValue]);
    
    [mapView setCenterCoordinate:l animated:YES];
}

- (void) beforeMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction{

    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.imgMarket setFrame:CGRectMake((self.vMaps.bounds.size.width / 2) - 15, (self.vMaps.bounds.size.height / 2) - 25, 30, 30)];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void) afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction{

    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.imgMarket setFrame:CGRectMake((self.vMaps.bounds.size.width / 2) - 15, (self.vMaps.bounds.size.height / 2) - 15, 30, 30)];
        [self.vButton setFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 80)];
        [self.vNear setFrame:CGRectMake(0, hHeader + vSearch.bounds.size.height + self.vMaps.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader + vSearch.bounds.size.height + self.vMaps.bounds.size.height))];
        [self.tbNearLocation setFrame:CGRectMake(0, vNearTitle.bounds.size.height, self.view.bounds.size.width, self.vNear.bounds.size.height - vNearTitle.bounds.size.height)];
    } completion:^(BOOL finished) {
        
    }];

    CLLocationCoordinate2D center = [mapView centerCoordinate];
    NSString *strLa = [NSString stringWithFormat:@"%g", center.latitude];
    NSString *strLo = [NSString stringWithFormat:@"%g", center.longitude];
    
//    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
    
//    CLLocationDistance dis = [lastLocation distanceFromLocation:newLocation];

    [self downloadLocation:strLa withLongitude:strLo];
}

- (void) mapViewRegionDidChange:(RMMapView *)mapView{
//    NSLog(@"RMMapView region did change");

}

- (void) selectNearLocation:(NSNotification*)_notification{
    NSDictionary *userInfo = [_notification userInfo];
    NSNumber *index = (NSNumber*)[userInfo objectForKey:@"NearLocationIndex"];
    indexNear = index.intValue;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.vNear setFrame:CGRectMake(0, yNear, self.view.bounds.size.width, hNear - 80)];
        
        [self.tbNearLocation setFrame:CGRectMake(0, vNearTitle.bounds.size.height, self.view.bounds.size.width, hNear - vNearTitle.bounds.size.height - 80)];
        [self.vButton setFrame:CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80)];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) btnSendLocation:(id)sender{
    NearLocation *near = [self.nearItems objectAtIndex:indexNear];
    
    if (near) {
        
        _clientKeyID = [storeIns randomKeyMessenger];
        NSString *tempClientKey = [helperIns encodedBase64:[[NSString stringWithFormat:@"%i", (int)_clientKeyID] dataUsingEncoding:NSUTF8StringEncoding]];
        
//        NSString *location = [NSString stringWithFormat:@"%@|%@", near.lng, near.lat];
//        
//        [networkControllerIns addPost:@"" withImage:@"" withImageThumb: @"" withVideo:@"" withLocation:location withClientKey:tempClientKey withCode:2];
    }
}

- (void) setResultAddWall:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSString *_strResult = (NSString*)[userInfo objectForKey:@"ADDPOST"];
    
    NSArray *subCommand = [_strResult componentsSeparatedByString:@"}"];
    if ([subCommand count] == 2) {
        NSInteger key = [[helperIns decode:[subCommand objectAtIndex:1]] integerValue];
        if (key > 0) {
            NearLocation *near = [self.nearItems objectAtIndex:indexNear];
            DataWall *_newWall = [DataWall new];
            _newWall.userPostID = storeIns.user.userID;
            _newWall.content = @"";
            _newWall.images = [NSMutableArray new];
            _newWall.video = @"";
            _newWall.longitude = near.lng;
            _newWall.latitude = near.lat;
            _newWall.time = [subCommand objectAtIndex:0];
//            _newWall.typePost = 2;
            _newWall.codeType = 2;
            _newWall.clientKey = [NSString stringWithFormat:@"%i", (int)_clientKeyID];
            
            [storeIns insertWallData:_newWall];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadWallAndNoises" object:nil];
        }else{
            //Error add post
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
