//
//  ISOBookDetailsViewController.h
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBookCoverView.h"

@class ISOBookCoverView;

@interface ISOBDVCController : NSViewController
{
	
}
@property IBOutlet ISOBookCoverView *bookCoverView;
@property IBOutlet NSTextField *bookTitleField;
@property IBOutlet NSTextField *bookAuthorField;
@property IBOutlet NSTextField *bookPubYearField;
@property IBOutlet NSTextField *bookPublisherField;
@property IBOutlet NSTextField *bookNumChaptersField;
@property IBOutlet NSTextField *bookLastChapterReadField;
@property IBOutlet NSTokenField *bookProjectsField;

- (void)updatePopoverContentFromBook:(NSMutableDictionary *)theBook;

@end

@interface ISOBookDetailsViewController : NSViewController <NSPopoverDelegate>


@property IBOutlet NSWindow *detachedWindow;

@property IBOutlet ISOBDVCController *popoverViewController;
@property IBOutlet ISOBDVCController *detachedWindowViewController;


@property NSPopover *myPopover;

- (void)showBookDetails:(NSMutableDictionary *)theBook relativeTo:(id)anObject;

@end
