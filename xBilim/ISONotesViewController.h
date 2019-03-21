//
//  ISONotesViewController.h
//  xBilim
//
//  Created by Imdat Solak on 11/4/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBook.h"
#import "ISOSingleNote.h"
#import "ISOSingleNoteEditController.h"
#import "ISOHeaders.h"

@class ISOBookViewController;
@class ISONotesViewController;
@interface ISONotesView : NSView <ISONoteOwnerProtocol>
{
	NSMutableArray *notesData;
	id owner;
	ISOSingleNoteEditController *noteEditController;
	BOOL displayCitation;
}

- (IBAction)deleteNoteButtonClicked:(id)sender;
- (IBAction)editNoteButtonClicked:(id)sender;
- (void)removeAllNotesFromArray;
- (void)addNote:(ISOSingleNote *)aNote atRect:(NSRect )notesRect;
- (void)setOwner:(id)anOwner;

@end

@interface ISONotesViewController : NSViewController <ISONoteOwnerProtocol>
{
	ISOBook		*theBook;
	NSInteger	currentChapterNo;
	NSInteger	currentPageNumber;
	id			owner;
	NSArray		*currentChapterNotes;
	BOOL		hideNotes;
}

- (void)setOwner:(id)anOwner;
- (id)owner;
- (void)setBook:(ISOBook*)aBook;
- (ISOBook *)book;
- (void)setCurrentChapterNo:(NSInteger)aNo;
- (void)setCurrentPage:(NSInteger)aPage;
- (void)deleteNote:(ISOSingleNote *)aNote;
- (void)noteChanged:(ISOSingleNote *)aNote;
- (void)reflectChangesInNotesDisplay;
- (void)hideNotes;
- (void)setHideNotes:(BOOL)flag;
- (BOOL)isHideNotes;
@end
