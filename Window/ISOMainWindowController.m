//
//  ISOMainWindowController.m
//  xBilim
//
//  Created by Imdat Solak on 10/21/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOMainWindowController.h"
#import "ISOBook.h"
#import "ISOHeaders.h"

#define BILIM_DATA_FILE		@"Bilim.blm"

@implementation ISOMainWindowController

- (NSString *)_bilimDataPath
{
	return [NSString stringWithFormat:@"%@/%@", ISOApplicationDirectoryUsingPath(nil), BILIM_DATA_FILE];
}

- (void)_loadBilimDataFromPath:(NSString *)path
{
	if (self && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSData	*data = [NSData dataWithContentsOfFile:path];
		
		bilim = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		theLibrary = [bilim objectForKey:kLIBRARY_IDENTIFIER];
		theProjects = [bilim objectForKey:kPROJECTS_IDENTIFIER];
	} else {
		bilim = [[NSMutableDictionary alloc] init];
		theLibrary = [[ISOLibrary alloc] init];
		theProjects = [[ISOProjects alloc] init];
		[bilim setObject:theLibrary forKey:kLIBRARY_IDENTIFIER];
		[bilim setObject:theProjects forKey:kPROJECTS_IDENTIFIER];
		[self syncData];
	}
}

- (BOOL)writeToFile:(NSString *)thePath atomically:(BOOL)flag
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bilim];
	
	if (data && [data writeToFile:thePath atomically:flag]) {
		return YES;
	} else {
		return NO;
	}
}
- (void)syncData
{
	[self writeToFile:[self _bilimDataPath] atomically:YES];
}

- (void)bilimDataChanged:(id)anObj
{
	[self syncData];
}


- (id)initWithWindowNibName:(NSString *)windowNibName
{
	self = [super initWithWindowNibName:windowNibName];
	if (self) {
		currentDisplayMode = DISPLAYMODE_NONE;
		isWindowFullscreen = NO;
		[self _loadBilimDataFromPath:[self _bilimDataPath]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bilimDataChanged:) name:ISOBilimDataChangedNotification object:nil];
		return self;
	}
	return nil;
}

- (void)dealloc
{
	[self syncData];
}

/* ******************************************************************************
 * TARGET/ACTION METHODS from MainMenu
 * ******************************************************************************
 */

// Library Menu
- (IBAction)addEBook:(id)sender
{
	[(ISOLibraryViewController*)currentVC addEBook:sender];
}

- (IBAction)addPaperBook:(id)sender
{
	[currentVC addPaperBook:sender];
}

- (IBAction)removeBookFromLibrary:(id)sender
{
	[(ISOLibraryViewController*)currentVC removeBookFromLibrary:sender];
}

- (IBAction)synchronizeLibrary:(id)sender
{
	[self syncData];
}


// Edit Menu
- (IBAction)copyAsReference:(id)sender
{
	
}
- (IBAction)copyAsReferenceWithNote:(id)sender
{
	
}

// Projects Menu
- (IBAction)createNewProject:(id)sender
{
	[(ISOProjectsViewController *)currentVC createNewProject:sender];
}

- (IBAction)createNewProjectWithSelection:(id)sender
{
	[(ISOLibraryViewController*)currentVC createNewProjectWithSelection:sender];
}

- (IBAction)addChapterToProject:(id)sender
{
	[(ISOProjectsViewController *)currentVC addChapterToProject:sender];
}

- (IBAction)addBookToProject:(id)sender
{
	[(ISOProjectsViewController *)currentVC addBookToProject:sender];
}
- (IBAction)removeBookFromChapter:(id)sender
{
	[(ISOProjectsViewController *)currentVC removeBookFromChapter:sender];
}

- (IBAction)editProject:(id)sender
{
	[(ISOProjectsViewController *)currentVC editProject:sender];
}

- (IBAction)manageProjects:(id)sender
{
	[(ISOProjectsViewController *)currentVC manageProjects:sender];
}

- (IBAction)editChapter:(id)sender
{
	[(ISOProjectsViewController *)currentVC editChapter:sender];
}

- (IBAction)deleteChapterFromProject:(id)sender
{
	[(ISOProjectsViewController *)currentVC deleteChapterFromProject:sender];
}

- (IBAction)deleteProject:(id)sender
{
	[(ISOProjectsViewController *)currentVC deleteProject:sender];
}

- (IBAction)exportNotes:(id)sender
{
	[(ISOProjectsViewController *)currentVC exportNotes:sender];
}

