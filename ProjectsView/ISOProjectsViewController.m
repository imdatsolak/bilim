//
//  ISOProjectsViewController.m
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOProjectsViewController.h"
#import "ISOProjectChapter.h"
#import "ISOPVBookCellView.h"
#import "ISOPVChapterCellView.h"
#import "ISOMainWindowController.h"
#import "ISOTableHeaderView.h"
#import "ISOHeaders.h"

ISOProject *ISOCreateNewEmptyProject()
{
	ISOProject *aProject = [[ISOProject alloc] initWithTitle:@"" andDescription:@""];
	ISOProjectChapter *chapterZero = [[ISOProjectChapter alloc] initWithChapterTitle:NSLocalizedString(@"0: NO CHAPTER", @"Title of General Chapter")
																		 description:NSLocalizedString(@"General Chapter in Every Book", @"General ZERO-Chapter") andChapterNumber:0];
	
	[aProject addChapter:chapterZero];
	return aProject;

}

@implementation ISOProjectInfoDisplayer



@end


@implementation ISOProjectEditor

- (id)init
{
	self = [super init];
	if (self) {
		[[NSBundle mainBundle] loadNibNamed:@"ProjectEditor" owner:self topLevelObjects:nil];
		addingNewProject = NO;
	}
	return self;
}


- (void)editProject:(ISOProject *)aProject withWindow:(NSWindow *)aWindow andMasterViewController:(ISOProjectsViewController *)aController
{
	theProject = aProject;
	controllingWindow = aWindow;
	pvController = aController;
	[self.projectTitleField setStringValue:[theProject projectTitle]];
	[self.projectDescField setStringValue:[theProject projectDescription]];
	
	[aWindow beginSheet:self.projectInfoWindow completionHandler:^(NSModalResponse returnCode) {
		NSLog(@"Sheet completed...");
	}];
}

- (void)addProjectWithWithWindow:(NSWindow *)aWindow andMasterViewController:(ISOProjectsViewController *)aController
{
	ISOProject *aProject = ISOCreateNewEmptyProject();
	
	addingNewProject = YES;
	[self editProject:aProject withWindow:aWindow andMasterViewController:aController];
}

- (void)addProjectWithWithWindow:(NSWindow *)aWindow masterViewController:(ISOProjectsViewController *)aController andSelection:(NSArray *)selection
{
	if (selection && [selection count]) {
		ISOProject *newProject = ISOCreateNewEmptyProject();
		ISOProjectChapter *firstChapter;
		int i;
		
		firstChapter = [newProject chapterWithChapterNumber:0];
		
		for (i=0;i<[selection count]; i++) {
			[firstChapter addBook:[selection objectAtIndex:i]];
		}
		addingNewProject = YES;
		[self editProject:newProject withWindow:aWindow andMasterViewController:aController];
	}
}

- (IBAction)addButtonClicked:(id)sender
{
	[theProject setProjectTitle:[self.projectTitleField stringValue]];
	[theProject setProjectDescription:[self.projectDescField stringValue]];
	[controllingWindow endSheet:self.projectInfoWindow];
	if (addingNewProject) {
		[pvController projectAdded:theProject];
	} else {
		[pvController projectChanged:theProject];
	}
	addingNewProject = NO;
}

- (IBAction)cancelButtonClicked:(id)sender
{
	addingNewProject = NO;
	[controllingWindow endSheet:self.projectInfoWindow];
}


- (void)_checkOkButtonEnabled
{
	if ([[self.projectTitleField stringValue] length] > 4) {
		[self.addProjectButton setEnabled:YES];
	} else {
		[self.addProjectButton setEnabled:NO];
	}
}


- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	[self _checkOkButtonEnabled];
	return YES;
}


@end

@implementation ISOProjectChapterEditor


- (id)init
{
	self = [super init];
	if (self) {
		[[NSBundle mainBundle] loadNibNamed:@"ProjectChapterEditor" owner:self topLevelObjects:nil];
		addingNewProjectChapter = NO;
	}
	return self;
}


