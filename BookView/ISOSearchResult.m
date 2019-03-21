//
//  ISOSearchResult.m
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOSearchResult.h"

@implementation ISOSearchResult

- initWithChapterIndex:(int)theChapterIndex pageIndex:(int)thePageIndex hitIndex:(int)theHitIndex neighboringText:(NSString*)theNeighboringText originatingQuery:(NSString*)theOriginatingQuery
{
	self = [super init];
	return self;
}
@end