- (IBAction)exportReferences:(id)sender
{
	[(ISOProjectsViewController *)currentVC exportReferences:sender];
}

// View Menu
- (IBAction)switchToLibraryView:(id)sender
{
	[self switchToDisplayMode:DISPLAYMODE_LIBRARY];
}

- (IBAction)switchToProjectsView:(id)sender
{
	[self switchToDisplayMode:DISPLAYMODE_PROJECT];
}

- (IBAction)switchToBookView:(id)sender
{
	ISOBook *selectedBook;
	if (currentVC != self.bookViewController) {
		selectedBook = [currentVC selectedBook];
		if (selectedBook) {
			currentBook = selectedBook;
			[self switchToDisplayMode:DISPLAYMODE_BOOK];
		} else {
			NSBeep();
		}
	} else {
		NSBeep();
	}
}

- (IBAction)viewLibraryAsIcon:(id)sender
{
	[(ISOLibraryViewController *)currentVC viewLibraryAsIcon:sender];
}

- (IBAction)viewLibraryAsList:(id)sender
{
	[(ISOLibraryViewController *)currentVC viewLibraryAsList:sender];
}

- (IBAction)sortLibraryByTitle:(id)sender
{
	[(ISOLibraryViewController *)currentVC sortLibraryByTitle:sender];
}

- (IBAction)sortLibraryByAuthor:(id)sender
{
	[(ISOLibraryViewController *)currentVC sortLibraryByAuthor:sender];
}

- (IBAction)sortLibraryByLastRead:(id)sender
{
	[(ISOLibraryViewController *)currentVC sortLibraryByLastRead:sender];
}

- (IBAction)showHighlighting:(id)sender
{
	
}

/* *********************************************************************************
 * END MainMenu Target/Action Methods
 * *********************************************************************************
 */

- (void)_showLibrary
{
	if (self.libraryViewController == nil) {
		self.libraryViewController = [[ISOLibraryViewController alloc] initWithNibName:@"LibraryView" bundle:[NSBundle mainBundle]];
		self.libraryViewController.mainController = self;
	}
	[self.libraryViewController setLibrary:theLibrary];
	[self.libraryViewController setIsFullscreen:isWindowFullscreen];
	[self.libraryViewController displayInWindow:self.window];
	currentVC = self.libraryViewController;
}

- (void)_showProjects
{
	if (self.projectViewController == nil) {
		self.projectViewController = [[ISOProjectsViewController alloc] initWithNibName:@"ProjectsView" bundle:[NSBundle mainBundle]];
		self.projectViewController.mainController = self;
	}
	[self.projectViewController setProjects:theProjects];
	[self.projectViewController setIsFullscreen:isWindowFullscreen];
	[self.projectViewController displayInWindow:self.window];
	currentVC = self.projectViewController;
}

- (void)_showBook
{
	BOOL newlyCreated = NO;
	if (self.bookViewController == nil) {
		self.bookViewController = [[ISOBookReaderViewController alloc] initWithNibName:@"BookView" bundle:[NSBundle mainBundle]];
		self.bookViewController.mainController = self;
		newlyCreated = YES;
	}
	[self.bookViewController setIsFullscreen:isWindowFullscreen];
	[self.bookViewController displayInWindow:self.window];
	if (newlyCreated) {
		[self.bookViewController setBook:[self currentBook]];
	} else {
		[self.bookViewController resetBook:[self currentBook]];
	}
	currentVC = self.bookViewController;
}

