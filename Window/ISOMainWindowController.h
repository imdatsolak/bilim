//
//  ISOMainWindowController.h
//  xBilim
//
//  Created by Imdat Solak on 10/21/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOBookReaderViewController.h"
#import "ISOLibraryViewController.h"
#import "ISOProjectsViewController.h"


#define DISPLAYMODE_NONE	0
#define DISPLAYMODE_LIBRARY	1
#define DISPLAYMODE_BOOK	2
#define DISPLAYMODE_PROJECT	3

#define kLIBRARY_IDENTIFIER		@"BilimBooks"
#define kPROJECTS_IDENTIFIER	@"BilimProjects"
#define kBILIM_IDENTIFIER		@"BilimEntries"

@interface ISOMainWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate, NSToolbarDelegate>
{
	BOOL		showingNotes;
	int			currentDisplayMode;
	ISOBook		*currentBook;
	BOOL		isWindowFullscreen;
	ISOMasterViewController	*currentVC;
	
	ISOLibrary	*theLibrary;
	ISOProjects *theProjects;
	NSMutableDictionary *bilim;
}

@property IBOutlet ISOBookReaderViewController *bookViewController;
@property IBOutlet ISOLibraryViewController *libraryViewController;
@property IBOutlet ISOProjectsViewController *projectViewController;
@property IBOutlet NSToolbar *theToolbar;


// Library Menu
- (IBAction)addEBook:(id)sender;
- (IBAction)addPaperBook:(id)sender;
- (IBAction)removeBookFromLibrary:(id)sender;
- (IBAction)synchronizeLibrary:(id)sender;

// Edit Menu
- (IBAction)copyAsReference:(id)sender;
- (IBAction)copyAsReferenceWithNote:(id)sender;

// Projects Menu
- (IBAction)createNewProject:(id)sender;
- (IBAction)createNewProjectWithSelection:(id)sender;
- (IBAction)addChapterToProject:(id)sender;
- (IBAction)addBookToProject:(id)sender;
- (IBAction)removeBookFromChapter:(id)sender;
- (IBAction)editProject:(id)sender;
- (IBAction)manageProjects:(id)sender;
- (IBAction)editChapter:(id)sender;
- (IBAction)deleteChapterFromProject:(id)sender;
- (IBAction)deleteProject:(id)sender;
- (IBAction)exportNotes:(id)sender;
- (IBAction)exportReferences:(id)sender;

// View Menu
- (IBAction)switchToLibraryView:(id)sender;
- (IBAction)switchToProjectsView:(id)sender;
- (IBAction)switchToBookView:(id)sender;
- (IBAction)viewLibraryAsIcon:(id)sender;
- (IBAction)viewLibraryAsList:(id)sender;
- (IBAction)sortLibraryByTitle:(id)sender;
- (IBAction)sortLibraryByAuthor:(id)sender;
- (IBAction)sortLibraryByLastRead:(id)sender;
- (IBAction)showHighlighting:(id)sender;

- (void)switchToDisplayMode: (UInt)theDisplayMode;

- (id)initWithWindowNibName:(NSString *)windowNibName;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

- (void)unconditionallySwitchToViewMode:(UInt)theViewMode fromViewMode:(UInt)oldViewMode;

- (ISOBook *)currentBook;
- (void)setCurrentBook:(ISOBook *)aBook;
- (ISOLibrary *)theLibrary;
- (IBAction)libraryViewItemDoubleClicked:(id)sender;

@end
