//
//  ISOProjectChapter.m
//  xBilim
//
//  Created by Imdat Solak on 10/18/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOProjectChapter.h"
#import "ISOLibraryViewController.h"

#define kCHAPTER_TITLE			@"ProjChapterTitle"
#define kCHAPTER_DESCRIPTION	@"ProjChapterDescription"
#define kCHAPTER_NUMBER			@"ProjChapterNumber"
#define kBOOK_IDS				@"ProjBookIDS"
#define kNOTE_IDS				@"ProjNoteIDS"

@implementation ISOProjectChapter

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.chapterTitle forKey:kCHAPTER_TITLE];
	[encoder encodeObject:self.chapterDescription forKey:kCHAPTER_DESCRIPTION];
	[encoder encodeInteger:self.chapterNumber forKey:kCHAPTER_NUMBER];
	[encoder encodeObject:self.books forKey:kBOOK_IDS];
	[encoder encodeObject:self.notes forKey:kNOTE_IDS];
}

- (void)decodeWithDecoder:(NSCoder *)decoder
{
	self.chapterTitle = [decoder decodeObjectForKey:kCHAPTER_TITLE];
	self.chapterDescription = [decoder decodeObjectForKey:kCHAPTER_DESCRIPTION];
	self.chapterNumber = [decoder decodeIntegerForKey:kCHAPTER_NUMBER];
	self.books = [decoder decodeObjectForKey:kBOOK_IDS];
	self.notes = [decoder decodeObjectForKey:kNOTE_IDS];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self) {
		[self decodeWithDecoder:aDecoder];
		return self;
	}
	return nil;
}


- (id)initWithChapterTitle:(NSString *)aTitle description:(NSString *)desc andChapterNumber:(NSInteger)aNumber;
{
	self = [super init];
	if (self) {
		self.chapterNumber = aNumber;
		self.chapterTitle = aTitle;
		self.chapterDescription = desc;
		self.books = [[NSMutableArray alloc] init];
		self.notes = [[NSMutableArray alloc] init];
		return self;
	}
	return nil;
}

- (void)addBook:(ISOBook *)aBook
{
	if (aBook && ![self.books containsObject:aBook]) {
		[self.books addObject:aBook];
	}
}

- (void)removeBook:(ISOBook *)aBook
{
	if (aBook && [self.books containsObject:aBook]) {
		[self.books removeObject:aBook];
	}
}

- (void)addNote:(ISOSingleNote *)aNote
{
	if (aNote && ![self.notes containsObject:aNote]) {
		[self.notes addObject:aNote];
	}
}

- (void)removeNote:(ISOSingleNote *)aNote
{
	if (aNote && [self.notes containsObject:aNote]) {
		[self.notes removeObject:aNote];
	}
}


@end
