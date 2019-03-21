//
//  ISOLibraryViewController.m
//  xBilim
//
//  Created by Imdat Solak on 10/24/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOLibraryViewController.h"
#import "ISOLibraryListViewRow.h"
#import "ISOLibraryListViewCV.h"
#import "ISOColoredView.h"
#import "ISOBookCoverView.h"
#import "ISOMainWindowController.h"
#import "ISOHeaders.h"

#define kLIBRARY_ICONVIEWMODE	1
#define kLIBRARY_LISTVIEWMODE	2

#define kLIBRARY_SORTBY_TITLE	1
#define kLIBRARY_SORTBY_AUTHOR	2
#define kLIBRARY_SORTBY_LAST	3



@implementation ISOLibraryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		selectedViewMode = kLIBRARY_ICONVIEWMODE;
		selectedSortOrder = kLIBRARY_SORTBY_AUTHOR;
		return self;
	}
	return nil;
}

- (void)setLibrary:(ISOLibrary *)aLibrary
{
	library = aLibrary;
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	
	for (ISOBook *aBook in self.library.books) {
		[tempArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							  [aBook bookTitle], kBVTitle,
							  [aBook bookAuthor], kBVAuthor,
							  [[NSImage alloc] initByReferencingFile:[aBook bookCover]], kBVCover,
							  aBook, kBVTheBook,
							  nil]
		 ];
	}
	[self setBvBooks:tempArray];
	[self.messageField setStringValue:[NSString stringWithFormat:@"%lu Books", (unsigned long)[self.bvBooks count]]];
	[self sortBooksBy:kLIBRARY_SORTBY_AUTHOR];
//	myToolbar = [[NSToolbar alloc] initWithIdentifier:kTBLVToolbarID];
	myToolbar = nil;
	[self.libraryTableView setTarget:self];
	[self.libraryTableView setAction:@selector(libraryTableViewClicked:)];
	[self.libraryTableView setDoubleAction:@selector(libraryTableViewDoubleClicked:)];
	[self.bookCoverView setValue:nil forKey:@"value"];
	[self.bookTitleField setStringValue:@""];
	[self.bookAuthorField setStringValue:@""];
	[self.bookPubYearField setStringValue:@""];
	[self.bookPublisherField setStringValue:@""];
	[self.bookNumChaptersField setStringValue:@""];
	[self.bookLastChapterReadField setStringValue:@""];
	[self.bookProjectsField setBezeled:YES];
	[self.bookProjectsField setBezelStyle:NSTextFieldRoundedBezel];
	[(ISOColoredView *)self.listView setBackgroundColor:[NSColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.97]];
}

- (ISOLibrary *)library
{
	return library;
}

- (void)addBooks:(NSArray *)bookURLs
{
	NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self bvBooks]];
	
	if ([bookURLs count] > 5) {
		[self.bookAddProgressPanel makeKeyAndOrderFront:self];
	}
	[self.bookAddProgressIndicator setMaxValue:[bookURLs count]];
	[self.bookAddProgressIndicator setDoubleValue:0.0];
	[self.bookAddProgressIndicator display];
	for (NSURL *aUrl in bookURLs) {
		if (![library bookWithPathExists:[aUrl path]]) {
			ISOBook *addedBook = [library addBookFromPath: [aUrl path]];
			NSImage *coverImage = [[NSImage alloc] initByReferencingFile:[addedBook bookCover]];
			
			if (!coverImage) {
				coverImage = [[NSImage alloc] initWithSize:NSMakeSize(2, 2)];
			}
			[self.bookAddTitleField setStringValue:[addedBook bookTitle]];
			[self.bookAddTitleField display];
			[tempArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
								  [addedBook bookTitle], kBVTitle,
								  [addedBook bookAuthor], kBVAuthor,
								  coverImage, kBVCover,
								  addedBook, kBVTheBook,
								  nil]];
		}
		[self.bookAddProgressIndicator incrementBy:1.0];
	}
	[self setBvBooks:tempArray];
	[self.messageField setStringValue:[NSString stringWithFormat:@"%lu Books", (unsigned long)[self.bvBooks count]]];
	if ([bookURLs count] > 5) {
		[self.bookAddProgressPanel orderOut:self];
	}
	[self reSortLibrary];
	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
}


- (IBAction)addEBook:(id)sender
{
//    NSString *extensions = @"epub/ePub/EPUB/pdf/PDF";
    NSString *extensions = @"epub/ePub/EPUB";
    NSArray *types = [extensions pathComponents];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
    [openPanel setAllowedFileTypes:types];
    [openPanel setCanSelectHiddenExtension:YES];
	[openPanel setAllowsMultipleSelection:YES];
    [openPanel beginSheetModalForWindow:[self.view window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
			NSArray *urls = [openPanel URLs];
			[self performSelector:@selector(addBooks:) withObject:urls afterDelay:1.0];
        }
    }];
}