- (void)editProjectChapter:(ISOProjectChapter *)aChapter withWindow:(NSWindow *)aWindow masterViewController:(ISOProjectsViewController *)aController andProject:(ISOProject *)aProject
{
	controllingWindow = aWindow;
	pvController = aController;
	theChapter = aChapter;
	theProject = aProject;
	[self.projectTitleField setStringValue:[theProject projectTitle]];
	[self.projectChapterTitleField setStringValue:[theChapter chapterTitle]];
	[self.projectChapterDescField setStringValue:[theChapter chapterDescription]];
	[self.projectChapterNumberField setIntegerValue:[theChapter chapterNumber]];

	[aWindow beginSheet:self.projectChapterInfoWindow completionHandler:^(NSModalResponse returnCode) {
		NSLog(@"Sheet completed...");
	}];
}

- (void)addProjectChapterWithWithWindow:(NSWindow *)aWindow masterViewController:(ISOProjectsViewController *)aController andProject:(ISOProject *)aProject
{
	ISOProjectChapter *newChapter = [[ISOProjectChapter alloc] initWithChapterTitle:@""
																		description:@""
																   andChapterNumber:[aProject numberOfProjectChapters]];
	
	addingNewProjectChapter = YES;
	[self editProjectChapter:newChapter withWindow:aWindow masterViewController:aController andProject:aProject];
}

- (IBAction)addButtonClicked:(id)sender
{
	[theChapter setChapterTitle:[self.projectChapterTitleField stringValue]];
	[theChapter setChapterDescription:[self.projectChapterDescField stringValue]];
	[controllingWindow endSheet:self.projectChapterInfoWindow];
	if (addingNewProjectChapter) {
		[pvController project:theProject chapterAdded:theChapter];
	} else {
		[pvController project:theProject chapterChanged:theChapter];
	}
	addingNewProjectChapter = NO;
}

- (IBAction)cancelButtonClicked:(id)sender
{
	addingNewProjectChapter = NO;
	[controllingWindow endSheet:self.projectChapterInfoWindow];
}


- (void)_checkOkButtonEnabled
{
	if ([[self.projectChapterTitleField stringValue] length] > 4) {
		[self.addChapterButton setEnabled:YES];
	} else {
		[self.addChapterButton setEnabled:NO];
	}
}


- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	[self _checkOkButtonEnabled];
	return YES;
}


@end

// --------------------------------------------------------------------------------------------

@interface ISOProjectsViewController ()

@end

@implementation ISOProjectsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self.chaptersOutlineView sizeLastColumnToFit];
		[self.chaptersOutlineView setFloatsGroupRows:YES];
		[self.chaptersOutlineView setTarget:self];
		[self.chaptersOutlineView setAction:@selector(itemClicked:)];
		[self.chaptersOutlineView setDoubleAction:@selector(itemDoubleClicked:)];
		[self.tableBottomView setBackgroundColor:[NSColor colorWithRed:1.0/255.0*215.0 green:1.0/255.0*221.0 blue:1.0/255.0*229.0 alpha:1.0]];
		self.bookViewController = [[ISOBookViewController alloc] initWithNibName:@"ISOBookViewController" bundle:[NSBundle mainBundle]];
		self.projectNotesViewController = [[ISOProjectNotesViewController alloc] initWithNibName:@"ISOProjectNotesViewController" bundle:[NSBundle mainBundle]];
		return self;
	}
	return nil;
}

