//
//  ISONotesViewController.m
//  xBilim
//
//  Created by Imdat Solak on 11/4/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISONotesViewController.h"
#import "ISOColoredView.h"
#import "ISOBookViewController.h"
#import "ISOSingleNoteView.h"

@implementation ISONotesView

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	if (self) {
		notesData = [[NSMutableArray alloc] init];
		displayCitation = NO;
		return self;
	}
	return nil;
}

- (void)setDisplayCitation:(BOOL)flag
{
	displayCitation = flag;
}

- (BOOL)isDisplayCitation
{
	return displayCitation;
}

- (void)removeAllNotesFromArray
{
	int i;
	
	for (i=0; i<[notesData count]; i++) {
		[[[notesData objectAtIndex:i] objectAtIndex:2] removeFromSuperview];
		[[[notesData objectAtIndex:i] objectAtIndex:3] removeFromSuperview];
		[[[notesData objectAtIndex:i] objectAtIndex:4] removeFromSuperview];
	}
	[notesData removeAllObjects];
}

- (IBAction)deleteNoteButtonClicked:(id)sender
{
	if (owner && [owner respondsToSelector:@selector(deleteNoteButtonClicked:)]) {
		[owner deleteNoteButtonClicked:sender];
	}
}

- (IBAction)editNoteButtonClicked:(id)sender
{
	if (owner && [owner respondsToSelector:@selector(editNoteButtonClicked:)]) {
		[owner editNoteButtonClicked:sender];
	}
}

- (IBAction)deleteNote:(id)sender
{
	NSInteger noteIndex = [sender tag];
	if (noteIndex < [notesData count]) {
		if (NSRunAlertPanel(NSLocalizedString(@"Delete Note", @"Delete Note Title"),
						NSLocalizedString(@"Do you really want to delete the note? You can't undo this operation...", @"Question to ask"), NSLocalizedString(@"Cancel", @"Cancel Button Title"),
						NSLocalizedString(@"Delete", @"Delete Button Title"), nil) == NSAlertAlternateReturn) {
			NSArray *anEntry = [notesData objectAtIndex:noteIndex];
			[owner deleteNote:[anEntry objectAtIndex:0]];
		}
	}
}

- (void)noteChanged:(id)aNote
{
	[owner noteChanged:(ISOSingleNote *)aNote];
}

- (IBAction)editNote:(id)sender
{
	NSRect aRect = [sender bounds];
	
	if (noteEditController == nil) {
		noteEditController = [[ISOSingleNoteEditController alloc] initWithNibName:@"ISOSingleNoteEditController" bundle:[NSBundle mainBundle]];
	}
	[noteEditController setNote:[[notesData objectAtIndex:[sender tag]] objectAtIndex:0] inBook:[owner book]];
	[noteEditController editNoteRelativeToRect:aRect inView:sender notifyOnOK:self withSelector:@selector(noteChanged:)];
}

- (void)addNote:(ISOSingleNote *)aNote atRect:(NSRect )notesRect
{
	ISOSingleNoteView *singleNoteView = [[ISOSingleNoteView alloc] initWithFrame:NSMakeRect(0, 0, 10, 10)];
	NSButton *deleteNoteButton	= [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
	NSButton *editNoteButton	= [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
	NSArray *anArray = [NSArray arrayWithObjects:aNote,
						[NSValue valueWithRect:notesRect],
						singleNoteView,
						deleteNoteButton,
						editNoteButton,
						nil];
	
	[editNoteButton setTarget:self];
	[editNoteButton setAction:@selector(editNote:)];
	[editNoteButton setTag:[notesData count]];
	[editNoteButton setButtonType:NSMomentaryPushInButton];
	[editNoteButton setBordered:YES];
	[editNoteButton setBezelStyle:NSRoundRectBezelStyle];
	[editNoteButton setImage:[NSImage imageNamed:@"edit"]];
	[editNoteButton setImagePosition:NSImageOnly];
	
	[deleteNoteButton setTarget:self];
	[deleteNoteButton setAction:@selector(deleteNote:)];
	[deleteNoteButton setTag:[notesData count]];
	[deleteNoteButton setButtonType:NSMomentaryPushInButton];
	[deleteNoteButton setBordered:YES];
	[deleteNoteButton setBezelStyle:NSRoundRectBezelStyle];
	[deleteNoteButton setImage:[NSImage imageNamed:NSImageNameStopProgressTemplate]];
	[deleteNoteButton setImagePosition:NSImageOnly];
	
	[singleNoteView setNote:aNote];
	[singleNoteView setOwner:self];
	
	[notesData addObject:anArray];
}

/*
 NSRoundedBezelStyle           = 1,
 NSRegularSquareBezelStyle     = 2,
 NSThickSquareBezelStyle       = 3,
 NSThickerSquareBezelStyle     = 4,
 NSDisclosureBezelStyle        = 5,
 NSShadowlessSquareBezelStyle  = 6,
 NSCircularBezelStyle          = 7,
 NSTexturedSquareBezelStyle    = 8,
 NSHelpButtonBezelStyle        = 9,
 NSSmallSquareBezelStyle       = 10,
 NSTexturedRoundedBezelStyle   = 11,
 NSRoundRectBezelStyle         = 12,
 NSRecessedBezelStyle          = 13,
 NSRoundedDisclosureBezelStyle = 14,
 */

- (void)drawRect:(NSRect)dirtyRect
{
	int i;
	[super drawRect:dirtyRect];

	[[NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1] set];
	NSRectFill(dirtyRect);
	
	for (i=0;i<[notesData count];i++) {
		NSArray *noteEntry = [notesData objectAtIndex:i];
		NSRect noteRect = [[noteEntry objectAtIndex:1] rectValue];
		ISOSingleNoteView *singleNoteView = [noteEntry objectAtIndex:2];
		NSButton *deleteNoteButton = [noteEntry objectAtIndex:3];
		NSButton *editNoteButton = [noteEntry objectAtIndex:4];
		NSRect aRect;
		
		[singleNoteView setFrame:noteRect];
		if ([singleNoteView superview] != self) {
			[self addSubview:singleNoteView];
		}
		
		aRect = [editNoteButton frame];
		aRect.origin.x = noteRect.size.width + noteRect.origin.x - aRect.size.width - 4;
		aRect.origin.y = noteRect.origin.y + noteRect.size.height - aRect.size.height - 1;
		[editNoteButton setFrame:aRect];
		if ([editNoteButton superview] != self) {
			[self addSubview:editNoteButton];
		}
		aRect = [deleteNoteButton frame];
		aRect.origin.x = noteRect.size.width + noteRect.origin.x - aRect.size.width*2 - 4*2;
		aRect.origin.y = noteRect.origin.y + noteRect.size.height - aRect.size.height - 1;
		[deleteNoteButton setFrame:aRect];
		if ([deleteNoteButton superview] != self) {
			[self addSubview:deleteNoteButton];
		}
		[singleNoteView display];
		[deleteNoteButton display];
		[editNoteButton display];
	}
}

- (void)setOwner:(id)anOwner
{
	owner = anOwner;
}

- (id)owner
{
	return owner;
}
@end

@interface ISONotesViewController ()

@end

@implementation ISONotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		theBook = nil;
		currentChapterNo = -1;
		currentPageNumber = -1;
		owner = nil;
		[(ISONotesView *)self.view setOwner:self];
    }
    return self;
}