- (IBAction)addPaperBook:(id)sender
{
	if (paperBookController == nil) {
		paperBookController = [[ISOPaperBookController alloc] init];
	}
	[paperBookController addPaperBookWithWindow:[self.view window] andMasterViewController:self];
}

- (IBAction)removeBookFromLibrary:(id)sender
{
	NSAlert *anAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"Remove Book", @"Title of Alert Panel when removing Book")
									   defaultButton:NSLocalizedString(@"Cancel", @"Title of the Cancel Button")
									 alternateButton:NSLocalizedString(@"Remove", @"Title of the Remove Button")
										 otherButton:nil
						   informativeTextWithFormat:NSLocalizedString(@"Do you really want to remove the book from the library and all the projects it is used in?", @"AlertPanel Title When Removing a Book")];
	if ([anAlert runModal] == NSAlertAlternateReturn) {
		ISOBook *aBook = [self selectedBook];
		NSMutableArray	*tempArray = [NSMutableArray arrayWithArray:[self bvBooks]];
		int i;
		NSDictionary	*foundDict = nil;
		BOOL found = NO;
		for (i=0;i<[tempArray count] && !found; i++) {
			NSDictionary *aDict = [tempArray objectAtIndex:i];
			if ([aDict objectForKey:kBVTheBook] == aBook) {
				foundDict = aDict;
				found = YES;
			}
		}
		if (found) {
			[tempArray removeObject:foundDict];
		}
		NSLog(@"Removing Book: {%@}", [aBook description]);
		[self.library removeBook:aBook];
		[self setBvBooks:tempArray];
		[self reSortLibrary];
		[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
	}
}

- (IBAction)createNewProjectWithSelection:(id)sender
{
	NSArray *selectedBooks = [self selectedBooks];
	if ([selectedBooks count]) {
		[self.mainController switchToProjectsView:self];
		[self.mainController.projectViewController createNewProjectWithSelectedBooks:selectedBooks];
	} else {
		NSBeep();
	}
}

- (void)reSortLibrary
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
							  initWithKey:sortingOrder
							  ascending:YES
							  selector:@selector(caseInsensitiveCompare:)];
    [self.bookListController setSortDescriptors:[NSArray arrayWithObject:sort]];
	if (self.view == self.listView) {
		[self.libraryTableView reloadData];
	}
}

- (void)sortBooksBy:(NSUInteger)newSortOrder
{
	selectedSortOrder = newSortOrder;
	
	switch  (selectedSortOrder) {
		case kLIBRARY_SORTBY_TITLE:
			sortingOrder = kBVTitle;
			break;
		case kLIBRARY_SORTBY_AUTHOR:
			sortingOrder = kBVAuthor;
			break;
		case kLIBRARY_SORTBY_LAST:
			sortingOrder = kBVTitle;
			break;
		default:
			sortingOrder = kBVTitle;
	}
	[self reSortLibrary];
}


- (void)switchToListViewMode
{
	if (self.view == self.listView) {
		return;
	} else {
		NSWindow *theWindow = [self.view window];
		[self rememberViewSize];
		[self.view removeFromSuperview];
		self.view = self.listView;
		[self displayInWindow:theWindow];
		[self.libraryTableView reloadData];
	}
}

- (void)switchToIconViewMode
{
	if (self.view == self.iconView) {
		return;
	} else {
		NSWindow *theWindow = [self.view window];
		[self rememberViewSize];
		[self.view removeFromSuperview];
		self.view = self.iconView;
		[self displayInWindow:theWindow];
	}
	
}

- (void)changeViewMode:(NSUInteger)newViewMode
{
	selectedViewMode = newViewMode;
	
	switch (selectedViewMode) {
		case kLIBRARY_ICONVIEWMODE:
			[self switchToIconViewMode];
			break;
		case kLIBRARY_LISTVIEWMODE:
			[self switchToListViewMode];
			break;
		default:
			[self switchToIconViewMode];
			break;
	}

}

- (IBAction)viewLibraryAsIcon:(id)sender
{
	[self changeViewMode:kLIBRARY_ICONVIEWMODE];
}

- (IBAction)viewLibraryAsList:(id)sender
{
	[self changeViewMode:kLIBRARY_LISTVIEWMODE];
}