#ifdef _DEV_MODE
- (void)_createSomeProjects
{
	ISOProject			*aProject;
	ISOProjectChapter	*aChapter;
	NSArray				*projTitles = [NSArray arrayWithObjects:
									   @"W&W - Volume 1: Management",
									   @"W&W - Volume 2: Profit & Values",
									   @"W&W - Volume 3: Change & Disruption",
									   @"W&W - Volume 4: Not-for-Profit",
									   @"W&W - Volume 5: Productivity & Innovation",
									   @"W&W - Volume 6: Diversity & Inclusion",
									   @"W&W - Volume 7: Technology & Sustainability",
									   @"W&W - Volume 8: Knowledge & Society",
									   @"W&W - Volume 9: Globalization & Regulation",
									   @"W&W - Volume X: Future",
									   nil];
	NSMutableArray		*someBooks = self.mainController.libraryViewController.bvBooks;
	int					i;
	NSArray				*anArray = [NSArray arrayWithObjects:@"<NO CHAPTER>",
									@"Introduction",
									@"Part I: Change, what is it?",
									@"Part II: Disruption What is it",
									@"Change vs Disruption",
									@"Disrupting Everything", nil];
	NSArray				*chaptDescs = [NSArray arrayWithObjects:@"Books without Chapter Assignment (so far)",
									   @"Just setting the tone",
									   @"Mostly about the background, etc",
									   @"The same about disruption",
									   @"Comparative study of disruption vs change",
									   @"Ending the World as we know it...", nil];
	
	aProject = [[ISOProject alloc] initWithTitle:[projTitles objectAtIndex:[projects numberOfProjects]]];
	for (i=0;i<6;i++) {
		NSString *cTitle =[anArray objectAtIndex:i];
		if (i==0) {
			cTitle = [NSString stringWithFormat:@"%@>GENERAL", [aProject projectTitle]];
		}
		aChapter = [[ISOProjectChapter alloc] initWithChapterTitle:cTitle description:[chaptDescs objectAtIndex:i] andChapterNumber:i];
		[aProject addChapter:aChapter];
		int j;
		for (j=0;j<2;j++) {
			[aChapter addBook:[someBooks objectAtIndex:i*2+j]];
		}
	}
	[projects addProject:aProject];
	[self _updateProjectsMenu];
	
}
#endif

- (void)setProjects:(ISOProjects *)projectList
{
	projects = projectList;
	if ([projects numberOfProjects] > 0) {
		selectedProject = [projects projectAtIndex:0];
		[self _updateProjectsMenu];
	}
}

- (ISOProjects *)projects
{
	return projects;
}

- (void)_updateProjectsMenu
{
	NSInteger	i;
	NSMenu		*theMenu;
	
	theMenu = [self.projectsPopUpButton menu];
	
	for (i=0;i<[projects numberOfProjects]; i++) {
		NSMenuItem *anItem = [theMenu itemWithTag:i];
		if (anItem) {
			[theMenu removeItem:anItem];
		}
	}
	for (i=0;i<[projects numberOfProjects]; i++) {
		NSMenuItem *newItem = [[NSMenuItem alloc] initWithTitle:[[projects projectAtIndex:i] projectTitle] action:@selector(projectSelected:) keyEquivalent:@""];
		
		[newItem setEnabled:YES];
		[newItem setTarget:self];
		[newItem setAction:@selector(projectSelected:)];
		[newItem setTag:i];
		[theMenu addItem:newItem];
	}
}
- (void)_updateOutlineData
{
	[self.chaptersOutlineView setIndentationPerLevel:1.0];
	[self.chaptersOutlineView setHeaderView:self.tableHeaderView];
	if (selectedProject) {
		[self.projectTitleField setStringValue:selectedProject.projectTitle];
	}
    [self.chaptersOutlineView reloadData];
    [self.chaptersOutlineView setRowSizeStyle:NSTableViewRowSizeStyleDefault];
	[self.chaptersOutlineView expandItem:nil expandChildren:YES];
}

#define ISOLEFTVIEW_WIDTH 360.0
#define ISORIGHTVIEW_WIDTH 320.0

