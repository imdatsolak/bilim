//
//  ISOCurrentBookViewController.h
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOMasterViewController.h"
#import "ISOBook.h"
#import "ISOBookViewController.h"

#define kCBVSearchFieldItem			@"CBVSearchFieldItem"
#define kCBVChapterViewItem			@"CBVChapterViewItem"
#define kCBVPagesSlider				@"CBVPagesSlider"
#define kCBVThemesViewItem			@"CBVThemesViewItem"

#define kCBVToolbarID				@"TBToolbarIDCBV"

@interface ISOBackgroundView : NSView
{
	
}
@end

@interface ISOBookReaderViewController : ISOMasterViewController
{
	ISOBookViewController	*bookViewController; // this is the one who does the real work...
	ISOBook					*currentBook;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)resetBook:(ISOBook *)aBook;
- (void)setBook:(ISOBook *)aBook;
- (void)windowDidResize:(NSNotification *)notification;


@end
