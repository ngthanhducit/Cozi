//
//  SCChatToolKitView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/27/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCChatToolKitView.h"

@implementation SCChatToolKitView

@synthesize vTextView;
@synthesize vTool;
@synthesize btnText;
@synthesize btnCamera;
@synthesize btnPhoto;
@synthesize btnLocation;
@synthesize btnPing;

#define SWIPE_LEFT_THRESHOLD -800.0f
#define SWIPE_RIGHT_THRESHOLD 800.0f

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void) setupUI{
    helperIns = [Helper shareInstance];
    
    alphaView = 1;
    self.vTool = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.vTool setAlpha:0.0f];
    [self addSubview:self.vTool];
    
    [self setupToolkit];
    
    self.vTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.vTextView setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
    [self addSubview:self.vTextView];
    
    self.vTextChat = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:self.vTextChat];
    
    self.hpTextChat = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width - 40, self.bounds.size.height)];
    [self.hpTextChat setBackgroundColor:[UIColor clearColor]];
    self.hpTextChat.isScrollable = NO;
    self.hpTextChat.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.hpTextChat.minNumberOfLines = 1;
    self.hpTextChat.maxNumberOfLines = 3;
    self.hpTextChat.returnKeyType = UIReturnKeyGo; //just as an example
    self.hpTextChat.font = [helperIns getFontLight:17.0f];
    [self.hpTextChat setTextColor:[UIColor colorWithRed:110.0f/255.0f green:110.0f/255.0f blue:110.0f/255.0f alpha:1]];
    self.hpTextChat.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.hpTextChat.placeholder = @"Type message here...";
    
    [self.vTextChat addSubview:self.hpTextChat];
    
    self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSendMessage setBackgroundColor:[UIColor clearColor]];
    [self.btnSendMessage setFrame:CGRectMake(self.bounds.size.width - 40, 0, 40, self.bounds.size.height)];
    [self.btnSendMessage setImage:[helperIns getImageFromSVGName:@"icon-Chat-Send.svg"] forState:UIControlStateNormal];
    [self.vTextChat addSubview:self.btnSendMessage];

    self.vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 4, self.vTextView.bounds.size.height - 20)];
    [self.vLine setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.vTextView addSubview:self.vLine];
    
    [self startTimer];
    
    [self initializeGestures];
}

- (void) setupToolkit{
    self.btnText = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnText setFrame:CGRectMake(0, 0, self.vTool.bounds.size.width / 5, self.vTool.bounds.size.height)];
    [self.btnText setImage:[helperIns getImageFromSVGName:@"icon-QuotesGrey-V2.svg"] forState:UIControlStateNormal];
    [self.btnText setBackgroundColor:[helperIns.dicColor objectForKey:@"GreenColor1"]];
    [self.vTool addSubview:self.btnText];
    
    self.btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnCamera setFrame:CGRectMake(self.vTool.bounds.size.width / 5, 0, self.vTool.bounds.size.width / 5, self.vTool.bounds.size.height)];
    [self.btnCamera setImage:[helperIns getImageFromSVGName:@"icon-CameraGrey.svg"] forState:UIControlStateNormal];
    [self.btnCamera setBackgroundColor:[helperIns.dicColor objectForKey:@"GreenColor2"]];
    [self.vTool addSubview:self.btnCamera];
    
    self.btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPhoto setFrame:CGRectMake((self.vTool.bounds.size.width / 5) * 2, 0, self.vTool.bounds.size.width / 5, self.vTool.bounds.size.height)];
    [self.btnPhoto setImage:[helperIns getImageFromSVGName:@"icon-PhotoGrey.svg"] forState:UIControlStateNormal];
    [self.btnPhoto setBackgroundColor:[helperIns.dicColor objectForKey:@"GreenColor3"]];
    [self.vTool addSubview:self.btnPhoto];
    
    self.btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLocation setFrame:CGRectMake((self.vTool.bounds.size.width / 5) * 3, 0, self.vTool.bounds.size.width / 5, self.vTool.bounds.size.height)];
    [self.btnLocation setImage:[helperIns getImageFromSVGName:@"icon-LocationGrey.svg"] forState:UIControlStateNormal];
    [self.btnLocation setBackgroundColor:[helperIns.dicColor objectForKey:@"GreenColor4"]];
    [self.vTool addSubview:self.btnLocation];
    
    self.btnPing = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPing setFrame:CGRectMake((self.vTool.bounds.size.width / 5) * 4, 0, self.vTool.bounds.size.width / 5, self.vTool.bounds.size.height)];
    [self.btnPing setImage:[helperIns getImageFromSVGName:@"icon-PokeGrey.svg"] forState:UIControlStateNormal];
    [self.btnPing setBackgroundColor:[helperIns.dicColor objectForKey:@"GreenColor1"]];
    [self.vTool addSubview:self.btnPing];
}