- (void)setOwner:(ISOBookViewController *)anOwner
{
	owner = anOwner;
}

- (id)owner
{
	return owner;
}

- (void)setBook:(ISOBook *)aBook
{
	theBook = aBook;
}

- (ISOBook *)book
{
	return theBook;
}

- (void)setCurrentChapterNo:(NSInteger)aNo
{
	currentChapterNo = aNo;
}

- (void)setCurrentPage:(NSInteger)aPage
{
	currentPageNumber = aPage;
}

- (void)reflectChangesInNotesDisplay
{
	if (owner && theBook && (currentPageNumber >= 0) && !hideNotes) {
		NSLayoutManager *layoutMgr = [owner layoutManager];
		NSArray *textContainers = [layoutMgr textContainers];
		if (textContainers && ([textContainers count] > currentPageNumber)) {
			NSTextContainer	*textContainer = [textContainers objectAtIndex:currentPageNumber];
			int i;
			
			currentChapterNotes = [theBook notesForChapterNumber:currentChapterNo];
			[(ISONotesView *)self.view setOwner:self];
			[(ISONotesView *)self.view removeAllNotesFromArray];
			if (currentChapterNotes) {
				if (textContainer) {
					for (i=0;i<[currentChapterNotes count];i++) {
						ISOSingleNote *aNote = [currentChapterNotes objectAtIndex:i];
						NSRange noteRange = [aNote noteLocation];
						NSRange glyphRange = [layoutMgr glyphRangeForCharacterRange:noteRange actualCharacterRange:nil];
						NSRect boundingRect = [layoutMgr boundingRectForGlyphRange:(NSRange)glyphRange inTextContainer:textContainer];
						
						if (boundingRect.size.width > 10 && boundingRect.size.height > 1.0) {
							NSRect frameRect = [self.view convertRect:boundingRect fromView:[textContainer textView]];
							NSRect aRect = NSMakeRect(0, frameRect.origin.y, [self.view frame].size.width, boundingRect.size.height);

							[(ISONotesView *)self.view addNote:aNote atRect:aRect];
						}
					}
				} else {
					[(ISONotesView *)self.view removeAllNotesFromArray];
					[self.view display];
				}
			}
		}
		[self.view display];
	} else {
		[(ISONotesView *)self.view removeAllNotesFromArray];
		[self.view display];
	}
}

- (void)hideNotes
{
	hideNotes = YES;
	[(ISONotesView *)self.view removeAllNotesFromArray];
	[self.view display];
}

- (void)setHideNotes:(BOOL)flag
{
	hideNotes = flag;
}

- (BOOL)isHideNotes
{
	return hideNotes;
}

- (IBAction)deleteNoteButtonClicked:(id)sender
{
	if (owner && [owner respondsToSelector:@selector(deleteNoteButtonClicked:)]) {
		[owner deleteNoteButtonClicked:sender];
	}
}

- (IBAction)editNoteButtonClicked:(id)sender
{
	if (owner && [owner respondsToSelector:@selector(editNoteButtonClicked:)]) {
		[owner editNoteButtonClicked:sender];
	}
}


- (void)deleteNote:(ISOSingleNote *)aNote
{
	[theBook removeNote:aNote];
	[owner noteRemoved:aNote];
}

- (void)noteChanged:(ISOSingleNote *)aNote
{
	[owner noteChanged:aNote];
}
@end
