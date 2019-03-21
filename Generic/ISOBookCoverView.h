//
//  ISOBookCoverView.h
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBookDetailsViewController.h"

@class ISOBookDetailsViewController;
@class ISOBookCoverView;

@interface ISOIconViewBox: NSBox
{
}

@property IBOutlet ISOBookCoverView *imageView;

- (void)setTransparent:(BOOL)flag;
@end

@interface ISOBookCoverView : NSView
{
	BOOL isSelected;
	BOOL drawFrame;
	NSImage *image;
	NSImage *backgroundImage;
	NSImage *alternateImage;
	NSImage	*paperBookImage;
	BOOL scalesProportionally;
	NSTextField *titleField;
	NSTextField *authorField;
}

@property id value;
@property id bookTitle;
@property id bookAuthor;
@property ISOBookDetailsViewController *bookDetailsView;

- (void)setSelected:(BOOL)flag;
- (BOOL)isSelected;

- (void)setDrawFrame:(BOOL)flag;
- (BOOL)drawsFrame;

- (void)setScalesProportionally:(BOOL)flag;
- (BOOL)isScalesProportionally;
- (IBAction)showBookDetails:(id)sender;
- (IBAction)showBookInfo:(id)sender;
@end
