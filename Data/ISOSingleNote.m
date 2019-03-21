//
//  ISOSingleNote.m
//  xBilim
//
//  Created by Imdat Solak on 10/18/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOSingleNote.h"

@implementation ISOSingleNote

#define kNoteText				@"NoteText"
#define kNoteDate				@"NoteDate"
#define kNoteLocationLocation	@"NoteLocationLocation"
#define kNoteLocationLength		@"NoteLocationLength"
#define kNoteCitation			@"NoteCitation"
#define kNoteChapterNumber		@"NoteChapterNumber"
#define kNoteChapterTitle		@"NoteChapterTitle"
#define kNoteTagID				@"NoteTagID"
#define kNoteMarkerOnly			@"NoteMarkerOnly"
#define kNoteBookProjects		@"NoteBookProjects"
#define kPageNumber				@"NotePageNumber"
#define kPaperBookNote			@"NotePaperBookNote"

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.noteText forKey:kNoteText];
	[encoder encodeObject:self.noteDate	forKey:kNoteDate];
	[encoder encodeInteger:self.noteLocation.location forKey:kNoteLocationLocation];
	[encoder encodeInteger:self.noteLocation.length forKey:kNoteLocationLength];
	[encoder encodeObject:self.citation forKey:kNoteCitation];
	[encoder encodeInteger:self.chapterNumber forKey:kNoteChapterNumber];
	[encoder encodeObject:self.chapterTitle forKey:kNoteChapterTitle];
	[encoder encodeInteger:self.tagID forKey:kNoteTagID];
	[encoder encodeBool:self.markerOnly forKey:kNoteMarkerOnly];
	[encoder encodeObject:self.projects forKey:kNoteBookProjects];
	[encoder encodeInteger:self.pageNumber forKey:kPageNumber];
	[encoder encodeBool:self.paperBookNote forKey:kPaperBookNote];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if (self) {
		NSInteger length, location;
		self.noteText = [decoder decodeObjectForKey:kNoteText];
		self.noteDate = [decoder decodeObjectForKey:kNoteDate];
		location = [decoder decodeIntegerForKey:kNoteLocationLocation];
		length = [decoder decodeIntegerForKey:kNoteLocationLength];
		self.noteLocation = NSMakeRange(location, length);
		self.citation = [decoder decodeObjectForKey:kNoteCitation];
		self.chapterNumber = [decoder decodeIntegerForKey:kNoteChapterNumber];
		self.chapterTitle = [decoder decodeObjectForKey:kNoteChapterTitle];
		self.tagID = [decoder decodeIntegerForKey:kNoteTagID];
		self.markerOnly = [decoder decodeBoolForKey:kNoteMarkerOnly];
		self.projects = [decoder decodeObjectForKey:kNoteBookProjects];
		self.pageNumber = [decoder decodeIntegerForKey:kPageNumber];
		self.paperBookNote = [decoder decodeBoolForKey:kPaperBookNote];
		if (self.projects == nil) {
			self.projects = [[NSMutableArray alloc] init];
		}

		return self;
	}
	return nil;
}
- (id)initWithNoteText:(NSString *)aNote citation:(NSString *)aCitation
		  location:(NSRange)aRange inChapterNo:(NSInteger)chapterNo withChapterTitle:(NSString *)aTitle
{
	self = [super init];
	if (self) {
		self.noteText = aNote;
		self.noteDate = [NSDate date];
		self.noteLocation = aRange;
		self.citation = aCitation;
		self.chapterNumber = chapterNo;
		self.chapterTitle = aTitle;
		self.tagID = ISONoTag;
		self.markerOnly = NO;
		self.pageNumber = -1;
		self.paperBookNote = NO;
		self.projects = [[NSMutableArray alloc] init];
		return self;
	}
	return nil;
}


- (NSColor *)noteTagAsColor
{
	switch (self.tagID) {
		case ISORedTag:
			return [NSColor redColor];
		case ISOGreenTag:
			return [NSColor greenColor];
		case ISOBlueTag:
			return [NSColor blueColor];
		case ISOPinkTag:
			return [NSColor colorWithCalibratedRed:1.0 green:0.0 blue:1.0 alpha:1.0];
		case ISOTurquiseTag:
			return [NSColor colorWithCalibratedRed:0.0 green:1.0 blue:1.0 alpha:1.0];
		case ISOBrownTag:
			return [NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.0 alpha:1.0];
		case ISONavyGreenTag:
			return [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:0.0 alpha:1.0];
		case ISOYellowTag:
			return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.0 alpha:1.0];
		case ISONoTag:
		default:
			return nil;

	}
}

- (NSInteger)_indexOfProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo
{
	int i;
	NSInteger index = NSNotFound;
	
	for (i=0;i<[self.projects count] && index == NSNotFound;i++) {
		NSArray *anArray = [self.projects objectAtIndex:i];
		if (([anArray objectAtIndex:0] == aProject) && ([[anArray objectAtIndex:1] integerValue] == chapterNo)) {
			index = i;
		}
	}
	return index;
}

- (NSArray *)projectInfoArrayOfProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo
{
	NSInteger index = [self _indexOfProject:aProject withProjectChapterNumber:chapterNo];
	if (index != NSNotFound) {
		return [self.projects objectAtIndex:index];
	} else {
		return nil;
	}
}

- (BOOL)hasProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo
{
	NSArray *projectInfoArray = [self projectInfoArrayOfProject:aProject withProjectChapterNumber:chapterNo];
	if (projectInfoArray) {
		return YES;
	}
	return NO;
}

- (void)addProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo
{
	if ([self _indexOfProject:aProject withProjectChapterNumber:chapterNo] == NSNotFound) {
		NSArray *anArray = [[NSArray alloc] initWithObjects:aProject, [NSNumber numberWithInteger:chapterNo], nil];
		[self.projects addObject:anArray];
	}
}

- (void)removeProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo
{
	NSInteger index = [self _indexOfProject:aProject withProjectChapterNumber:(NSInteger)chapterNo];
	if (index != NSNotFound) {
		[self removeProjectAtIndex:index];
	}
}

- (void)removeProjectAtIndex:(NSInteger)anIndex
{
	if (anIndex < [self.projects count]) {
		[self.projects removeObjectAtIndex:anIndex];
	}
}


@end
