//
//  ISOHeaders.h
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#include <AppKit/AppKit.h>
#include <WebKit/WebKit.h>
#include <Foundation/Foundation.h>
#ifndef xBilim_ISOHeaders_h
#define xBilim_ISOHeaders_h

#if TARGET_OS_IPHONE
#define D_ISOWebView	UIWebView
#else
#define D_ISOWebView	WebView
#endif

#define ISOBilimDataChangedNotification	@"BilimDataChangedNotification"


NSString *ISOApplicationDirectoryUsingPath(NSString *aPath);

#define ISOLibraryContentChangedInMemory	@"ISOLibraryContentChangedInMemory"
#endif
@class ISOSingleNote;

@protocol ISONoteOwnerProtocol <NSObject>

- (IBAction)deleteNoteButtonClicked:(id)sender;
- (IBAction)editNoteButtonClicked:(id)sender;

@end

@protocol ISONoteHolderProtocol <NSObject>

- (void)setNote:(ISOSingleNote *)aNote;
- (ISOSingleNote *)note;

@end