- (void)displayInWindow:(NSWindow *)theWindow
{
	lastViewSize.width = MAX(lastViewSize.width, 1350.0);
	[super displayInWindow:theWindow];
	[self _updateOutlineData];
	if (([self.bookViewController.view superview] != self.view) && ([self.projectNotesViewController.view superview] != self.view)) {
		CGFloat rightDivPos;
		NSRect aRect = [self.view frame];
		[self.bookViewController.view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[self.bookViewController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
		
		aRect.size.width -= ISORIGHTVIEW_WIDTH+ISOLEFTVIEW_WIDTH;
		[self.bookViewController.view setFrame:aRect];

		[self.view addSubview:self.bookViewController.view positioned:NSWindowAbove relativeTo:self.leftView];

		rightDivPos = [self.view frame].size.width - ISORIGHTVIEW_WIDTH;
		[(NSSplitView *)self.view setPosition:ISOLEFTVIEW_WIDTH ofDividerAtIndex:0];
		[(NSSplitView *)self.view setPosition:rightDivPos ofDividerAtIndex:1];
		[self.bookViewController setShowNotes:YES replacingView:self.rightView];
		[(NSSplitView *)self.view adjustSubviews];
	}
}


- (void)setIsFullscreen:(BOOL)flag
{
	[super setIsFullscreen:flag];

	if ([self.bookViewController.view superview] == self.view || [self.projectNotesViewController.view superview] == self.view) {
		CGFloat rightDivPos;
		rightDivPos = [self.view frame].size.width - ISORIGHTVIEW_WIDTH;
		[(NSSplitView *)self.view setPosition:rightDivPos ofDividerAtIndex:1];
		[(NSSplitView *)self.view setPosition:ISOLEFTVIEW_WIDTH ofDividerAtIndex:0];
		[(NSSplitView *)self.view adjustSubviews];
	}
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
}

- (NSArray *)_childrenForItem:(id)item
{
    NSArray *children;
    if (item == nil) {
        children = selectedProject.chapters;
    } else if ([item isKindOfClass:[ISOProjectChapter class]]){
        children = ((ISOProjectChapter *)item).books;
    }
    return children;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [[self _childrenForItem:item] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[ISOProjectChapter class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self _childrenForItem:item] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [item isKindOfClass:[ISOProjectChapter class]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
    // As an example, hide the "outline disclosure button" for FAVORITES. This hides the "Show/Hide" button and disables the tracking area for that row.
	return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    // For the groups, we just return a regular text view.
    if ([item isKindOfClass:[ISOProjectChapter class]]) {
		ISOProjectChapter *chapter = (ISOProjectChapter *)item;
        ISOPVChapterCellView *chapterCellView = [outlineView makeViewWithIdentifier:@"ChapterCellView" owner:self];

		[chapterCellView.chapterTitleField setStringValue:chapter.chapterTitle];
        [chapterCellView.chapterDescField setStringValue:chapter.chapterDescription];
        return chapterCellView;
    } else  if ([item isKindOfClass:[ISOBook class]]) {
		NSMutableDictionary *displayedBook;
        ISOPVBookCellView *bookCellView = [outlineView makeViewWithIdentifier:@"BookCellView" owner:self];
		ISOBook *theBook = (ISOBook *)item;
		NSImage *coverImage = [[NSImage alloc] initByReferencingFile:[theBook bookCover]];
		
		if (!coverImage) {
			coverImage = [[NSImage alloc] initWithSize:NSMakeSize(2, 2)];
		}
		displayedBook = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								[theBook bookTitle], kBVTitle,
								[theBook bookAuthor], kBVAuthor,
								coverImage, kBVCover,
								theBook, kBVTheBook,
								nil];
		
		bookCellView.coverView.value = displayedBook;
		[bookCellView.bookTitleField setStringValue:[theBook bookTitle]];
		[bookCellView.bookAuthorField setStringValue:[theBook bookAuthor]];
		[bookCellView.bookPubYearField setStringValue:[theBook bookPubYear]];
		[bookCellView.bookPublisherField setStringValue:[theBook bookPublisher]];
		return  bookCellView;
    }
	return nil;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    if ([item isKindOfClass:[ISOProjectChapter class]]) {
        return 48;
    } else {
        return 92;
    }
}

// SplitView Delegate Methods
- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
	[self.bookViewController adjustPagesToNewViewSize];
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
	return NO;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex
{
	if (dividerIndex == 0) {
		return 360.0;
	} else if (dividerIndex ==1) {
		return 360+700+200;
	} else {
		return 10000.0;
	}
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex
{
	if (dividerIndex == 0) {
		return 360.0;
	} else if (dividerIndex == 1) {
		return 360+700;
	} else {
		return 0.0;
	}
}

// TableView Target/Action
- (IBAction)itemClicked:(id)sender
{
	NSInteger selectedRow = [self.chaptersOutlineView selectedRow];
	id item = [self.chaptersOutlineView itemAtRow:selectedRow];
	ISOBook *theBook;
	NSInteger projectChapterNumber = NSIntegerMax;
	
	if ([item isKindOfClass:[ISOBook class]]) {
		theBook = (ISOBook *)item;
		projectChapterNumber = [(ISOProjectChapter *)[self.chaptersOutlineView parentForItem:theBook] chapterNumber];
	} else if ([item isKindOfClass:[ISOProjectChapter class]]) {
		theBook = nil;
		projectChapterNumber = [(ISOProjectChapter *)item chapterNumber];
	}
	if (theBook || projectChapterNumber != NSIntegerMax) {
		[self.bookViewController setShowNotes:NO replacingView:nil];
		if ([self.projectNotesViewController.view superview] != self.view) {
			CGFloat rightDivPos;
			
			NSRect aRect = [self.bookViewController.view frame];
			aRect.size.width -= ISORIGHTVIEW_WIDTH+ISOLEFTVIEW_WIDTH;
			rightDivPos = [self.view frame].size.width - ISORIGHTVIEW_WIDTH;

			[self.projectNotesViewController.view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
			[self.projectNotesViewController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
			[self.projectNotesViewController.view setFrame:aRect];
			[self.view replaceSubview:self.bookViewController.view with:self.projectNotesViewController.view];
			[(NSSplitView *)self.view setPosition:ISOLEFTVIEW_WIDTH ofDividerAtIndex:0];
			[(NSSplitView *)self.view setPosition:rightDivPos ofDividerAtIndex:1];
			[(NSSplitView *)self.view adjustSubviews];
		}
		[self.projectNotesViewController displayBookNotes:theBook forProject:selectedProject andChapterNumber:projectChapterNumber];
	}
}

- (IBAction)itemDoubleClicked:(id)sender
{
	NSInteger selectedRow = [self.chaptersOutlineView selectedRow];
	id item = [self.chaptersOutlineView itemAtRow:selectedRow];
	
	if ([item isKindOfClass:[ISOProjectChapter class]]) {
		NSBeep();
    } else  if ([item isKindOfClass:[ISOBook class]]) {
		ISOBook *theBook = (ISOBook *)item;
		if (theBook) {
			if ([self.bookViewController.view superview] != self.view) {
				CGFloat rightDivPos;
				
				NSRect aRect = [self.projectNotesViewController.view frame];
				aRect.size.width -= ISORIGHTVIEW_WIDTH+ISOLEFTVIEW_WIDTH;
				rightDivPos = [self.view frame].size.width - ISORIGHTVIEW_WIDTH;
				[self.view replaceSubview:self.projectNotesViewController.view with:self.bookViewController.view];
				[(NSSplitView *)self.view setPosition:ISOLEFTVIEW_WIDTH ofDividerAtIndex:0];
				[(NSSplitView *)self.view setPosition:rightDivPos ofDividerAtIndex:1];
				[(NSSplitView *)self.view adjustSubviews];
			}
			[self.bookViewController setShowNotes:YES replacingView:nil];
			[self.bookViewController resetBook:theBook];
			[self.bookViewController setBookProject:selectedProject];
			[self.bookViewController setBookProjectChapterNumber:[(ISOProjectChapter *)[self.chaptersOutlineView parentForItem:theBook] chapterNumber]];
		}
	} else {
		NSBeep();
	}
}

- (ISOBook *)selectedBook
{
	NSInteger selectedRow = [self.chaptersOutlineView selectedRow];
	id item = [self.chaptersOutlineView itemAtRow:selectedRow];
	
	if ([item isKindOfClass:[ISOProjectChapter class]]) {
		return [self.bookViewController currentBook];
    } else if ([item isKindOfClass:[ISOBook class]]) {
		return (ISOBook *)item;
	} else {
		return nil;
	}
}


- (BOOL)_isBookSelected
{
	NSInteger selectedRow = [self.chaptersOutlineView selectedRow];
	id item = [self.chaptersOutlineView itemAtRow:selectedRow];
	
	if (item && [item isKindOfClass:[ISOBook class]]) {
		return YES;
	}
	return NO;
}

- (BOOL)_isChapterSelected
{
	NSInteger selectedRow = [self.chaptersOutlineView selectedRow];
	id item = [self.chaptersOutlineView itemAtRow:selectedRow];
	
	if (item && [item isKindOfClass:[ISOProjectChapter class]]) {
		return YES;
    }
	return NO;
}
// Projects Menu - TARGET/ACTION

- (IBAction)createNewProject:(id)sender
{
	if (self.projectEditor == nil) {
		self.projectEditor = [[ISOProjectEditor alloc] init];
	}
	[self.projectEditor addProjectWithWithWindow:[self.view window] andMasterViewController:self];
}

- (void)createNewProjectWithSelectedBooks:(NSArray *)selection
{
	if (selection && [selection count]) {
		if (self.projectEditor == nil) {
			self.projectEditor = [[ISOProjectEditor alloc] init];
		}
		[self.projectEditor addProjectWithWithWindow:[self.view window] masterViewController:self andSelection:selection];
	} else {
		NSBeep();
	}
}

- (IBAction)addChapterToProject:(id)sender
{
	if (selectedProject) {
		if (self.projectChapterEditor == nil) {
			self.projectChapterEditor = [[ISOProjectChapterEditor alloc] init];
		}
		[self.projectChapterEditor addProjectChapterWithWithWindow:[self.view window] masterViewController:self andProject:selectedProject];
	} else {
		NSBeep();
	}
}

- (IBAction)addBookToProject:(id)sender
{
	NSInteger selectedRow = [self.chaptersOutlineView selectedRow];
	id item = [self.chaptersOutlineView itemAtRow:selectedRow];
	ISOProjectChapter *selectedChapter;
	
	if ([item isKindOfClass:[ISOProjectChapter class]]) {
		selectedChapter = (ISOProjectChapter *)item;
    } else  if ([item isKindOfClass:[ISOBook class]]) {
		ISOBook *theBook = (ISOBook *)item;
		selectedChapter = (ISOProjectChapter *)[self.chaptersOutlineView parentForItem:theBook];
	} else {
		NSBeep();
		return;
	}
	if (self.bookSelector == nil) {
		self.bookSelector = [[ISOBookSelector alloc] init];
	}
	[self.bookSelector selectBooksForProject:selectedProject andChapter:selectedChapter inWindow:[self.view window] forController:self];
}

- (IBAction)removeBookFromChapter:(id)sender
{
	NSAlert *anAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"Remove Book From Chapter", @"Title of Alert Panel when removing Book")
										   defaultButton:NSLocalizedString(@"Cancel", @"Title of the Cancel Button")
										 alternateButton:NSLocalizedString(@"Remove", @"Title of the Remove Button")
											 otherButton:nil
							   informativeTextWithFormat:NSLocalizedString(@"Do you really want to remove the book from the Project Chapter?", @"AlertPanel Title When Removing a Book")];
	if ([anAlert runModal] == NSAlertAlternateReturn) {
		ISOBook *theBook = (ISOBook *)[self.chaptersOutlineView itemAtRow:[self.chaptersOutlineView selectedRow]];
		ISOProjectChapter *selectedChapter = (ISOProjectChapter *)[self.chaptersOutlineView parentForItem:theBook];
		[selectedChapter removeBook:theBook];
		[self _updateOutlineData];
		[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
	}
	
}

- (IBAction)editProject:(id)sender
{
	
}

- (IBAction)manageProjects:(id)sender
{
	//	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
}

- (IBAction)projectSelected:(id)sender
{
	if ([sender tag] < [projects numberOfProjects]) {
		ISOProject *newProject = [projects projectAtIndex:[sender tag]];
		if (newProject != selectedProject) {
			selectedProject = newProject;
			[self _updateOutlineData];
		}
	} else {
		NSBeep();
	}
}

- (IBAction)editChapter:(id)sender
{
	
}

- (IBAction)deleteChapterFromProject:(id)sender
{
	
}

- (IBAction)deleteProject:(id)sender
{
	
}

- (IBAction)exportNotes:(id)sender
{
	
}

- (IBAction)exportReferences:(id)sender
{
	
}

// User Interface Validation
- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
    SEL theAction = [anItem action];
	if (theAction == @selector(createNewProject:)) {
		return YES;
	} else if (theAction == @selector(addChapterToProject:)) {
		return (selectedProject != nil);
	} else if (theAction == @selector(addBookToProject:)) {
		return (selectedProject != nil);
	} else if (theAction == @selector(removeBookFromChapter:)) {
		return (selectedProject != nil) && ([self _isBookSelected]);
	} else if (theAction == @selector(editProject:)) {
		return (selectedProject != nil);
	} else if (theAction == @selector(manageProjects:)) {
		return YES;
	} else if (theAction == @selector(projectSelected:)) {
		return YES;
	} else if (theAction == @selector(editChapter:)) {
		return (selectedProject != nil) && (([self _isChapterSelected] || [self _isBookSelected]));
	} else if (theAction == @selector(deleteChapterFromProject:)) {
		return (selectedProject != nil) && ([self _isChapterSelected]);
	} else if (theAction == @selector(deleteProject:)) {
		return (selectedProject != nil);
	} else if (theAction == @selector(exportNotes:)) {
		return (selectedProject != nil);
	} else if (theAction == @selector(exportReferences:)) {
		return (selectedProject != nil);
	}
	return NO;
}


// Callbacks from ProjectEditor, ProjectChapterEditor and so on...

- (void)projectAdded:(ISOProject *)aProject
{
	[self.projects addProject:aProject];
	selectedProject = aProject;
	[self _updateProjectsMenu];
	[self _updateOutlineData];
	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
}

- (void)projectChanged:(ISOProject *)aProject
{
	selectedProject = aProject;
	[self _updateProjectsMenu];
	[self _updateOutlineData];
	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
}

- (void)project:(ISOProject *)aProject chapterAdded:(ISOProjectChapter *)aChapter
{
	selectedProject = aProject;
	[selectedProject addChapter:aChapter];
	[self _updateOutlineData];
	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
}

- (void)project:(ISOProject *)aProject chapterChanged:(ISOProjectChapter *)aChapter
{
	selectedProject = aProject;
	[self _updateOutlineData];
	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
}

//
- (void)addBooks:(NSArray *)selectedBooks toProject:(ISOProject *)theProject andChapter:(ISOProjectChapter *)theChapter
{
	if (selectedBooks && [selectedBooks count] && theProject && theChapter) {
		NSInteger i;
		for (i=0; i<[selectedBooks count];i++) {
			[theChapter addBook:[selectedBooks objectAtIndex:i]];
		}
		selectedProject = theProject;
		[self _updateOutlineData];
		[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
	} else {
		NSBeep();
	}
}


@end
