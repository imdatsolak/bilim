//
//  ISOChapterListViewController.h
//  xBilim
//
//  Created by Imdat Solak on 11/5/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBook.h"
#import "ISOBookViewController.h"

@class ISOChapterListViewController;

@interface CLVPopoverController : NSViewController

@property IBOutlet NSTableView *chapterTableView;

@end

@interface ISOChapterListViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
{
	ISOBookViewController *owner;
	NSInteger selectedChapter;
	ISOBook *theBook;
}
@property IBOutlet CLVPopoverController *popoverController;
@property IBOutlet NSWindow *detachedWindow;
@property NSPopover *myPopover;

- (void)displayChaptersOfBook:(ISOBook *)aBook relativeToRect:(NSRect)boundingRect inView:(NSView *)selectedView;
- (NSInteger )selectedChapterNumber;
- (void)setSelectedChapter:(NSInteger)aChapterNumber;
- (void)chapterSelectionChanged;
- (void)setOwner:(ISOBookViewController *)anOwner;
- (IBAction)tableViewDoubleClicked:(id)sender;

@end
