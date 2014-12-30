//
//  PostViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/19/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "NetworkCommunication.h"
#import "SCImageController.h"
#import "Store.h"
#import "Cozi/ImageSelected.h"
#import "AmazonInfo.h"
#import "Wall.h"

@interface PostViewController : UIViewController<UIScrollViewDelegate>
{
    Helper              *helperIns;
    
    UIImageView             *myAvatar;
    UITextView              *txtStatus;
    
    UIButton *btnAddPhoto;
    UIButton *btnAddLocation;
    UIButton *btnAddVideo;
    UIScrollView                    *mainScroll;
    Store               *storeIns;
    NetworkCommunication        *networkIns;
    UIImage                     *lastImage;
    AmazonInfo                  *amazonInfomation;
    
    NSInteger                   _clientKeyID;
    
    UIActivityIndicatorView             *waitingView;
}

- (void) setup;
- (void) setAmazoneUpload:(AmazonInfo*)_amazon;
- (void) setResultUpload:(int)_result;
- (void) setResultAddWall:(NSString*)_strResult;
- (DataWall*) getWall;
@end
