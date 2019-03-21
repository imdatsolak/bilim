//
//  ISOAppDelegate.h
//  xBilim
//
//  Created by Imdat Solak on 10/18/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOMainWindowController.h"


@interface ISOAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property IBOutlet ISOMainWindowController *mainController;

@end