- (IBAction)sortLibraryByTitle:(id)sender
{
	[self sortBooksBy:kLIBRARY_SORTBY_TITLE];
}

- (IBAction)sortLibraryByAuthor:(id)sender
{
	[self sortBooksBy:kLIBRARY_SORTBY_AUTHOR];
}

- (IBAction)sortLibraryByLastRead:(id)sender
{
	[self sortBooksBy:kLIBRARY_SORTBY_LAST];
}


// User Interface Validation
- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
    SEL theAction = [anItem action];
	if (theAction == @selector(addEBook:)) {
		return YES;
	} else if (theAction == @selector(addPaperBook:)) {
		return YES;
	} else if (theAction == @selector(removeBookFromLibrary:)) {
		return [self isSingleBookSelected];
	} else if (theAction == @selector(createNewProjectWithSelection:)) {
		return [self areAnyBooksSelected];
	} else if (theAction == @selector(viewLibraryAsIcon:)) {
		if (selectedViewMode == kLIBRARY_ICONVIEWMODE) {
			[(NSMenuItem *)anItem setState:NSOnState];
			return NO;
		} else {
			[(NSMenuItem *)anItem setState:NSOffState];
			return YES;
		}
	} else if (theAction == @selector(viewLibraryAsList:)) {
		if (selectedViewMode == kLIBRARY_LISTVIEWMODE) {
			[(NSMenuItem *)anItem setState:NSOnState];
			return NO;
		} else {
			[(NSMenuItem *)anItem setState:NSOffState];
			return YES;
		}
	} else if (theAction == @selector(sortLibraryByAuthor:)) {
		if (selectedSortOrder == kLIBRARY_SORTBY_AUTHOR) {
			[(NSMenuItem *)anItem setState:NSOnState];
			return NO;
		} else {
			[(NSMenuItem *)anItem setState:NSOffState];
			return YES;
		}
	} else if (theAction == @selector(sortLibraryByTitle:)) {
		if (selectedSortOrder == kLIBRARY_SORTBY_TITLE) {
			[(NSMenuItem *)anItem setState:NSOnState];
			return NO;
		} else {
			[(NSMenuItem *)anItem setState:NSOffState];
			return YES;
		}
	} else if (theAction == @selector(sortLibraryByLastRead:)) {
		if (selectedSortOrder == kLIBRARY_SORTBY_LAST) {
			[(NSMenuItem *)anItem setState:NSOnState];
			return NO;
		} else {
			[(NSMenuItem *)anItem setState:NSOffState];
			return YES;
		}
	}
	return NO;
}

- (NSMutableDictionary *)selectedBookInTablevView
{
	NSMutableDictionary *displayedBook = nil;
	NSIndexSet			*selectionIndexes = [self.libraryTableView selectedRowIndexes];
	
	if (selectionIndexes && [selectionIndexes count]) {
		displayedBook = [[self.bookListController arrangedObjects] objectAtIndex:[selectionIndexes firstIndex]];
	}
	return displayedBook;
}

- (ISOBook *)selectedBook
{
	ISOBook *theBook = nil;
	
	if (self.view == self.iconView) {
		NSIndexSet *selectionIndexes = [self.libraryIconView selectionIndexes];
		if (selectionIndexes && [selectionIndexes count]) {
			NSDictionary *dictionary = [[self.libraryIconView content] objectAtIndex:[selectionIndexes firstIndex]];
			theBook = [dictionary objectForKey:kBVTheBook];
		}
	} else {
		NSDictionary *aDict = [self selectedBookInTablevView];
		if (aDict) {
			theBook = [aDict objectForKey:kBVTheBook];
		}
	}
	return theBook;
}

