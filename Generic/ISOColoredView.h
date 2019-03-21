//
//  ISOColoredView.h
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ISOColoredView : NSView
{
	NSColor *bgColor;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor;

@end
