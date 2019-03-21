//
//  ISOClipView.m
//  xBilim
//
//  Created by Imdat Solak on 11/3/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOMultiPageClipView.h"

@implementation ISOMultiPageClipView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setDelegate:(id)anObject
{
	delegate = anObject;
}

- (id)delegate
{
	return delegate;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	[[NSColor whiteColor] set];
	NSRectFill(dirtyRect);
	
    // Drawing code here.
}

- (void)viewWillStartLiveResize
{
	[super viewWillStartLiveResize];
}

- (void)viewDidEndLiveResize
{
	[super viewDidEndLiveResize];
}

@end
