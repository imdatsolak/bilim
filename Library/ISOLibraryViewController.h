//
//  ISOLibraryViewController.h
//  xBilim
//
//  Created by Imdat Solak on 10/24/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOMasterViewController.h"
#import "ISOLibrary.h"
#import "ISOBook.h"
#import "ISOPaperBookController.h"

#define kBVCover	@"BVCover"
#define kBVTitle	@"BVTitle"
#define kBVAuthor	@"BVAuthor"
#define kBVFilepath	@"BVFilepath"
#define kBVTheBook	@"BVTheBook"

#define kTBLVAddBook			@"TBLVAddBook"
#define kTBLVRemoveBook			@"TBLVRemoveBook"

#define kTBLVAddRemoveBook		@"TBLVAddRemoveBook"
#define kTBLVSortOrder			@"TBLVSortOrder"
#define kTBLVViewMode			@"TBLVViewMode"
#define kTBLVSearchView			@"TBLVSearchView"
#define kTBLVMessageField		@"TBLVMessageField"
#define kTBLVToolbarID			@"TBToolbarIDLV"


@interface ISOLibraryViewController : ISOMasterViewController <NSTableViewDataSource, NSTableViewDelegate>
{
	NSString *sortingOrder;
	ISOLibrary *library;
	NSUInteger selectedViewMode;
	NSUInteger selectedSortOrder;
	ISOPaperBookController *paperBookController;
}

// Views displayed (we can show ICON-View & LIST-View)
@property IBOutlet NSScrollView *libraryScrollView;
@property IBOutlet NSCollectionView *libraryIconView;

@property IBOutlet NSView *libraryListView;
@property IBOutlet NSTableView *libraryTableView;
@property IBOutlet NSView *iconView;
@property IBOutlet NSView *listView;
@property IBOutlet NSArrayController *bookListController;

// Toolbar Entries
@property IBOutlet NSSegmentedControl *sortBySelector;
@property IBOutlet NSSegmentedControl *viewAsSelector;
@property IBOutlet NSSegmentedControl *addRemoveSelector;
@property IBOutlet NSTextField *messageField;
@property IBOutlet NSSearchField *searchField;

// Adding Books Progress Panel Stuff
@property IBOutlet NSPanel *bookAddProgressPanel;
@property IBOutlet NSProgressIndicator *bookAddProgressIndicator;
@property IBOutlet NSTextField *bookAddTitleField;

// Book Details Popover Fields
@property IBOutlet NSImageView *bookCoverView;
@property IBOutlet NSTextField *bookTitleField;
@property IBOutlet NSTextField *bookAuthorField;
@property IBOutlet NSTextField *bookPubYearField;
@property IBOutlet NSTextField *bookPublisherField;
@property IBOutlet NSTextField *bookNumChaptersField;
@property IBOutlet NSTextField *bookLastChapterReadField;
@property IBOutlet NSTokenField *bookProjectsField;

// NON-IB Properties

@property NSMutableArray *bvBooks;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)setLibrary:(ISOLibrary *)aLibrary;
- (ISOLibrary *)library;
- (void)reSortLibrary;
- (void)sortBooksBy:(NSUInteger)newSortOrder;
- (void)changeViewMode:(NSUInteger)newViewMode;

// Menu Target/Action Methods
- (IBAction)addEBook:(id)sender;
- (IBAction)addPaperBook:(id)sender;
- (IBAction)removeBookFromLibrary:(id)sender;
- (IBAction)createNewProjectWithSelection:(id)sender;
- (IBAction)viewLibraryAsIcon:(id)sender;
- (IBAction)viewLibraryAsList:(id)sender;
- (IBAction)sortLibraryByTitle:(id)sender;
- (IBAction)sortLibraryByAuthor:(id)sender;
- (IBAction)sortLibraryByLastRead:(id)sender;

- (ISOBook *)selectedBook;

- (IBAction)libraryTableViewClicked:(id)sender;
- (IBAction)libraryTableViewDoubleClicked:(id)sender;
@end
