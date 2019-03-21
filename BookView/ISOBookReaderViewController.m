//
//  ISOCurrentBookViewController.m
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOBookReaderViewController.h"
#import "ISOBookViewController.h"

@implementation ISOBackgroundView
- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor] set];		// this is Cocoa
	NSRectFill(dirtyRect);
}
@end

@implementation ISOBookReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		myToolbar = nil; 
		bookViewController = [[ISOBookViewController alloc] initWithNibName:@"ISOBookViewController" bundle:[NSBundle mainBundle]];
		return self;
	}
	return nil;
}

- (void)setBook:(ISOBook *)aBook
{
	currentBook = aBook;
	[bookViewController setBook:aBook];
}

- (void)resetBook:(ISOBook *)aBook
{
	currentBook = aBook;
	[bookViewController resetBook:aBook];
}

- (void)displayInWindow:(NSWindow *)theWindow
{
	if ([bookViewController.view superview] != self.view) {
		NSRect aRect = [self.view frame];
		[bookViewController.view setFrame:aRect];
		[bookViewController.view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[bookViewController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
		[self.view addSubview:bookViewController.view];
	}
	[super displayInWindow:theWindow];
}

- (void)windowDidResize:(NSNotification *)notification
{
}

@end
