//
//  ISONotesListViewController.m
//  xBilim
//
//  Created by Imdat Solak on 11/5/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISONotesListViewController.h"
#import "ISOBookViewController.h"

#define kCURRENTCHAPTERONLY 1

@implementation NLVPopoverController


@end

@interface ISONotesListViewController ()

@end

@implementation ISONotesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		if (self) {
			self.popoverController = [[NLVPopoverController alloc] initWithNibName:@"NLVPopover" bundle:[NSBundle mainBundle]];
			return self;
		}
    }
    return self;
}

- (void)displayNotesOfBook:(ISOBook *)theBook relativeToRect:(NSRect)boundingRect inView:(NSView *)selectedView withCurrentChapter:(NSInteger)chapterNo
{
	int i;
	
	currentChapterNumber = chapterNo;
	chapterNotes = [[NSMutableArray alloc] init];
	allNotes = [theBook bookNotes];
	for (i=0;i<[allNotes count]; i++) {
		ISOSingleNote *aNote = [allNotes objectAtIndex:i];
		if ([aNote chapterNumber] == currentChapterNumber) {
			[chapterNotes addObject:aNote];
		}
	}
	[self createPopover];
    [self.myPopover showRelativeToRect:boundingRect ofView:selectedView preferredEdge:NSMinXEdge];
	[self.popoverController.notesTableView setDataSource:self];
	[self.popoverController.notesTableView setDelegate:self];
	[self.popoverController.notesTableView setTarget:self];
	[self.popoverController.notesTableView setDoubleAction:@selector(tableViewDoubleClicked:)];
	[self.popoverController.notesViewSelector setTarget:self];
	[self.popoverController.notesViewSelector setAction:@selector(notesViewSelectorClicked:)];
	
	[self.popoverController.notesTableView reloadData];
}


- (ISOSingleNote *)selectedNote
{
	return selectedNote;
}

- (void)setSelectedNote:(ISOSingleNote *)aNote
{
	selectedNote = aNote;
}

- (void)noteSelectionChanged
{
	[self.myPopover close];
	[owner noteSelectionChangedToNote:selectedNote];
}

- (void)setOwner:(ISOBookViewController *)anOwner
{
	owner = anOwner;
}
- (void)createPopover
{
    if (self.myPopover == nil)
    {
        self.myPopover = [[NSPopover alloc] init];
		self.myPopover.contentViewController = self.popoverController;
		// self.myPopover.appearance = [popoverType selectedRow];
        
        // self.myPopover.animates = [animatesCheckbox state];
        
        // AppKit will close the popover when the user interacts with a user interface element outside the popover.
        // note that interacting with menus or panels that become key only when needed will not cause a transient popover to close.
        self.myPopover.behavior = NSPopoverBehaviorTransient;
        
        // so we can be notified when the popover appears or closes
    }
}

/* **************************************************************************
 * NSPopoverDelegate Methods
 * **************************************************************************
 */
// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverWillShowNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (void)popoverWillShow:(NSNotification *)notification
{
}

// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverDidShowNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (void)popoverDidShow:(NSNotification *)notification
{
    // add new code here after the popover has been shown
}

// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverWillCloseNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (BOOL)popoverShouldClose:(NSPopover *)popover
{
	return YES;
}

- (void)popoverWillClose:(NSNotification *)notification
{
    NSString *closeReason = [[notification userInfo] valueForKey:NSPopoverCloseReasonKey];
    if (closeReason)
    {
        // closeReason can be:
        //      NSPopoverCloseReasonStandard
        //      NSPopoverCloseReasonDetachToWindow
        //
        // add new code here if you want to respond "before" the popover closes
        //
    }
}

// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverDidCloseNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (void)popoverDidClose:(NSNotification *)notification
{
    NSString *closeReason = [[notification userInfo] valueForKey:NSPopoverCloseReasonKey];
    if (closeReason)
    {
        // closeReason can be:
        //      NSPopoverCloseReasonStandard
        //      NSPopoverCloseReasonDetachToWindow
        //
        // add new code here if you want to respond "after" the popover closes
        //
    }
    
    self.myPopover = nil;
}

// -------------------------------------------------------------------------------
// Invoked on the delegate asked for the detachable window for the popover.
// -------------------------------------------------------------------------------
- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover
{
	return self.detachedWindow;
}
/* *********************************************************
 * TableView and other works...
 * *********************************************************
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	if ([self.popoverController.notesViewSelector selectedSegment] == kCURRENTCHAPTERONLY) {
		return [chapterNotes count];
	} else {
		return [allNotes count];
	}
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(NSTableCellView *)rowView forRow:(NSInteger)rowIndex
{
}


- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)rowIndex
{
	NSTableRowView *result = [[NSTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
	return result;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
	return NO;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	NSArray *notesArray;
	NSTableCellView	*cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    ISOSingleNote	*aNote;
	NSString		*noteDisplayText;
	
	if ([self.popoverController.notesViewSelector selectedSegment] == kCURRENTCHAPTERONLY) {
		notesArray = chapterNotes;
	} else {
		notesArray = allNotes;
	}
	aNote = [notesArray objectAtIndex:rowIndex];
	
	noteDisplayText = [NSString stringWithFormat:@"(%lu-%lu) \"...%@\"",
					   [aNote noteLocation].location,
					   [aNote noteLocation].length+[aNote noteLocation].location,
					   [aNote noteText]];
	[cellView.textField setStringValue:noteDisplayText];
	return cellView;
}

// We make the "group rows" have the standard height, while all other image rows have a larger height
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return [tableView rowHeight];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	
}

- (IBAction)tableViewDoubleClicked:(id)sender
{
	
}

- (IBAction)notesViewSelectorClicked:(id)sender
{
	[self.popoverController.notesTableView reloadData];
}
@end
