//
//  ISOMasterViewController.m
//  xBilim
//
//  Created by Imdat Solak on 10/24/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOMasterViewController.h"
#import "ISOHeaders.h"

@implementation ISOMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		isWindowFullscreen = NO;
		lastViewSize.width = 0;
		lastViewSize.height = 0;
		viewXibSize = [self.view frame].size;
		myToolbar = nil;
		return self;
	}
	return nil;
}


- (void)displayInWindow:(NSWindow *)theWindow
{

	NSRect			windowRect;
	NSSize			viewSize;
	NSRect			windowFrameRect;
	NSPoint			oldPos;
	NSSize			windowOldSize;
	NSView			*mainView;
	NSDictionary	*views;
	NSView			*contentView;
	
	
	contentView = [theWindow contentView];
	if ([self.view superview] != nil) {
		[self.view removeFromSuperview];
	}
	

	// First recalculate the new window/window-contentView size
	windowRect = [contentView frame];
	if (!isWindowFullscreen) {
		if (lastViewSize.width > 5.0) {
			NSLog(@"Somehow it is not FullScreen...");
			viewSize = lastViewSize;
		} else {
			viewSize = [self.view frame].size;
		}
		if ((viewSize.width > windowRect.size.width) || (viewSize.height > windowRect.size.height)) {
			windowRect.size.width = MAX(viewSize.width, windowRect.size.width);
			windowRect.size.height = MAX(viewSize.height, windowRect.size.height);
		} else {
			windowRect.size = viewSize; // doesn't support full-screen mode
		}
		lastViewSize = windowRect.size;
	} else {
		
	}

	// But we don't want the window to reposition itself, as the user thinks "top-down" and the system calculates "bottom-up"
	oldPos = [theWindow frame].origin;
	windowOldSize = [contentView frame].size;
	windowFrameRect = [theWindow frameRectForContentRect:windowRect];
	windowFrameRect.origin = oldPos;
	if (windowRect.size.height < windowOldSize.height) {
		windowFrameRect.origin.y += (windowOldSize.height - windowRect.size.height);
	} else if (windowRect.size.height > windowOldSize.height) {
		windowFrameRect.origin.y -= (windowRect.size.height - windowOldSize.height);
	}
	
	// Now set the new contentView size
//	[theWindow setFrame:windowFrameRect display:YES animate:YES];

	// Reposition the stupid window
	windowRect = [contentView frame];
	windowRect.origin.x = 0;
	windowRect.origin.y = 0;
//	[self.view setFrame:windowRect];
	[contentView addSubview:self.view];
	

	// And now, ladies & gents, Apple's most stupid invention: constraints...
	// The only thing I want is that my new view is always scaled to full window size
	// *sigh*

	mainView = self.view;
	[mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
	views = NSDictionaryOfVariableBindings(mainView);
	[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mainView]|" options:0 metrics:nil views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mainView]|" options:0 metrics:nil views:views]];

	[contentView addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
															   toItem:contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	[contentView addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
															   toItem:contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];

	
	// Set the windows minimum size. It's equal to the view's own Xib-size
	[self.view setFrame:windowRect];
	[theWindow setMinSize:viewXibSize];
	[theWindow enableFlushWindow];
	[theWindow setFrame:windowFrameRect display:YES animate:YES];
	[theWindow display]; // Send a display to the window to reflect all changes to Window and my view...
	displayingWindow = theWindow;
}

- (void)removeFromCurrentWindow
{
	if (!isWindowFullscreen) {
		lastViewSize = [self.view frame].size;
	}
	[self.view removeFromSuperview];
}

- (void)setIsFullscreen:(BOOL)flag
{
	isWindowFullscreen = flag;
}

- (void)rememberViewSize
{
	if (!isWindowFullscreen) {
		lastViewSize = [self.view frame].size;
	}
}



/* ********************************************************************************************
 * Toolbar Delegate Methods
 * ********************************************************************************************
 */
- (NSToolbarItem *)toolbarItemWithIdentifier:(NSString *)identifier label:(NSString *)label paleteLabel:(NSString *)paletteLabel toolTip:(NSString *)toolTip itemContent:(id)imageOrView menu:(NSMenu *)menu
{
    // here we create the NSToolbarItem and setup its attributes in line with the parameters
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
    
    [item setLabel:label];
    [item setPaletteLabel:paletteLabel];
    [item setToolTip:toolTip];
    
    // Set the right attribute, depending on if we were given an image or a view
    if([imageOrView isKindOfClass:[NSImage class]]){
        [item setImage:imageOrView];
    } else if ([imageOrView isKindOfClass:[NSView class]]){
        [item setView:imageOrView];
    }else {
        assert(!"Invalid itemContent: object");
    }
    
    
    // If this NSToolbarItem is supposed to have a menu "form representation" associated with it
    // (for text-only mode), we set it up here.  Actually, you have to hand an NSMenuItem
    // (not a complete NSMenu) to the toolbar item, so we create a dummy NSMenuItem that has our real
    // menu as a submenu.
    //
    if (menu != nil) {
        // we actually need an NSMenuItem here, so we construct one
        NSMenuItem *mItem = [[NSMenuItem alloc] init];
        [mItem setSubmenu:menu];
        [mItem setTitle:label];
        [item setMenuFormRepresentation:mItem];
    }
    
    return item;
}

