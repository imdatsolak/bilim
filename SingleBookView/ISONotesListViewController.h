//
//  ISONotesListViewController.h
//  xBilim
//
//  Created by Imdat Solak on 11/5/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBook.h"
#import "ISOSingleNote.h"

@class ISONotesListViewController;
@class ISOBookViewController;

@interface NLVPopoverController : NSViewController

@property IBOutlet NSTableView	*notesTableView;
@property IBOutlet NSSegmentedControl *notesViewSelector;

@end

@interface ISONotesListViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
{
	ISOBookViewController *owner;
	ISOSingleNote *selectedNote;
	NSInteger currentChapterNumber;
	NSMutableArray	*chapterNotes;
	NSArray			*allNotes;
}
@property IBOutlet NLVPopoverController *popoverController;
@property IBOutlet NSWindow *detachedWindow;
@property NSPopover *myPopover;

- (void)displayNotesOfBook:(ISOBook *)theBook relativeToRect:(NSRect)boundingRect inView:(NSView *)selectedView withCurrentChapter:(NSInteger)chapterNo;
- (ISOSingleNote *)selectedNote;
- (void)setSelectedNote:(ISOSingleNote *)aNote;
- (void)noteSelectionChanged;
- (void)setOwner:(ISOBookViewController *)anOwner;

@end