- (BOOL)isSingleBookSelected
{
	NSIndexSet *selectionIndexes;
	if (self.view == self.iconView) {
		selectionIndexes = [self.libraryIconView selectionIndexes];
	} else {
		selectionIndexes = [self.libraryTableView selectedRowIndexes];
	}
	if (selectionIndexes && [selectionIndexes count] == 1) {
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)areAnyBooksSelected
{
	NSIndexSet *selectionIndexes;
	if (self.view == self.iconView) {
		selectionIndexes = [self.libraryIconView selectionIndexes];
	} else {
		selectionIndexes = [self.libraryTableView selectedRowIndexes];
	}
	if (selectionIndexes && [selectionIndexes count] > 0) {
		return YES;
	} else {
		return NO;
	}
}

- (NSArray *)selectedBooks
{
	NSIndexSet *selectionIndexes;
	NSMutableArray *books;
	
	if (self.view == self.iconView) {
		selectionIndexes = [self.libraryIconView selectionIndexes];
	} else {
		selectionIndexes = [self.libraryTableView selectedRowIndexes];
	}
	if (selectionIndexes && [selectionIndexes count]) {
		NSUInteger  *indices;
		NSInteger   numBooks = [self.library.books count];
		NSUInteger	numSelection;
		int i;
		
		books = [[NSMutableArray alloc] init];
		indices = malloc(numBooks * sizeof(NSUInteger));
		numSelection = [selectionIndexes getIndexes:indices maxCount:numBooks inIndexRange:nil];
		
		for (i=0;i<numSelection;i++) {
			NSDictionary *dictionary = [[self.bookListController arrangedObjects] objectAtIndex:indices[i]];
			ISOBook *theBook = [dictionary objectForKey:kBVTheBook];
			[books addObject:theBook];
		}
		free(indices);
	}
	return books;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[self.bookListController arrangedObjects] count];
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(ISOLibraryListViewRow *)rowView forRow:(NSInteger)rowIndex
{
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)rowIndex
{
    ISOLibraryListViewRow *result = [[ISOLibraryListViewRow alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    result.objectValue = [[self.bookListController arrangedObjects] objectAtIndex:rowIndex];
    return result;
}

// We want to make "group rows" for the folders
- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
	return NO;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	ISOLibraryListViewCV	*cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    NSMutableDictionary		*displayedBook = [[self.bookListController arrangedObjects] objectAtIndex:rowIndex];
	ISOBook					*theBook = [displayedBook objectForKey:kBVTheBook];
	
	cellView.bookTitleField.stringValue = [displayedBook objectForKey:kBVTitle];
	cellView.bookAuthorField.stringValue = [displayedBook objectForKey:kBVAuthor];
	[cellView.bookCoverView setValue:displayedBook];
	
	if ([theBook bookPubYear] == nil) {
		cellView.bookPubYearField.stringValue = @"";
	} else {
		cellView.bookPubYearField.stringValue = [theBook bookPubYear];
	}
	if ([theBook bookPublisher] == nil) {
		cellView.bookPublisherField.stringValue = @"";
	} else {
		cellView.bookPublisherField.stringValue = [theBook bookPublisher];
	}

	
	return cellView;
}

// We make the "group rows" have the standard height, while all other image rows have a larger height
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return [tableView rowHeight];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[self libraryTableViewClicked:self.libraryTableView];
}

- (IBAction)libraryTableViewClicked:(id)sender
{
    NSMutableDictionary *displayedBook = [self selectedBookInTablevView];
	ISOBook *theBook = [displayedBook objectForKey:kBVTheBook];

	if (displayedBook) {
		[self.bookCoverView setValue:displayedBook forKey:@"value"];
		[self.bookTitleField setStringValue:[displayedBook objectForKey:kBVTitle]];
		[self.bookAuthorField setStringValue:[displayedBook objectForKey:kBVAuthor]];
		[self.bookPubYearField setStringValue:[theBook bookPubYear]];
		[self.bookPublisherField setStringValue:[theBook bookPublisher]];
		[self.bookNumChaptersField setIntegerValue:[theBook numberOfChapters]];
		[self.bookLastChapterReadField setIntegerValue:[theBook bookLastReadChapter]+1];
	} else {
		[self.bookCoverView setValue:nil forKey:@"value"];
		[self.bookCoverView setNeedsDisplay:YES];
		[self.bookTitleField setStringValue:@""];
		[self.bookAuthorField setStringValue:@""];
		[self.bookPubYearField setStringValue:@""];
		[self.bookPublisherField setStringValue:@""];
		[self.bookNumChaptersField setStringValue:@""];
		[self.bookLastChapterReadField setStringValue:@""];
	}
}

- (IBAction)libraryTableViewDoubleClicked:(id)sender
{
	[NSApp sendAction:@selector(libraryViewItemDoubleClicked:) to:nil from:self];
}

- (void)paperBookAdded:(ISOBook *)paperBook
{
	NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self bvBooks]];
	NSImage *coverImage = [[NSImage alloc] initByReferencingFile:[paperBook bookCover]];
	
	if (!coverImage) {
		coverImage = [[NSImage alloc] initWithSize:NSMakeSize(2, 2)];
	}
	[library addBook:paperBook];
	[tempArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							 [paperBook bookTitle], kBVTitle,
							 [paperBook bookAuthor], kBVAuthor,
							 coverImage, kBVCover,
							 paperBook, kBVTheBook,
							nil]];
	[self setBvBooks:tempArray];
	[self reSortLibrary];
	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];

}
- (void)paperBookChanged:(ISOBook *)paperBook
{
	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
}

@end
