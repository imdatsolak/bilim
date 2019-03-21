//
//  ISOPaperBookController.m
//  xBilim
//
//  Created by Imdat Solak on 11/8/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOPaperBookController.h"

@implementation ISOPaperBookController

- (id)init
{
	self = [super init];
	if (self) {
		[[NSBundle mainBundle] loadNibNamed:@"PaperBookEditor" owner:self topLevelObjects:nil];
		addingNewBook = NO;
	}
	return self;
}

- (void)_checkOkButtonEnabled
{
	if (([[self.bookTitleField stringValue] length] > 4) &&
		([[self.bookAuthorField stringValue] length] > 4)) {
		[self.addBookButton setEnabled:YES];
	} else {
		[self.addBookButton setEnabled:NO];
	}
}

- (void)editPaperBook:(ISOBook *)aBook withWindow:(NSWindow *)aWindow andMasterViewController:(ISOMasterViewController *)aController
{
	theBook = aBook;
	controllingWindow = aWindow;
	masterViewController = aController;
	bookCoverPath = nil;
	[self.bookTitleField setStringValue:[theBook bookTitle]];
	[self.bookAuthorField setStringValue:[theBook bookAuthor]];
	[self.bookPublisherField setStringValue:[theBook bookPublisher]];
	[self.bookPubYearField setStringValue:[theBook bookPubYear]];
	[self.bookEditionField setStringValue:[theBook paperBookEdition]];
	[self.bookISBNField setStringValue:[theBook paperBookISBN]];
	[self.bookCommentsField setStringValue:[theBook paperBookComments]];
	bookCoverPath = [theBook bookCover];
	if (bookCoverPath && [bookCoverPath length] >0) {
		[self.bookCoverView setImage:[[NSImage alloc] initByReferencingFile:bookCoverPath]];
		[self.removeBookCoverButton setEnabled:YES];
	} else {
		bookCoverPath = nil;
		[self.removeBookCoverButton setEnabled:NO];
	}
	[aWindow beginSheet:self.sheetPanel completionHandler:^(NSModalResponse returnCode) {
		NSLog(@"Sheet completed...");
	}];
}

- (void)addPaperBookWithWindow:(NSWindow *)aWindow andMasterViewController:(ISOMasterViewController *)aController
{
	ISOBook *aBook = [[ISOBook alloc] initWithPaperBookTitle:@"" author:@"" publisher:@"" pubYear:@"1999" edition:@"" comments:@"" andISBN:@""];
	addingNewBook = YES;
	[self editPaperBook:aBook withWindow:aWindow andMasterViewController:aController];
}

- (IBAction)okButtonClicked:(id)sender
{
	[theBook setBookTitle:[self.bookTitleField stringValue]];
	[theBook setBookAuthor:[self.bookAuthorField stringValue]];
	if ([self.bookPublisherField stringValue]) {
		[theBook setBookPublisher:[self.bookPublisherField stringValue]];
	}
	if ([self.bookPubYearField stringValue]) {
		[theBook setBookPubYear:[self.bookPubYearField stringValue]];
	}
	if ([self.bookEditionField stringValue]) {
		[theBook setPaperBookEdition:[self.bookEditionField stringValue]];
	}
	if ([self.bookISBNField stringValue]) {
		[theBook setPaperBookISBN:[self.bookISBNField stringValue]];
	}
	if ([self.bookCommentsField stringValue]) {
		[theBook setPaperBookComments:[self.bookCommentsField stringValue]];
	}
	[theBook setBookCover:bookCoverPath];
	[controllingWindow endSheet:self.sheetPanel];
	if (addingNewBook) {
		[masterViewController paperBookAdded:theBook];
	} else {
		[masterViewController paperBookChanged:theBook];
	}
	addingNewBook = NO;
}

- (IBAction)cancelButtonClicked:(id)sender
{
	addingNewBook = NO;
	[controllingWindow endSheet:self.sheetPanel];
}

- (void)setBookCoverImagePath:(NSURL *)coverImageURL
{
	bookCoverPath = [coverImageURL path];
	[self.bookCoverView setImage:[[NSImage alloc] initByReferencingFile:bookCoverPath]];
	[self.removeBookCoverButton setEnabled:YES];
}

- (IBAction)selectBookCoverButtonClicked:(id)sender
{
    NSString *extensions = @"jpg/jpeg/JPG/JPEG/png/PNG";
    NSArray *types = [extensions pathComponents];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
    [openPanel setAllowedFileTypes:types];
    [openPanel setCanSelectHiddenExtension:YES];
	[openPanel setAllowsMultipleSelection:NO];
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
			NSArray *urls = [openPanel URLs];
			if (urls && [urls count]) {
				[self setBookCoverImagePath:[urls objectAtIndex:0]];
			}
        }
    }];
}

- (IBAction)deleteBookCoverButtonClicked:(id)sender
{
	[self.bookCoverView setImage:nil];
	bookCoverPath = nil;
	[self.removeBookCoverButton setEnabled:NO];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	[self _checkOkButtonEnabled];
	return YES;
}

@end
