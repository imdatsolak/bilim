//
//  ISOAppDelegate.m
//  xBilim
//
//  Created by Imdat Solak on 10/18/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOAppDelegate.h"

NSString *ISOApplicationDirectoryUsingPath(NSString *aPath)
{
	
	NSArray			*paths;
    NSString		*basePath;
    NSFileManager	*fm;
	NSError			*theError;

    fm = [NSFileManager defaultManager];
	paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
	if (basePath) {
		NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
		
		basePath = [basePath stringByAppendingString:[NSString stringWithFormat:@"/%@", bundleID]];
		
		if (aPath) {
			basePath = [basePath stringByAppendingString:[NSString stringWithFormat:@"/%@", aPath]];
		}
        if (![fm createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:&theError]) {
            return nil;
        }
	}
    return basePath;
}

@implementation ISOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.mainController = [[ISOMainWindowController alloc] initWithWindowNibName:@"MainWindow"];
	[self.mainController applicationDidFinishLaunching:aNotification];
}

- (void)addBookToLibrary
{

}

- (BOOL)validateMenuItem:(NSMenuItem *)item
{
    return YES;
}

@end
