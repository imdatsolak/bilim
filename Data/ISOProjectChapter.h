//
//  ISOProjectChapter.h
//  xBilim
//
//  Created by Imdat Solak on 10/18/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOSingleNote.h"
#import "ISOBook.h"

@class ISOSingleNote;
@class ISOBook;

@interface ISOProjectChapter : NSObject <NSCoding>
{
}

@property NSString *chapterTitle;
@property NSString *chapterDescription;
@property NSInteger chapterNumber;
@property NSMutableArray *books;
@property NSMutableArray *notes;

- (id)initWithChapterTitle:(NSString *)aTitle description:(NSString *)desc andChapterNumber:(NSInteger)aNumber;
- (void)addBook:(ISOBook *)aBook;
- (void)removeBook:(ISOBook *)aBook;
- (void)addNote:(ISOSingleNote *)aNote;
- (void)removeNote:(ISOSingleNote *)aNote;

@end
