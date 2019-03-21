//
//  ISOPaperBookController.h
//  xBilim
//
//  Created by Imdat Solak on 11/8/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOMasterViewController.h"
#import "ISOBook.h"

@class ISOLibraryViewController;

@interface ISOPaperBookController : NSObject
{
	ISOMasterViewController	*masterViewController;
	NSWindow	*controllingWindow;
	NSString	*bookCoverPath;
	ISOBook		*theBook;
	NSModalSession panelModalSession;
	BOOL		addingNewBook;
}

@property IBOutlet NSTextField	*bookTitleField;
@property IBOutlet NSTextField	*bookAuthorField;
@property IBOutlet NSTextField	*bookPublisherField;
@property IBOutlet NSTextField	*bookPubYearField;
@property IBOutlet NSTextField	*bookEditionField;
@property IBOutlet NSTextField	*bookCommentsField;
@property IBOutlet NSTextField	*bookISBNField;
@property IBOutlet NSImageView	*bookCoverView;
@property IBOutlet NSButton		*removeBookCoverButton;
@property IBOutlet NSButton		*addBookButton;
@property IBOutlet NSWindow		*sheetPanel;



- (void)editPaperBook:(ISOBook *)aBook withWindow:(NSWindow *)aWindow andMasterViewController:(ISOMasterViewController *)aController;
- (void)addPaperBookWithWindow:(NSWindow *)aWindow andMasterViewController:(ISOMasterViewController *)aController;

- (IBAction)okButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)selectBookCoverButtonClicked:(id)sender;
- (IBAction)deleteBookCoverButtonClicked:(id)sender;
@end
