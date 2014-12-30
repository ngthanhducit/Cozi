//
//  WallV6.m
//  VPix
//
//  Created by khoa ngo on 11/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "WallV6.h"
#import "WallV6Item.h"


@implementation WallV6
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    _allItems=[[NSMutableArray alloc] init];
    
    return self;
}

-(void) addItem:(UIImage*)img itemId:(int)itemId{
    
    int count=[_allItems count];
    int div=count % 3;
    int num=(count-div)/3;
    int w=self.frame.size.width;
    int top=num*w*3/2;
    int h=top;
    UIImage *sImg=[self cutSquare:img];
    WallV6Item *item;
    if(num==0)//first block
    {
        if(div==0)
        {
            item =[[WallV6Item alloc] initWithFrame:CGRectMake(0, 0, w, w)];
            h+=w;
        }
        else if(div==1)
        {
            item =[[WallV6Item alloc] initWithFrame:CGRectMake(0, w, w, w)];
            h+=w;
        }
        else
        {
            //make block
            WallV6Item *firstItem=_allItems[0];
            firstItem.frame=CGRectMake(0, 0, w/2, w/2);
            WallV6Item *secondITem=_allItems[1];
            secondITem.frame=CGRectMake(w/2, 0, w/2, w/2);
            item=[[WallV6Item alloc] initWithFrame:CGRectMake(0, w/2, w, w)];
            h+=3*w/2;
        }
    }
    else
    {
        if(div==0)
        {
            h=top+w;
            item=[[WallV6Item alloc] initWithFrame:CGRectMake(0, top, w, w)];
        }
        else if (div==1){
            h=top+w/2;
            WallV6Item *lastItem=_allItems[count-1];
            lastItem.frame=CGRectMake(0, top, w/2, w/2);
            item=[[WallV6Item alloc] initWithFrame:CGRectMake(w/2, top, w/2, w/2)];
        }
        else{
            top+=w/2;
            h=top+w;
            
            item=[[WallV6Item alloc] initWithFrame:CGRectMake(0, top, w, w)];
        }
    }
    [item setImage:sImg];
    [self addSubview:item];

    [item addClickListener:self selector:@selector(itemClick:)];
    item.itemId=itemId;
    [_allItems addObject:item];
    
    [self setContentSize:CGSizeMake(w, h)];
}

-(void) itemClick:(WallV6Item*)item{
    NSLog(@"item click: %d",item.itemId);
}

-(UIImage*) cutSquare:(UIImage*)input
{
    CGFloat iW = input.size.width;
    CGFloat iH = input.size.height;
    CGRect frame;
    int l;
    if(iW>iH)
    {
        frame=CGRectMake(0, 0, iH, iH);
        l=-1*(iW-iH)/2;
    }
    else
    {
        frame=CGRectMake(0, 0, iW, iW);
        l=0;
    }
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);

    [input drawAtPoint:CGPointMake(l, 0)];
    UIImage *outImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImg;
}
@end
