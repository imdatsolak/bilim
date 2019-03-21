//
//  ISOProjectBookSelector.m
//  xBilim
//
//  Created by Imdat Solak on 11/10/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOBookSelector.h"
#import "ISOMainWindowController.h"

@implementation ISOBookSelector

- (id)init
{
	self = [super init];
	if (self) {
		[[NSBundle mainBundle] loadNibNamed:@"ProjectBookSelector" owner:self topLevelObjects:nil];
	}
	return self;
}

- (NSArray *)selectBooksForProject:(ISOProject *)aProject andChapter:(ISOProjectChapter *)aChapter inWindow:(NSWindow *)aWindow forController:(ISOProjectsViewController *)aController
{
	NSInteger i;
	NSArray *sortDescriptors;
	NSMutableArray *dBooks;
	
	theProject = aProject;
	theChapter = aChapter;
	controllingWindow = aWindow;
	pvController = aController;
	books = [aController.mainController theLibrary].books;
	dBooks = [[NSMutableArray alloc] init];
	for (i=0;i<[books count]; i++) {
		ISOBook *aBook = [books objectAtIndex:i];
		NSDictionary *aDict = [NSDictionary dictionaryWithObjectsAndKeys:
							   [aBook bookAuthor], kBookAuthor,
							   [NSString stringWithFormat:@"%@ (%@)", [aBook bookTitle], [aBook bookPubYear]], kBookTitle,
							   aBook, kBVTheBook,
							   nil];
		[dBooks addObject:aDict];
	}
	sortDescriptors = [NSArray arrayWithObjects: [[NSSortDescriptor alloc]
							  initWithKey:kBookAuthor
							  ascending:YES
							  selector:@selector(caseInsensitiveCompare:)],
					   [[NSSortDescriptor alloc]
						initWithKey:kBookTitle
						ascending:YES
						selector:@selector(caseInsensitiveCompare:)],
					   nil];
    [self.bookTableView setSortDescriptors:sortDescriptors];
	
	self.displayedBooks = dBooks;
	[self.projectTitleField setStringValue:[theProject projectTitle]];;
	[self.projectChapterNumberField setIntegerValue:[theChapter chapterNumber]];
	[self.projectChapterTitleField setStringValue:[theChapter chapterTitle]];
	[self.bookTableView reloadData];
	[controllingWindow beginSheet:self.selectorWindow completionHandler:^(NSModalResponse returnCode) {
		NSLog(@"Sheet completed...");
	}];

	return nil;
}

- (IBAction)okButtonClicked:(id)sender
{
	NSIndexSet		*selectionIndexes;
	NSMutableArray	*selectedBooks;
	NSUInteger		numSelection;
	
	selectionIndexes = [self.bookTableView selectedRowIndexes];
	if (selectionIndexes && [selectionIndexes count]) {
		NSUInteger  *indices;
		int i;
		
		numSelection = [selectionIndexes count];
		selectedBooks = [[NSMutableArray alloc] init];
		indices = malloc(numSelection * sizeof(NSUInteger));
		numSelection = [selectionIndexes getIndexes:indices maxCount:numSelection inIndexRange:nil];
		NSArray *selectedArray = [self.displayedBooksController arrangedObjects];
		for (i=0;i<numSelection;i++) {
			NSDictionary *aDict = [selectedArray objectAtIndex:indices[i]];
			ISOBook *theBook = [aDict objectForKey:kBVTheBook];
			[selectedBooks addObject:theBook];
		}
		free(indices);
	}
	[controllingWindow endSheet:self.selectorWindow];
	if (selectedBooks && [selectedBooks count]) {
		[pvController addBooks:selectedBooks toProject:theProject andChapter:theChapter];
	}
}

- (IBAction)cancelButtonClicked:(id)sender
{
	[controllingWindow endSheet:self.selectorWindow];
}


// TABLEVIEW Delegate/DataSource Methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	NSLog(@"Num called");
    return [[self.displayedBooksController arrangedObjects] count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	if (rowIndex < [books count]) {
		ISOBook *aBook = (ISOBook *)[[self.displayedBooksController arrangedObjects] objectAtIndex:rowIndex];
		NSString *title;
		if ([[aTableColumn identifier] isEqualToString:@"AuthorColumn"]) {
			title = [NSString stringWithFormat:@"%@", [aBook bookAuthor]] ;
		} else {
			title = [NSString stringWithFormat:@"%@ (%@)", [aBook bookTitle], [aBook bookPubYear]];
		}
		return title;
	} else {
		return @"<BOOK NOT FOUND>";
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[self.addBooksButton setEnabled:([self.bookTableView selectedRow]>=0)];
}
@end
