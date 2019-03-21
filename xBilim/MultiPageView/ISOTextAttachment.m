//
//  ISOTextAttachment.m
//  MultiPageTest
//
//  Created by Imdat Solak on 11/2/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOTextAttachment.h"

@implementation ISOTextAttachment

- (id)init
{
	self = [super initImageCell:nil];
	if (self) {
		[self setEnabled:YES];
		return self;
	}
	return nil;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView characterIndex:(NSUInteger)charIndex layoutManager:(NSLayoutManager *)layoutManager
{
	[super drawWithFrame:cellFrame inView:controlView];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)aView characterIndex:(NSUInteger)charIndex
{
	[super drawWithFrame:cellFrame inView:aView];
}

- (NSRect)cellFrameForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(NSRect)lineFrag glyphPosition:(NSPoint)position characterIndex:(NSUInteger)charIndex
{
	NSRect aRect = NSMakeRect(0,0, 256.0, 256.0);
	
	aRect.size = [[self image] size];
	return aRect;
}

- (NSSize)cellSize
{
	return [[self image] size];
}

- (BOOL)wantsToTrackMouse
{
	NSLog(@"Yes, I want!");
	return YES;
}

- (BOOL)wantsToTrackMouseForEvent:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView atCharacterIndex:(NSUInteger)charIndex
{
	NSLog(@"wantsTo...");
	return YES;
	
}
- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)aTextView atCharacterIndex:(NSUInteger)charIndex untilMouseUp:(BOOL)flag
{
	NSLog(@"trackMouse...");
	return [super trackMouse:theEvent inRect:cellFrame ofView:aTextView untilMouseUp:flag];
}

- (NSPoint)cellBaselineOffset
{
	return NSMakePoint(0, 0);
}

- (void)setAttachment:(NSTextAttachment *)anAttachment
{
	NSImage *theImage;
	[super setAttachment:anAttachment];
	
	NSFileWrapper *aWrapper = [[self attachment] fileWrapper];
	NSData *data = [aWrapper regularFileContents];
	NSSize aSize;

	theImage = [[NSImage alloc] initWithData:data];
	aSize = [theImage size];
	if (aSize.width > aSize.height) {
		CGFloat oldW = aSize.width;
		
		aSize.width = 256;
		aSize.height = aSize.height / (oldW / aSize.width);
	} else {
		CGFloat oldH = aSize.height;
		aSize.height = 256;
		aSize.width = aSize.width / (oldH / aSize.height);
	}
	[theImage setSize:aSize];
	[self setImage:theImage];
}

@end
