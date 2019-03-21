//
//  ISOCurrentBookChapterViewController.h
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOCurrentBookViewController.h"

@class ISOCurrentBookViewController;

@interface ISOCBCVVController : NSViewController
{
	
}
@property IBOutlet NSTableView *tableView;
@end

@interface ISOCurrentBookChapterViewController : NSViewController <NSPopoverDelegate, NSTableViewDataSource>
{
}

@property ISOCurrentBookViewController	*epubViewController;

@property NSTableView *tableView;
@property IBOutlet NSWindow *detachedWindow;

@property IBOutlet ISOCBCVVController *popoverViewController;
@property IBOutlet ISOCBCVVController *detachedWindowViewController;

@property NSPopover *myPopover;

- (void)showChapters;


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

@end
