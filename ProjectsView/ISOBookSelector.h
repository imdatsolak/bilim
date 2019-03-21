//
//  ISOProjectBookSelector.h
//  xBilim
//
//  Created by Imdat Solak on 11/10/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISONotesListViewController.h"
#import "ISOBook.h"
#import "ISOProject.h"
#import "ISOProjectChapter.h"
#import "ISOProjectsViewController.h"

@class ISOProjectsViewController;

@interface ISOBookSelector : NSObject <NSTableViewDataSource, NSTableViewDelegate>
{
	ISOProject	*theProject;
	ISOProjectChapter *theChapter;
	NSWindow *controllingWindow;
	ISOProjectsViewController *pvController;
	NSArray		*books;
	
}
@property IBOutlet NSTextField *projectTitleField;
@property IBOutlet NSTextField *projectChapterNumberField;
@property IBOutlet NSTextField *projectChapterTitleField;

@property IBOutlet NSTableView *bookTableView;
@property IBOutlet NSSplitView *splitView;
@property IBOutlet NSView *rightView;
@property IBOutlet NSWindow *selectorWindow;
@property IBOutlet NSButton *addBooksButton;
@property IBOutlet NSArray *displayedBooks;
@property IBOutlet NSArrayController *displayedBooksController;

@property ISONotesListViewController *notesListView;

- (NSArray *)selectBooksForProject:(ISOProject *)aProject andChapter:(ISOProjectChapter *)aChapter inWindow:(NSWindow *)aWindow forController:(ISOProjectsViewController *)aController;

- (IBAction)okButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
