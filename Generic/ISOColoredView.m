//
//  ISOColoredView.m
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOColoredView.h"

@implementation ISOColoredView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bgColor = [NSColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	[bgColor set];
	NSRectFill(dirtyRect);
    // Drawing code here.
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
	bgColor = backgroundColor;
}

@end
