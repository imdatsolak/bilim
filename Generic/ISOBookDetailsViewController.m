//
//  ISOBookDetailsViewController.m
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOBookDetailsViewController.h"
#import "ISOLibraryViewController.h"

@implementation ISOBDVCController

- (void)updatePopoverContentFromBook:(NSMutableDictionary *)theBook
{
	ISOBook *book;

	if (theBook) {
		book = [theBook objectForKey:kBVTheBook];
		[self.bookCoverView setValue:theBook forKey:@"value"];
		[self.bookTitleField setStringValue:[theBook objectForKey:kBVTitle]];
		[self.bookAuthorField setStringValue:[theBook objectForKey:kBVAuthor]];

		[self.bookPubYearField setStringValue:[book bookPubYear]];
		[self.bookPublisherField setStringValue:[book bookPublisher]];
		[self.bookNumChaptersField setIntegerValue:[book numberOfChapters]];
		[self.bookLastChapterReadField setIntValue:[book bookLastReadChapter]+1];
	} else {
		[self.bookCoverView setValue:nil forKey:@"value"];
		[self.bookCoverView setNeedsDisplay:YES];
		[self.bookTitleField setStringValue:@""];
		[self.bookAuthorField setStringValue:@""];
		[self.bookPubYearField setStringValue:@""];
		[self.bookPublisherField setStringValue:@""];
		[self.bookNumChaptersField setStringValue:@""];
		[self.bookLastChapterReadField setStringValue:@""];
	}
}


@end
@interface ISOBookDetailsViewController ()

@end

@implementation ISOBookDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.detachedWindow.contentView = self.detachedWindowViewController.view;
		self.popoverViewController = [[ISOBDVCController alloc] initWithNibName:@"BookCoverDetailsViewPopover" bundle:[NSBundle mainBundle]];
		self.detachedWindowViewController = [[ISOBDVCController alloc] initWithNibName:@"BookCoverDetailsViewPopover" bundle:[NSBundle mainBundle]];
    }
    return self;
}

- (void)createPopover
{
    if (self.myPopover == nil)
    {
        self.myPopover = [[NSPopover alloc] init];
		self.myPopover.contentViewController = self.popoverViewController;
		// self.myPopover.appearance = [popoverType selectedRow];
        
        // self.myPopover.animates = [animatesCheckbox state];
        
        // AppKit will close the popover when the user interacts with a user interface element outside the popover.
        // note that interacting with menus or panels that become key only when needed will not cause a transient popover to close.
        self.myPopover.behavior = NSPopoverBehaviorTransient;
        
        // so we can be notified when the popover appears or closes
        self.myPopover.delegate = self;
    }
}

- (void)showBookDetails:(NSMutableDictionary *)theBook relativeTo:(id)anObject
{
	[self createPopover];
    [self.myPopover showRelativeToRect:[anObject bounds] ofView:anObject preferredEdge:NSMaxYEdge];
    [self.popoverViewController updatePopoverContentFromBook:theBook];
}

/* **************************************************************************
 * NSPopoverDelegate Methods
 * **************************************************************************
 */
// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverWillShowNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (void)popoverWillShow:(NSNotification *)notification
{
}

// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverDidShowNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (void)popoverDidShow:(NSNotification *)notification
{
    // add new code here after the popover has been shown
}

// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverWillCloseNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (void)popoverWillClose:(NSNotification *)notification
{
    NSString *closeReason = [[notification userInfo] valueForKey:NSPopoverCloseReasonKey];
    if (closeReason)
    {
        // closeReason can be:
        //      NSPopoverCloseReasonStandard
        //      NSPopoverCloseReasonDetachToWindow
        //
        // add new code here if you want to respond "before" the popover closes
        //
    }
}

// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverDidCloseNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (void)popoverDidClose:(NSNotification *)notification
{
    NSString *closeReason = [[notification userInfo] valueForKey:NSPopoverCloseReasonKey];
    if (closeReason)
    {
        // closeReason can be:
        //      NSPopoverCloseReasonStandard
        //      NSPopoverCloseReasonDetachToWindow
        //
        // add new code here if you want to respond "after" the popover closes
        //
    }
    
    self.myPopover = nil;
}

// -------------------------------------------------------------------------------
// Invoked on the delegate asked for the detachable window for the popover.
// -------------------------------------------------------------------------------
- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover
{
	return self.detachedWindow;
}

@end
