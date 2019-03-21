//
//  ISOSingleNote.h
//  xBilim
//
//  Created by Imdat Solak on 10/18/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOProject.h"

#define ISONoTag		-1
#define ISORedTag		0
#define ISOPinkTag		1
#define ISOTurquiseTag	2
#define ISOBlueTag		3
#define ISOBrownTag		4
#define ISOGreenTag		5
#define ISONavyGreenTag	6
#define ISOYellowTag	7

@class ISOProject;

@interface ISOSingleNote : NSObject <NSCoding>
{
}

@property	NSString	*noteText;
@property	NSString	*citation;
@property	NSRange		noteLocation;
@property	NSDate		*noteDate;
@property	NSInteger	chapterNumber;
@property	NSString	*chapterTitle;
@property	NSInteger	pageNumber;
@property	NSInteger	tagID;
@property	BOOL		markerOnly;
@property	NSMutableArray		*projects;
@property	BOOL		paperBookNote;


- (id)initWithNoteText:(NSString *)aNote citation:(NSString *)aCitation
			  location:(NSRange)aRange inChapterNo:(NSInteger)chapterNo withChapterTitle:(NSString *)aTitle;

- (NSColor *)noteTagAsColor;
- (NSInteger)_indexOfProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo;
- (NSArray *)projectInfoArrayOfProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo;
- (BOOL)hasProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo;
- (void)addProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo;
- (void)removeProject:(ISOProject *)aProject withProjectChapterNumber:(NSInteger)chapterNo;
- (void)removeProjectAtIndex:(NSInteger)anIndex;

@end
