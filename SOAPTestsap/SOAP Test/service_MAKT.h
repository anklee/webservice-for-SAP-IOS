//
//  table.h
//  SOAP Test
//
//  Created by Li Wen Jun on 13-8-11.
//  Copyright (c) 2013年 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface service_MAKT : NSObject
{
	
    /* elements */
	NSString * MANDT;
	NSString * MATNR;
	NSString * SPRAS;
	NSString * MAKTX;
	NSString * MAKTG;
    /* attributes */
}
@property NSString *matnr;
-(void)getmatnr:matnr;
@end
