//
//  ISOBVThemeViewController.h
//  xBilim
//
//  Created by Imdat Solak on 10/30/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOCurrentBookViewController.h"

@class ISOCurrentBookViewController;

@interface ISOBVTVCController : NSViewController
{
	
}
@property IBOutlet NSMatrix *themeSelector;
@property IBOutlet NSMatrix *fontSelector;
@end

@interface ISOBVThemeViewController : NSViewController <NSPopoverDelegate>
{
	
}

@property ISOCurrentBookViewController	*epubViewController;
@property IBOutlet NSWindow *detachedWindow;

@property IBOutlet ISOBVTVCController *popoverViewController;
@property IBOutlet ISOBVTVCController *detachedWindowViewController;


@property NSPopover *myPopover;

- (void)showThemeView;

@end
