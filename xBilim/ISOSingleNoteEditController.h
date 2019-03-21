//
//  ISOSingleNoteEditController.h
//  xBilim
//
//  Created by Imdat Solak on 11/4/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBook.h"
#import "ISOSingleNote.h"

@class ISOSingleNoteEditController;

@interface ISOSNECPopoverController : NSViewController

@property IBOutlet NSTextField *bookTitleField;
@property IBOutlet NSTextField *bookChapterField;
@property IBOutlet NSTextField *selectedTextField;
@property IBOutlet NSTextField *notesTextField;
@property IBOutlet NSTableView *projectsTableView;
@property IBOutlet NSPopUpButton *tagsPopUpButton;

@property ISOSingleNoteEditController *owner;

- (IBAction)okButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@end

@interface ISOSingleNoteEditController : NSViewController <NSPopoverDelegate>
{
	ISOBook *theBook;
	NSInteger chapterNumber;
	NSRange selectionRange;
	NSString *selectionText;
	ISOSingleNote *theNote;
	id objToNotifyOnOK;
	SEL selectorToUse;

}

@property IBOutlet ISOSNECPopoverController *popoverController;
@property IBOutlet NSWindow *detachedWindow;
@property NSPopover *myPopover;

- (void)setNote:(ISOSingleNote *)aNote inBook:(ISOBook *)aBook;
- (void)editNoteRelativeToRect:(NSRect)boundingRect inView:(NSView *)selectedTextView notifyOnOK:(id)anObject withSelector:(SEL)aSelector;
- (IBAction)okButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (void)closePopover;

@end
