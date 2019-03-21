//
//  ISOProjectsViewController.h
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOHeaders.h"
#import "ISOMasterViewController.h"
#import "ISOProject.h"
#import "ISOProjectChapter.h"
#import "ISOTableHeaderView.h"
#import "ISOColoredView.h"
#import "ISOBookViewController.h"
#import "ISOProjects.h"
#import "ISOProjectNotesViewController.h"
#import "ISOBookSelector.h"

@class ISOProjectNotesViewController;
@class ISOProjectsViewController;
@class ISOBookSelector;

@interface ISOProjectInfoDisplayer : NSObject
{
	
}
@end

@interface ISOProjectEditor : NSObject
{
	BOOL						addingNewProject;
	NSWindow					*controllingWindow;
	ISOProjectsViewController	*pvController;
	ISOProject					*theProject;
}

@property IBOutlet NSTextField	*projectTitleField;
@property IBOutlet NSTextField	*projectDescField;
@property IBOutlet NSButton		*addProjectButton;
@property IBOutlet NSWindow		*projectInfoWindow;

- (void)editProject:(ISOProject *)aProject withWindow:(NSWindow *)aWindow andMasterViewController:(ISOProjectsViewController *)aController;
- (void)addProjectWithWithWindow:(NSWindow *)aWindow andMasterViewController:(ISOProjectsViewController *)aController;
- (void)addProjectWithWithWindow:(NSWindow *)aWindow masterViewController:(ISOProjectsViewController *)aController andSelection:(NSArray *)selection;

@end

@interface ISOProjectChapterEditor : NSObject
{
	BOOL						addingNewProjectChapter;
	NSWindow					*controllingWindow;
	ISOProjectsViewController	*pvController;
	ISOProjectChapter			*theChapter;
	ISOProject					*theProject;
}

@property IBOutlet NSTextField	*projectTitleField;
@property IBOutlet NSTextField	*projectChapterTitleField;
@property IBOutlet NSTextField	*projectChapterDescField;
@property IBOutlet NSTextField	*projectChapterNumberField;
@property IBOutlet NSButton		*addChapterButton;
@property IBOutlet NSWindow		*projectChapterInfoWindow;

@end

@interface ISOProjectsViewController : ISOMasterViewController <NSOutlineViewDelegate, NSOutlineViewDataSource, NSSplitViewDelegate>
{
	ISOProject *selectedProject;
	ISOProjects *projects;
}
@property IBOutlet NSOutlineView *chaptersOutlineView;
@property IBOutlet NSTextField *projectTitleField;
@property IBOutlet ISOTableHeaderView *tableHeaderView;
@property IBOutlet ISOColoredView *tableBottomView;
@property IBOutlet NSPopUpButton *projectsPopUpButton;
@property IBOutlet NSView *rightView;
@property IBOutlet NSView *leftView;

@property ISOBookViewController *bookViewController;
@property ISOProjectNotesViewController *projectNotesViewController;
@property ISOProjectEditor *projectEditor;
@property ISOProjectChapterEditor *projectChapterEditor;
@property ISOBookSelector *bookSelector;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)setProjects:(ISOProjects *)projectList;
- (ISOProjects *)projects;
- (IBAction)projectSelected:(id)sender;

- (IBAction)itemClicked:(id)sender;
- (IBAction)itemDoubleClicked:(id)sender;
- (ISOBook *)selectedBook;

// Target/Action Methods
- (IBAction)createNewProject:(id)sender;
- (void)createNewProjectWithSelectedBooks:(NSArray *)selection; // a very special case
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

//
- (void)projectAdded:(ISOProject *)aProject;
- (void)projectChanged:(ISOProject *)aProject;

- (void)project:(ISOProject *)aProject chapterAdded:(ISOProjectChapter *)aChapter;
- (void)project:(ISOProject *)aProject chapterChanged:(ISOProjectChapter *)aChapter;

//
- (void)addBooks:(NSArray *)selectedBooks toProject:(ISOProject *)theProject andChapter:(ISOProjectChapter *)theChapter;

@end