//--------------------------------------------------------------------------------------------------
// We don't do anything useful here (and we don't really have to implement this method) but you could
// if you wanted to. If, however, you want to have validation checks on your standard NSToolbarItems
// (with images) and have inactive ones grayed out, then this is the method for you.
// It isn't called for custom NSToolbarItems (with custom views); you'd have to override -validate:
// (see NSToolbarItem.h for a discussion) to get it to do so if you wanted it to.
// If you don't implement this method, the NSToolbarItems are enabled by default.
//--------------------------------------------------------------------------------------------------
- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
    // You could check [theItem itemIdentifier] here and take appropriate action if you wanted to
    return YES;
}


#pragma mark -
#pragma mark NSToolbarDelegate

//--------------------------------------------------------------------------------------------------
// This is an optional delegate method, called when a new item is about to be added to the toolbar.
// This is a good spot to set up initial state information for toolbar items, particularly ones
// that you don't directly control yourself (like with NSToolbarPrintItemIdentifier here).
// The notification's object is the toolbar, and the @"item" key in the userInfo is the toolbar item
// being added.
//--------------------------------------------------------------------------------------------------
- (void)toolbarWillAddItem:(NSNotification *)notif
{
    NSToolbarItem *addedItem = [[notif userInfo] objectForKey:@"item"];
    
    // Is this the printing toolbar item?  If so, then we want to redirect it's action to ourselves
    // so we can handle the printing properly; hence, we give it a new target.
    //
    if ([[addedItem itemIdentifier] isEqual: NSToolbarPrintItemIdentifier])
    {
        [addedItem setToolTip:@"Print your document"];
        [addedItem setTarget:self];
    }
}

//--------------------------------------------------------------------------------------------------
// This method is required of NSToolbar delegates.
// It takes an identifier, and returns the matching NSToolbarItem. It also takes a parameter telling
// whether this toolbar item is going into an actual toolbar, or whether it's going to be displayed
// in a customization palette.
//--------------------------------------------------------------------------------------------------
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	return nil;
}

//--------------------------------------------------------------------------------------------------
// This method is required of NSToolbar delegates.  It returns an array holding identifiers for the default
// set of toolbar items.  It can also be called by the customization palette to display the default toolbar.
//--------------------------------------------------------------------------------------------------
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return nil;
	
	/* [NSArray arrayWithObjects:   kFontStyleToolbarItemID,
			kFontSizeToolbarItemID,
			kBlueLetterToolbarItemID,
			NSToolbarPrintItemIdentifier,
			nil];
	*/
    // note:
    // that since our toolbar is defined from Interface Builder, an additional separator and customize
    // toolbar items will be automatically added to the "default" list of items.
}

//--------------------------------------------------------------------------------------------------
// This method is required of NSToolbar delegates.  It returns an array holding identifiers for all allowed
// toolbar items in this toolbar.  Any not listed here will not be available in the customization palette.
//--------------------------------------------------------------------------------------------------
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return nil;
	/* [NSArray arrayWithObjects:   kFontStyleToolbarItemID,
			kFontSizeToolbarItemID,
			kBlueLetterToolbarItemID,
			NSToolbarSpaceItemIdentifier,
			NSToolbarFlexibleSpaceItemIdentifier,
			NSToolbarPrintItemIdentifier,
			nil]; 
	 */
    // note:
    // that since our toolbar is defined from Interface Builder, an additional separator and customize
    // toolbar items will be automatically added to the "default" list of items.
}

- (NSToolbar *)toolbar
{
	return myToolbar;
}

- (void)windowDidResize:(NSNotification *)theWindow
{

}

- (ISOBook *)selectedBook
{
	return nil;
}

// User Interface Validation
- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
	return NO;
}

- (IBAction)addPaperBook:(id)sender
{
	
}

- (void)paperBookAdded:(ISOBook *)paperBook
{
	
}
- (void)paperBookChanged:(ISOBook *)paperBook
{
	
}

@end
