//
//  ISOSearchResult.h
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISOSearchResult : NSObject
{
}

@property int chapterIndex, pageIndex, hitIndex;
@property NSString *neighboringText, *originatingQuery;

- initWithChapterIndex:(int)theChapterIndex pageIndex:(int)thePageIndex hitIndex:(int)theHitIndex neighboringText:(NSString*)theNeighboringText originatingQuery:(NSString*)theOriginatingQuery;


@end
