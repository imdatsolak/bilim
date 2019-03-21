//
//  ISOChapterListViewController.m
//  xBilim
//
//  Created by Imdat Solak on 11/5/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOChapterListViewController.h"

@implementation CLVPopoverController



@end
@interface ISOChapterListViewController ()

@end

@implementation ISOChapterListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		if (self) {
			self.popoverController = [[CLVPopoverController alloc] initWithNibName:@"CLVPopover" bundle:[NSBundle mainBundle]];
			return self;
		}
    }
    return self;
}

- (void)displayChaptersOfBook:(ISOBook *)aBook relativeToRect:(NSRect)boundingRect inView:(NSView *)selectedView
{
	theBook = aBook;
	[self createPopover];
    [self.myPopover showRelativeToRect:boundingRect ofView:selectedView preferredEdge:NSMinXEdge];
	[self.popoverController.chapterTableView setDelegate:self];
	[self.popoverController.chapterTableView setDataSource:self];
	[self.popoverController.chapterTableView setTarget:self];
	[self.popoverController.chapterTableView setDoubleAction:@selector(tableViewDoubleClicked:)];
	[self.popoverController.chapterTableView reloadData];
}

- (NSInteger )selectedChapterNumber
{
	return selectedChapter;
}

- (void)setSelectedChapter:(NSInteger)aChapterNumber
{
	selectedChapter = aChapterNumber;
}

- (void)chapterSelectionChanged
{
	[self.myPopover close];
	[owner chapterSelectionChangedToChapter:selectedChapter];
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


/* *************************************************************************
 * TABLE VIEW Delegate
 * *************************************************************************
 */
- (IBAction)tableViewDoubleClicked:(id)sender;
{
	NSInteger selectedRow = [self.popoverController.chapterTableView selectedRow];
	if (selectedRow>=0) {
		[self setSelectedChapter:selectedRow];
		[self chapterSelectionChanged];
	}
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return theBook.numberOfChapters;
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
	NSTableCellView	*cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    NSDictionary	*chapter = [theBook chapterWithIndex:rowIndex];
	NSString		*value = [[chapter allValues] objectAtIndex:0];
	NSInteger		indentLocation = [value rangeOfString:@"\t"].location;
	
	if (indentLocation != NSNotFound) {
		NSString *level = [value substringToIndex:indentLocation];
		NSInteger iLevel = [level integerValue];
		value = [value substringFromIndex:indentLocation+iLevel];
		value = [NSString stringWithFormat:@"%@%@", [@"                              " substringToIndex:iLevel*3], value];
	}
	[cellView.textField setStringValue:value];
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

@end
