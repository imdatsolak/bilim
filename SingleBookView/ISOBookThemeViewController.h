//
//  ISOBookThemeViewController.h
//  xBilim
//
//  Created by Imdat Solak on 11/5/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBook.h"

@class ISOBookViewController;
@class ISOBookThemeViewController;

@interface BTVPopover : NSViewController

@property IBOutlet NSMatrix *fontsMatrix;
@property IBOutlet NSSegmentedControl *themeSelector;


@end

@interface ISOBookThemeViewController : NSViewController
{
	ISOBookViewController *owner;
	NSInteger selectedChapter;
}
@property IBOutlet BTVPopover *popoverController;
@property IBOutlet NSWindow *detachedWindow;
@property NSPopover *myPopover;

- (void)displayThemeSelectorRelativeToRect:(NSRect)boundingRect inView:(NSView *)selectedView;
- (void)setOwner:(ISOBookViewController *)anOwner;

- (IBAction)themeSelected:(id)sender;
- (IBAction)fontSelected:(id)sender;
@end
