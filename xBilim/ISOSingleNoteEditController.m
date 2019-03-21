//
//  ISOSingleNoteEditController.m
//  xBilim
//
//  Created by Imdat Solak on 11/4/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOSingleNoteEditController.h"

@implementation ISOSNECPopoverController
- (IBAction)okButtonClicked:(id)sender
{
	if (self.owner) {
		[self.owner okButtonClicked:sender];
	}
}

- (IBAction)cancelButtonClicked:(id)sender
{
	if (self.owner) {
		[self.owner cancelButtonClicked:sender];
	}
}
@end

@interface ISOSingleNoteEditController ()

@end

@implementation ISOSingleNoteEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.popoverController = [[ISOSNECPopoverController alloc] initWithNibName:@"SNECPopover" bundle:[NSBundle mainBundle]];
		self.popoverController.owner = self;
		return self;
    }
    return self;
}

- (void)setNote:(ISOSingleNote *)aNote inBook:(ISOBook *)aBook
{
	theNote = aNote;
	theBook = aBook;
//	[theBook addNote:aNote]; // In fact, this is ok because it will be added only if it doesn't exist yet in the book
}

- (void)editNoteRelativeToRect:(NSRect)boundingRect inView:(NSView *)selectedTextView notifyOnOK:(id)anObject withSelector:(SEL)aSelector
{
	NSRange noteL = [theNote noteLocation];
	[self createPopover];
	objToNotifyOnOK = anObject;
	selectorToUse = aSelector;
	[self.popoverController.tagsPopUpButton selectItemWithTag:[theNote tagID]];
    [self.myPopover showRelativeToRect:boundingRect ofView:selectedTextView preferredEdge:NSMinXEdge];
	[self.popoverController.bookTitleField setStringValue:[theBook bookTitle]];
	[self.popoverController.bookChapterField setStringValue:[NSString stringWithFormat:@"%lu - %@", [theNote chapterNumber]+1, [theNote chapterTitle]]];
	[self.popoverController.selectedTextField setStringValue:[NSString stringWithFormat:@"(%lu - %lu) %@", noteL.location, noteL.location+noteL.length, [theNote citation]]];
	[self.popoverController.notesTextField setStringValue:[theNote noteText]];
	[self.popoverController.tagsPopUpButton selectItemWithTag:[theNote tagID]];
}

- (IBAction)okButtonClicked:(id)sender
{
	[theNote setNoteText:[self.popoverController.notesTextField stringValue]];
	[theNote setTagID:[[self.popoverController.tagsPopUpButton selectedItem] tag]];
	if (objToNotifyOnOK && [objToNotifyOnOK respondsToSelector:selectorToUse]) {
		[objToNotifyOnOK performSelector:selectorToUse withObject:theNote];
	}
	[self closePopover];
}

- (IBAction)cancelButtonClicked:(id)sender
{
	[self closePopover];
}
- (void)closePopover
{
	[self.myPopover close];
	objToNotifyOnOK = nil;
}
/* ******************
 * Popover Stuff
 * ******************
 */
- (void)createPopover
{
    if (self.myPopover == nil)
    {
        self.myPopover = [[NSPopover alloc] init];
		self.myPopover.contentViewController = self.popoverController;
		// self.myPopover.appearance = [popoverType selectedRow];
        
        // self.myPopover.animates = [animatesCheckbox state];
        
        // AppKit will close the popover when the user interacts with a user interface element outside the popover.
        // note that interacting with menus or panels that become key only when needed will not cause a transient popover to close.
        self.myPopover.behavior = NSPopoverBehaviorTransient;
        
        // so we can be notified when the popover appears or closes
        self.myPopover.delegate = self;
    }
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
- (BOOL)popoverShouldClose:(NSPopover *)popover
{
	return NO;
}

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
