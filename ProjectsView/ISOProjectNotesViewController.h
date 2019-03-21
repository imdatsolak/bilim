//
//  ISOProjectNotesViewController.h
//  xBilim
//
//  Created by Imdat Solak on 11/6/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOHeaders.h"
#import "ISOSingleNote.h"
#import "ISOProject.h"
#import "ISOBook.h"
#import "ISOProjectsViewController.h"
#import "ISOTableHeaderView.h"

@class ISOProjectsViewController;

@interface ISOProjectNotesViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, ISONoteOwnerProtocol>
{
	NSArray *projectChapterNotesArray;
	ISOProject *project;
	ISOBook *book;
	NSInteger projectChapterNumber;
	BOOL showingAllNotesOfChapter;
	BOOL showingAllNotesOfProject;
}

@property IBOutlet ISOTableHeaderView *tableHeaderView;
@property IBOutlet NSTableView *notesTableView;
@property IBOutlet NSButton *showCitationsSwitch;
@property IBOutlet ISOColoredView *tableBottomView;

@property ISOProjectsViewController *owner;

- (void)displayBookNotes:(ISOBook *)aBook forProject:(ISOProject *)aProject andChapterNumber:(NSInteger)aNumber;
- (IBAction)toggleShowCitations:(id)sender;
- (void)deleteNoteButtonClicked:(id)sender;
- (void)editNoteButtonClicked:(id)sender;
@end
