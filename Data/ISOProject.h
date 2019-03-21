//
//  ISOProject.h
//  xBilim
//
//  Created by Imdat Solak on 10/18/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOProjectChapter.h"

@class ISOProjectChapter;

@interface ISOProject : NSObject <NSCoding>
{
}

@property NSString *projectTitle;
@property NSMutableArray *chapters;
@property NSDate *creationDate;
@property NSString *projectDescription;


- (id)initWithTitle:(NSString *)aTitle;
- (id)initWithTitle:(NSString *)aTitle andDescription:(NSString *)aDesc;
- (void)addChapter:(ISOProjectChapter *)aChapter;
- (void)removeChapter:(ISOProjectChapter *)aChapter;
- (ISOProjectChapter *)chapterWithChapterNumber:(NSInteger)anIndex;
- (NSInteger)numberOfProjectChapters;
@end
