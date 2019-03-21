//
//  ISOBookThemeViewController.m
//  xBilim
//
//  Created by Imdat Solak on 11/5/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOBookThemeViewController.h"
#import "ISOBookViewController.h"

@implementation BTVPopover


@end
@interface ISOBookThemeViewController ()

@end

@implementation ISOBookThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		if (self) {
			self.popoverController = [[BTVPopover alloc] initWithNibName:@"BTVPopover" bundle:[NSBundle mainBundle]];
			return self;
		}
    }
    return self;
}

- (void)displayThemeSelectorRelativeToRect:(NSRect)boundingRect inView:(NSView *)selectedView
{
	[self createPopover];
    [self.myPopover showRelativeToRect:boundingRect ofView:selectedView preferredEdge:NSMinXEdge];
}

- (void)setOwner:(ISOBookViewController *)anOwner
{
	owner = anOwner;
}

- (IBAction)increaseFontSize:(id)sender
{
	
}
- (IBAction)decreaseFontSie:(id)sender
{
	
}
- (IBAction)themeSelected:(id)sender
{
	
}
- (IBAction)fontSelected:(id)sender
{
	
}

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
	return YES;
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
