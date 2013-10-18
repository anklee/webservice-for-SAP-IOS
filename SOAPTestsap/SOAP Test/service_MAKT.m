//
//  table.m
//  SOAP Test
//
//  Created by Li Wen Jun on 13-8-11.
//  Copyright (c) 2013年 Yang. All rights reserved.
//

#import "service_MAKT.h"

@implementation service_MAKT

- (id)init
{
//	if((self = [super init])) {
		MANDT = 0;
		MATNR = 0;
		SPRAS = 0;
		MAKTX = 0;
		MAKTG = 0;
//	}
	
//	return self;
}

-(void)getmatnr:matnr{
    MATNR = MATNR;
}

@end
