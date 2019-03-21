//
//  ISOCurrentBookChapterViewController.m
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOCurrentBookChapterViewController.h"

@implementation ISOCBCVVController


@end

@implementation ISOCurrentBookChapterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.detachedWindow.contentView = self.detachedWindowViewController.view;
		self.popoverViewController = [[ISOCBCVVController alloc] initWithNibName:@"CLVPopover" bundle:[NSBundle mainBundle]];
		self.detachedWindowViewController = [[ISOCBCVVController alloc] initWithNibName:@"CLVPopover" bundle:[NSBundle mainBundle]];
		[self.popoverViewController.tableView setDataSource:self];
		[self.detachedWindowViewController.tableView setDataSource:self];
		return self;
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

- (void)showChapters
{
	[self createPopover];
    
    [self.myPopover showRelativeToRect:[self.epubViewController.chapterListButton bounds] ofView:self.epubViewController.chapterListButton preferredEdge:NSMaxYEdge];
	[self.popoverViewController.tableView setDataSource:self];
	[self.popoverViewController.tableView reloadData];

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


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	NSLog(@"SpineArray Count %lu", (unsigned long)[self.epubViewController.loadedEpub.spineArray count]);
    return [self.epubViewController.loadedEpub.spineArray count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return [[self.epubViewController.loadedEpub.spineArray objectAtIndex:rowIndex] title];
}


@end
