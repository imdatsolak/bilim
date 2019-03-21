//
//  ISOProjectNotesViewController.m
//  xBilim
//
//  Created by Imdat Solak on 11/6/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOProjectNotesViewController.h"
#import "ISOSingleNoteView.h"
#import "ISOBook.h"
#import "ISOSingleNoteRowView.h"

@interface ISOProjectNotesViewController ()

@end

@implementation ISOProjectNotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		projectChapterNumber = NSIntegerMax;
		showingAllNotesOfChapter = NO;
		showingAllNotesOfProject = NO;
    }
    return self;
}

- (void)displayBookNotes:(ISOBook *)aBook forProject:(ISOProject *)aProject andChapterNumber:(NSInteger)aNumber
{
	project = aProject;
	projectChapterNumber = aNumber;
	book = aBook;
	projectChapterNotesArray = nil;
	if (project) {
		if (book) { // Show only notes of a single book
			if (projectChapterNumber != NSIntegerMax) { // ... which is usually in a chapter (NSIntegerMax would be an error here)
				projectChapterNotesArray = [book notesForProject:project andProjectChapter:projectChapterNumber];
			}
		} else if (projectChapterNumber != NSIntegerMax) { // ... or show all notes of a single chapter
			projectChapterNotesArray = nil; // Not yet supported
			showingAllNotesOfChapter = YES;
		} else { // or show ALL NOTES of ALL Project Chapters...
			projectChapterNotesArray = nil; // Not yet supported
			showingAllNotesOfProject = YES;
		}
	} else {
		projectChapterNotesArray = nil;
	}
	[self.tableBottomView setBackgroundColor:[NSColor colorWithRed:1.0/255.0*215.0 green:1.0/255.0*221.0 blue:1.0/255.0*229.0 alpha:1.0]];
	[self.notesTableView setDelegate:self];
	[self.notesTableView setDataSource:self];
	[self.notesTableView setHeaderView:self.tableHeaderView];
	[self.notesTableView reloadData];
}

- (IBAction)toggleShowCitations:(id)sender
{
	[self.notesTableView reloadData];
}

// ISONoteOwnerProtocol methods

- (void)deleteNoteButtonClicked:(id)sender
{
	
}
- (void)editNoteButtonClicked:(id)sender
{
	
}

/* *********************************************************
 * TableView and other works...
 * *********************************************************
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [projectChapterNotesArray count];
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(NSTableCellView *)rowView forRow:(NSInteger)rowIndex
{
}


- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)rowIndex
{
	NSTableRowView *result = [[ISOSingleNoteRowView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
	return result;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
	return NO;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	ISOSingleNoteView	*cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    ISOSingleNote		*aNote;
	
	aNote = [projectChapterNotesArray objectAtIndex:rowIndex];
	[cellView setOwner:self];        // this triggers the -deleteNoteButtonClicked: & -editNoteButtonClicked: method calles
	[cellView setDisplayCitation:[self.showCitationsSwitch state]];
	[cellView setShowNoteChapter:YES];
	[cellView setShowNoteLocation:YES];
	[cellView setNote:aNote];
	
	return cellView;
}

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
@end
