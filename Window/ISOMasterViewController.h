//
//  ISOMasterViewController.h
//  xBilim
//
//  Created by Imdat Solak on 10/24/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOBook.h"

@class ISOMainWindowController;

@interface ISOMasterViewController : NSViewController <NSToolbarDelegate>
{
	NSSize	viewXibSize;
	BOOL	isWindowFullscreen;
	NSSize	lastViewSize;
	NSToolbar *myToolbar;
	NSWindow *displayingWindow;
}

@property ISOMainWindowController *mainController;


- (void)displayInWindow:(NSWindow *)theWindow;
- (void)removeFromCurrentWindow;
- (void)setIsFullscreen:(BOOL)flag;
- (void)rememberViewSize;



- (NSToolbarItem *)toolbarItemWithIdentifier:(NSString *)identifier label:(NSString *)label paleteLabel:(NSString *)paletteLabel toolTip:(NSString *)toolTip itemContent:(id)imageOrView menu:(NSMenu *)menu;
- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem;
- (void)toolbarWillAddItem:(NSNotification *)notif;
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
- (NSToolbar *)toolbar;

- (void)windowDidResize:(NSNotification *)theWindow;
- (ISOBook *)selectedBook;

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem;

//
- (IBAction)addPaperBook:(id)sender;
- (void)paperBookAdded:(ISOBook *)paperBook;
- (void)paperBookChanged:(ISOBook *)paperBook;
@end
