//
//  ISOBookCoverView.m
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOBookCoverView.h"
#import "ISOLibraryViewController.h"
#import "ISOMainWindowController.h"

#define ISOALTERNATE_BOOKCOVER @"alternatebookimage"
#define ISOPAPERBOOK_BOOKCOVER @"paperbookimage"

#define ISOIMAGE_FRAME_SIZE 3.0

@implementation ISOIconViewBox

/*
 - (NSView *)hitTest:(NSPoint)aPoint
 {
 NSView *aView = [super hitTest:aPoint];
 if ([aView isKindOfClass:[NSButton class]]) {
 return aView;
 } else if(NSPointInRect(aPoint,[self convertRect:[self bounds] toView:[self superview]])) {
 return self;
 } else {
 return nil;
 }
 }
 */
-(void)mouseDown:(NSEvent *)theEvent
{
	[super mouseDown:theEvent];
	if([theEvent clickCount] > 1) {
		NSLog(@"Mouse Double CLicked");
		[NSApp sendAction:@selector(libraryViewItemDoubleClicked:) to:nil from:self];
	}
}

- (void)setTransparent:(BOOL)flag
{
	[self.imageView setSelected:!flag];
	[super setTransparent:flag];
}

@end

@implementation ISOBookCoverView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	isSelected = NO;
	scalesProportionally = YES;
	alternateImage = [NSImage imageNamed:ISOALTERNATE_BOOKCOVER];
	paperBookImage = [NSImage imageNamed:ISOPAPERBOOK_BOOKCOVER];
    return self;
}

- (void)awakeFromNib
{
	isSelected = NO;
	scalesProportionally = YES;
	alternateImage = [NSImage imageNamed:ISOALTERNATE_BOOKCOVER];
	paperBookImage = [NSImage imageNamed:ISOPAPERBOOK_BOOKCOVER];
}

- (void)setImage:(NSImage *)anImage
{
	image = anImage;
}

- (void)setBackgroundImage:(NSImage *)anImage
{
	backgroundImage = anImage;
}

