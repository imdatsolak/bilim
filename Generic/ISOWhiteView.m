//
//  ISOWhiteView.m
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOWhiteView.h"

@implementation ISOWhiteView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	[[NSColor whiteColor] set];
	NSRectFill(dirtyRect);
	
    // Drawing code here.
}

@end