- (void)unconditionallySwitchToViewMode:(UInt)theViewMode fromViewMode:(UInt)oldViewMode
{
	NSToolbar *aToolbar;
	
	[self.window disableFlushWindow];
	switch (oldViewMode) {
		case DISPLAYMODE_LIBRARY:
			[self.libraryViewController removeFromCurrentWindow];
			break;
		case DISPLAYMODE_PROJECT:
			[self.projectViewController removeFromCurrentWindow];
			break;
		case DISPLAYMODE_BOOK:
			[self.bookViewController removeFromCurrentWindow];
			break;
		case DISPLAYMODE_NONE:
		default:
			break;
	}
	
	switch (theViewMode) {
		case DISPLAYMODE_LIBRARY:
			[self _showLibrary];
			break;
		case DISPLAYMODE_PROJECT:
			[self _showProjects];
			break;
		case DISPLAYMODE_BOOK:
			[self _showBook];
			break;
		case DISPLAYMODE_NONE:
		default:
			break;
	}
	aToolbar = [currentVC toolbar];
	if (aToolbar != [self.window toolbar]) {
		[aToolbar setDelegate:self];
		[aToolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
		[aToolbar setSizeMode:NSToolbarSizeModeSmall];
		[aToolbar setAllowsUserCustomization:NO];
		[self.window setToolbar:aToolbar];
	}
}

- (void)switchToDisplayMode: (UInt)theDisplayMode
{
	if (theDisplayMode != currentDisplayMode) {
		[self unconditionallySwitchToViewMode:theDisplayMode fromViewMode:currentDisplayMode];
		currentDisplayMode = theDisplayMode;
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterFull:)
                                                 name:NSWindowWillEnterFullScreenNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didExitFull:)
                                                 name:NSWindowDidExitFullScreenNotification
                                               object:nil];
	[self switchToDisplayMode:DISPLAYMODE_LIBRARY]; // TODO - needs to restore last DISPLAYMODE
	[self.window makeKeyAndOrderFront:self];
}

// Window Resizing...

- (void)didExitFull:(NSNotification *)notif
{
	isWindowFullscreen = NO;
	[self.libraryViewController setIsFullscreen:isWindowFullscreen];
	[self.projectViewController setIsFullscreen:isWindowFullscreen];
	[self.bookViewController setIsFullscreen:isWindowFullscreen];
}

- (void)willEnterFull:(NSNotification *)notif
{
	[self.libraryViewController rememberViewSize];
	[self.projectViewController rememberViewSize];
	[self.bookViewController rememberViewSize];
	isWindowFullscreen = YES;
	[self.libraryViewController setIsFullscreen:isWindowFullscreen];
	[self.projectViewController setIsFullscreen:isWindowFullscreen];
	[self.bookViewController setIsFullscreen:isWindowFullscreen];
}

- (void)windowDidResize:(NSNotification *)notification
{
	[self.libraryViewController windowDidResize:notification];
	[self.projectViewController windowDidResize:notification];
	[self.bookViewController windowDidResize:notification];
}

- (NSApplicationPresentationOptions)window:(NSWindow *)window willUseFullScreenPresentationOptions:(NSApplicationPresentationOptions)proposedOptions
{
    return (NSApplicationPresentationFullScreen |
            NSApplicationPresentationHideDock |
            NSApplicationPresentationAutoHideMenuBar |
            NSApplicationPresentationAutoHideToolbar);
}

- (ISOBook *)currentBook
{
	// Following code needs to change at operational mode...
	return currentBook; // this needs to change to reflect last open book...
}

- (void)setCurrentBook:(ISOBook *)aBook
{
	currentBook = aBook;
}

- (ISOLibrary *)theLibrary
{
	return theLibrary;
}

// Toolbar Validation

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
	return [currentVC validateToolbarItem:theItem];
}

- (void)toolbarWillAddItem:(NSNotification *)notif
{
	[currentVC toolbarWillAddItem:notif];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	return [currentVC toolbar:toolbar itemForItemIdentifier:itemIdentifier willBeInsertedIntoToolbar:flag];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [currentVC toolbarDefaultItemIdentifiers:toolbar];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return [currentVC toolbarAllowedItemIdentifiers:toolbar];
}

// UI Validation
- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
    SEL theAction = [anItem action];
	if ((theAction == @selector(switchToLibraryView:)) || (theAction == @selector(switchToBookView:)) || (theAction == @selector(switchToProjectsView:))) {
		if ((theAction == @selector(switchToProjectsView:)) && currentDisplayMode == DISPLAYMODE_PROJECT) {
			[(NSMenuItem *)anItem setState:NSOnState];
		} else if ((theAction == @selector(switchToLibraryView:)) && currentDisplayMode == DISPLAYMODE_LIBRARY) {
			[(NSMenuItem *)anItem setState:NSOnState];
		} else if ((theAction == @selector(switchToBookView:)) && currentDisplayMode == DISPLAYMODE_BOOK) {
			[(NSMenuItem *)anItem setState:NSOnState];
		} else {
			[(NSMenuItem *)anItem setState:NSOffState];
		}
		return YES;
	} else if (theAction == @selector(synchronizeLibrary:)) {
		return YES;
	} else {
		return [currentVC validateUserInterfaceItem:anItem];
	}
}

// Other Stuff

- (IBAction)libraryViewItemDoubleClicked:(id)sender
{
	[self switchToBookView:self];
}


@end