- (void) initializeGestures{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.vTextView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.vTextView addGestureRecognizer:pan];
    
    UIPanGestureRecognizer *panTool = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.vTool addGestureRecognizer:panTool];
}

- (void) tapGesture:(UITapGestureRecognizer*)recognizer{
    
    [self stopTimer];
    [self.vLine setAlpha:0.0f];
    
//    [self.hpTextChat setHidden:NO];
    [self.vTextChat setHidden:NO];
    [self.hpTextChat becomeFirstResponder];
}

- (void) panView:(UIPanGestureRecognizer*)recognizer{
    // Get the translation in the view
    CGPoint t = [recognizer translationInView:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    [self stopTimer];
    [self.vLine setAlpha:1.0f];
    
    // TODO: Here, you should translate your target view using this translation
    CGFloat deltaMove = self.vTextView.frame.origin.x + t.x;
    if (deltaMove > 0) {
        CGFloat deltaAlpha = (alphaView * t.x) / (self.bounds.size.width);
        self.vTool.alpha += deltaAlpha;
        self.vTextView.center = CGPointMake(self.vTextView.center.x + t.x, self.vTextView.center.y);
    }
    
    // But also, detect the swipe gesture
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint vel = [recognizer velocityInView:recognizer.view];
        
        if (vel.x < SWIPE_LEFT_THRESHOLD)
        {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionTransitionCurlUp animations:^{
                [self.vTextView setFrame:CGRectMake(0, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
            } completion:^(BOOL finished) {
                [self.vTool setAlpha:0];
                
                [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [self.vTextView setFrame:CGRectMake(4, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.vTextView setFrame:CGRectMake(0, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            }];
        }
        else if (vel.x > SWIPE_RIGHT_THRESHOLD)
        {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionTransitionCurlUp animations:^{
                [self.vTextView setFrame:CGRectMake(self.bounds.size.width, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
            } completion:^(BOOL finished) {
                [self.vTool setAlpha:1];
                
                [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionTransitionCurlUp animations:^{
                    [self.vTextView setFrame:CGRectMake(self.bounds.size.width - 4, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                } completion:^(BOOL finished) {

                    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionTransitionCurlUp animations:^{
                        [self.vTextView setFrame:CGRectMake(self.bounds.size.width, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }];
            }];
        }else{
            if (self.vTextView.frame.origin.x < self.bounds.size.width / 2) {
                //reset to left;
                [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionTransitionCurlUp animations:^{
                    [self.vTextView setFrame:CGRectMake(0, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                } completion:^(BOOL finished) {
                    [self.vTool setAlpha:0];
                    
                    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.vTextView setFrame:CGRectMake(4, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                            [self.vTextView setFrame:CGRectMake(0, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }else{
                //reset to right;
                [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionTransitionCurlUp animations:^{
                    [self.vTextView setFrame:CGRectMake(self.bounds.size.width, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                } completion:^(BOOL finished) {
                    [self.vTool setAlpha:1];
                    
                    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionTransitionCurlUp animations:^{
                        [self.vTextView setFrame:CGRectMake(self.bounds.size.width - 4, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionTransitionCurlUp animations:^{
                            [self.vTextView setFrame:CGRectMake(self.bounds.size.width, self.vTextView.frame.origin.y, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }
        }
        
        [self startTimer];
    }
    
}

- (void) loopCursor:(NSTimer*)timer{
    
    if (self.vLine.alpha == 0) {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.vLine.alpha = 1;
                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.vLine.alpha = 0;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void) startTimer{
    [self stopTimer];
    timerLoop = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(loopCursor:) userInfo:nil repeats:YES];
}

- (void) stopTimer{
    if (timerLoop) {
        [timerLoop invalidate];
        timerLoop = nil;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.vTextChat setHidden:YES];
//    [self.hpTextChat setHidden:YES];
    [self.vLine setHidden:NO];
    
    [self startTimer];
    
    return YES;
}

- (void) showTextField{
    [self stopTimer];
    [self.vLine setAlpha:0.0f];
    
    [self.vTool setHidden:YES];
    
    [self.vTextChat setHidden:NO];
//    [self.hpTextChat setHidden:NO];
    [self.hpTextChat becomeFirstResponder];
}

- (void) reset{
    [self.vTool setHidden:NO];
    
    [self.vTextView setFrame:CGRectMake(0, 0, self.vTextView.bounds.size.width, self.vTextView.bounds.size.height)];
    [self.vTextChat setHidden:YES];
//    [self.hpTextChat setHidden:YES];
    [self.vLine setHidden:NO];
    
    [self startTimer];
}
@end
