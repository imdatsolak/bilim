//
//  ISOSingleNoteRowView.m
//  xBilim
//
//  Created by Imdat Solak on 11/6/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOSingleNoteRowView.h"

@implementation ISOSingleNoteRowView
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
	
    // Drawing code here.
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect
{
	[super drawBackgroundInRect:dirtyRect];
	[[self viewAtColumn:0] setSelected:NO];
	[[self viewAtColumn:0] display];
}

- (void)drawSelectionInRect:(NSRect)dirtyRect
{
	[[self viewAtColumn:0] setSelected:YES];
	[[self viewAtColumn:0] display];
    // Check the selectionHighlightStyle, in case it was set to None
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        // We want a hard-crisp stroke, and stroking 1 pixel will border half on one side and half on another, so we offset by the 0.5 to handle this
        NSRect selectionRect = NSInsetRect(self.bounds, 5.5, 5.5);
        [[NSColor colorWithCalibratedWhite:.72 alpha:1.0] setStroke];
        [[NSColor colorWithCalibratedWhite:.82 alpha:1.0] setFill];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:10 yRadius:10];
        [selectionPath fill];
        [selectionPath stroke];
    }
}
- (NSBackgroundStyle)interiorBackgroundStyle {
    return NSBackgroundStyleLight;
}


@end


