//
//  ISOTableHeaderView.m
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOTableHeaderView.h"

@implementation ISOTableHeaderView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
#define BORDER_CORNER_RADIUS    8.0

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	// [[NSColor colorWithRed:1.0/255.0*215.0 green:1.0/255.0*221.0 blue:1.0/255.0*229.0 alpha:1.0] set];
//	NSRectFill(dirtyRect);

   NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:0.0 yRadius:0.0];
//	 NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.8 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:1.0/255.0*227.0 alpha:1.0]];
//	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.8 alpha:1.0] endingColor:[NSColor colorWithRed:1.0/255.0*215.0 green:1.0/255.0*221.0 blue:1.0/255.0*229.0 alpha:1.0]];
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithRed:1.0/255.0*215.0 green:1.0/255.0*221.0 blue:1.0/255.0*229.0 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.8 alpha:1.0]];
    [gradient drawInBezierPath:path angle:90.0];

//	[[NSColor whiteColor] set];
    // Drawing code here.
}

@end