- (void)drawRect:(NSRect)dirtyRect
{
	NSRect	imageRect;
	BOOL	usingStockCoverImage = NO;
	NSRect	myBounds = [self bounds];
	NSRect	imageShownRect;

	[super drawRect:dirtyRect];
	if (self.value) {
		image = [self.value objectForKey:kBVCover];
		if (image == nil || [image size].width < 5) {
			if (((ISOBook *)[self.value objectForKey:kBVTheBook]).paperBook) {
				image = paperBookImage;
			} else {
				image = alternateImage;
			}
			usingStockCoverImage = YES;
		}
		if (scalesProportionally) {
			NSSize imageSize = [image size];
			NSSize newImageSize;
			NSSize mySize;
			
			mySize = myBounds.size;
			
			mySize.width -= ISOIMAGE_FRAME_SIZE * 2;
			mySize.height -= ISOIMAGE_FRAME_SIZE * 2;
			
			if (imageSize.width > imageSize.height) {
				newImageSize.width = mySize.width;
				newImageSize.height = imageSize.height / (imageSize.width / mySize.width);
			} else {
				newImageSize.height = mySize.height;
				newImageSize.width = imageSize.width / (imageSize.height / mySize.height);
			}
			
			imageRect = NSMakeRect((mySize.width - newImageSize.width)/2, (mySize.height - newImageSize.height)/2, newImageSize.width, newImageSize.height);
			imageRect = NSMakeRect((mySize.width - newImageSize.width)/2, 0 + ISOIMAGE_FRAME_SIZE, newImageSize.width, newImageSize.height);
		} else {
			imageRect = [self bounds];
		}
		[image drawInRect:imageRect];
		imageShownRect = imageRect;
		
		imageRect.origin.x = MAX(0, imageRect.origin.x - ISOIMAGE_FRAME_SIZE);
		imageRect.origin.y = MAX(0, imageRect.origin.y - ISOIMAGE_FRAME_SIZE);
		imageRect.size.width = MIN(myBounds.size.width, imageRect.size.width + ISOIMAGE_FRAME_SIZE * 2);
		imageRect.size.height = MIN(myBounds.size.height, imageRect.size.height + ISOIMAGE_FRAME_SIZE * 2);
		if (isSelected) {
			[[NSColor colorWithRed:0.0 green:0.0 blue:0.6 alpha:1.0] set];
			NSFrameRectWithWidth(imageRect, ISOIMAGE_FRAME_SIZE);
		} else if (drawFrame) {
			[[NSColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0] set];
			NSFrameRectWithWidth(imageRect, ISOIMAGE_FRAME_SIZE);
		} else {
			imageRect = imageShownRect;
			imageRect.size.height = 1;
			
			imageRect.origin.y -= 1;
			imageRect.size.width += 1;
			[[NSColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1] set];
			NSFrameRectWithWidth(imageRect, 1.0);
			
			imageRect.origin.y -= 1;
			imageRect.size.width += 1;
			[[NSColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1] set];
			NSFrameRectWithWidth(imageRect, 1.0);
			
			imageRect.origin.y -= 1;
			imageRect.size.width += 1;
			[[NSColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1] set];
			NSFrameRectWithWidth(imageRect, 1.0);
			
			imageRect = imageShownRect;
			imageRect.origin.x -= 3;
			
			imageRect.size.width = 1;
			imageRect.origin.x += imageShownRect.size.width + 2;
			
			imageRect.origin.x += 1;
			imageRect.origin.y -= 1;
			imageRect.size.height += 1;
			[[NSColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1] set];
			NSFrameRectWithWidth(imageRect, 1.0);
			
			imageRect.origin.x += 1;
			imageRect.origin.y -= 1;
			imageRect.size.height += 1;
			[[NSColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1] set];
			NSFrameRectWithWidth(imageRect, 1.0);
			
			imageRect.origin.x += 1;
			imageRect.origin.y -= 1;
			imageRect.size.height += 1;
			[[NSColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1] set];
			NSFrameRectWithWidth(imageRect, 1.0);
		}
		if (usingStockCoverImage && imageShownRect.size.width > 96) {
			NSRect aRect = imageShownRect;
			CGFloat	fontSize = 12.0;
			
			aRect.origin.x = imageShownRect.origin.x + 15;
			aRect.origin.y = imageShownRect.origin.y + (imageShownRect.size.height - 100);
			aRect.size.width = imageShownRect.size.width - 20;
			aRect.size.height = 75;
			if (aRect.size.width > 128) {
				fontSize = 15.0;
				aRect.origin.y -= 20;
			}
			if (titleField == nil) {
				titleField = [[NSTextField alloc] initWithFrame:aRect];
			} else {
				[titleField setFrame:aRect];
			}
			[titleField setStringValue:[self.value objectForKey:kBVTitle]];
			[titleField setDrawsBackground:NO];
			[titleField setBordered:NO];
			[titleField setBezeled:NO];
			[titleField setAlignment:NSCenterTextAlignment];
			[titleField setFont:[NSFont fontWithName:@"Palatino-Bold" size:fontSize]];
			[titleField setTextColor:[NSColor yellowColor]];
			[titleField setTextColor:[NSColor colorWithRed:1.0 green:1.0/255.0*253.0 blue:1.0/255.0*209.0 alpha:1.0]];
			[titleField setEditable:NO];
			[titleField setSelectable:NO];
			[self addSubview:titleField];
			
			aRect.origin.x = imageShownRect.origin.x + 15;
			aRect.origin.y = imageShownRect.origin.y + 25;
			aRect.size.width = imageShownRect.size.width - 20;
			aRect.size.height = 25;
			fontSize = 11.0;
			if (aRect.size.width > 128) {
				fontSize = 13.0;
				aRect.origin.y += 20;
			}
			if (authorField == nil) {
				authorField = [[NSTextField alloc] initWithFrame:aRect];
			} else {
				[authorField setFrame:aRect];
			}
			[authorField setStringValue:[self.value objectForKey:kBVAuthor]];
			[authorField setDrawsBackground:NO];
			[authorField setBordered:NO];
			[authorField setBezeled:NO];
			[authorField setAlignment:NSCenterTextAlignment];
			[authorField setFont:[NSFont fontWithName:@"Palatino-Bold" size:fontSize]];
			[authorField setTextColor:[NSColor yellowColor]];
			[authorField setTextColor:[NSColor colorWithRed:1.0 green:1.0/255.0*253.0 blue:1.0/255.0*209.0 alpha:1.0]];
			[authorField setEditable:NO];
			[authorField setSelectable:NO];
			[self addSubview:authorField];
			
		}
	}
}

- (void)setSelected:(BOOL)flag
{
	isSelected = flag;
	[self setNeedsDisplay:YES];
}

- (BOOL)isSelected
{
	return isSelected;
}

- (void)setDrawFrame:(BOOL)flag
{
	drawFrame = flag;
}

- (BOOL)drawsFrame
{
	return drawFrame;
}


- (void)setScalesProportionally:(BOOL)flag
{
	scalesProportionally = flag;
}

- (BOOL)isScalesProportionally
{
	return scalesProportionally;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
	[super setValue:value forKey:key];
	[self setNeedsDisplay:YES];
}

- (IBAction)showBookDetails:(id)sender
{
	if (self.bookDetailsView == nil) {
		self.bookDetailsView = [[ISOBookDetailsViewController alloc] initWithNibName:@"BookCoverDetailsWindow" bundle:[NSBundle mainBundle]];
	}
	[self.bookDetailsView showBookDetails:self.value relativeTo:sender];
}

- (IBAction)showBookInfo:(id)sender
{
	
}
@end
