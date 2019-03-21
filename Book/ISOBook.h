//
//  ISOBook.h
//  xBilim
//
//  Created by Imdat Solak on 11/2/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOSingleNote.h"
#import "ISOProject.h"

#define kBookChapters				@"BookChapters"
#define kBookFilename				@"BookFilename"
#define kBookTitle					@"BookTitle"
#define kBookAuthor					@"BookAuthor"
#define kBookPubYear				@"BookPubYear"
#define kBookPubDate				@"BookPubDate"
#define kBookPublisher				@"BookPublisher"
#define kBookCategory				@"BookCategory"
#define kBookID						@"BookID"
#define kBookCover					@"BookCover"
#define kLastReadChapter			@"LastReadChapter"
#define kLastReadPositionInChapter	@"LastReadPositionInChapter"
#define kUnpackedBookPath			@"UnpackedBookPath"
#define kChapterCount				@"ChapterCount"
#define kFlatChapters				@"FlatChapterList"
#define kBookNotes					@"BookNotes"
#define kPaperBook					@"PaperBook"
#define kPaperBookEdition			@"PaperBookEdition"
#define kPaperBookComments			@"PaperBookComments"
#define kPaperBookISBN				@"PaperBookISBN"

@class ISOProjectChapter;
@class ISOSingleNote;
@class ISOProject;
@interface ISOBook : NSObject <NSCoding>
{
	NSMutableArray	*bookNotes;
}

- (BOOL)importEBookFromFile:(NSString *)bookFile;

@property NSArray	*bookChapters;
@property NSString	*bookFilename;
@property NSString	*bookTitle;
@property NSString	*bookAuthor;
@property NSString	*bookPubYear;
@property NSString	*bookPubDate;
@property NSString	*bookPublisher;
@property NSString	*bookCategory;
@property NSString	*bookID;
@property NSString	*bookCover;
@property int		bookLastReadChapter;
@property int		bookLastReadPositionInChapter;
@property BOOL		paperBook;
@property NSString	*paperBookEdition;
@property NSString	*paperBookComments;
@property NSString	*paperBookISBN;

@property NSString	*unpackedBookPath;

- (id)init;
- (id)initWithCoder:(NSCoder *)decoder;
- (id)initWithPaperBookTitle:(NSString *)aTitle author:(NSString *)anAuthor publisher:(NSString *)publisher pubYear:(NSString *)pubYear edition:(NSString *)edition comments:(NSString *)comments andISBN:(NSString *)isbn;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (NSUInteger)numberOfChapters;
- (NSDictionary *)lastViewedChapter;
- (NSDictionary *)chapterWithIndex:(NSUInteger)index;
- (NSString *)chapterTitleAtIndex:(NSUInteger)index;

- (void)setLastReadPage:(int)pageNo inChapter:(int)chapterNo;
- (void)noteChanged:(ISOSingleNote *)aNote;
- (void)addNote:(ISOSingleNote *)aNote;
- (void)removeNote:(ISOSingleNote *)aNote;
- (void)removeNoteAtIndex:(NSInteger)index;
- (NSArray *)bookNotes;
- (NSArray *)notesForChapterNumber:(NSInteger)chapterNo;
- (NSArray *)notesForProject:(ISOProject *)aProject andProjectChapter:(NSInteger)chapterNo;

@end
