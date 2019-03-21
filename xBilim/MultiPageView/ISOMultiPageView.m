//
//  ISOMultiPageView.m
//  MultiPageTest
//
//  Created by Imdat Solak on 10/29/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOMultiPageView.h"

#define MAX_SINGLEPAGE_VIEW_WIDTH	595.0
#define MIN_MULTIPAGE_VIEW_WIDTH	900.0
#define MAX_HOR_MARGIN				95.0
#define MIN_MULTIPAGE_HOR_MARGIN	20.0
#define MIN_SINGLEPAGE_HOR_MARGIN	40.0

CGFloat defaultTextPadding(void)
{
    static CGFloat padding = -1;
    if (padding < 0.0) {
        NSTextContainer *container = [[NSTextContainer alloc] init];
        padding = [container lineFragmentPadding];
    }
    return padding;
}

/* Return the text view size appropriate for the NSPrintInfo */

@implementation ISOMultiPageView

- (void)_recalculatePagesWithFrameSize:(NSSize )sSize
{
	NSSize myPageSize = sSize;
	
	if (sSize.width > MIN_MULTIPAGE_VIEW_WIDTH) {
		myPageSize.width = sSize.width / 2;
		horizontalMargin = MAX(myPageSize.width - MAX_SINGLEPAGE_VIEW_WIDTH, MIN_MULTIPAGE_HOR_MARGIN);
		twoPageMode = YES;
	} else {
		horizontalMargin = MAX(MIN_SINGLEPAGE_HOR_MARGIN, (sSize.width - MAX_SINGLEPAGE_VIEW_WIDTH)/2);
		twoPageMode = NO;
	}
	[self setPageSize:myPageSize];
	
}
- (void)recalculatePagesWithSuperViewFrame
{
	NSSize sSize = [[self superview] frame].size;
	[self _recalculatePagesWithFrameSize:sSize];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		twoPageMode = NO;
        numPages = 0;
        [self setLineColor:[NSColor lightGrayColor]];
        [self setMarginColor:[NSColor darkGrayColor]];
		horizontalMargin = 40.0;
		verticalMargin = 0.0;
		[self _recalculatePagesWithFrameSize:frame.size];
		[self updateFrame];
    }
    return self;
}

- (BOOL)isTwoPageMode
{
	return twoPageMode;
}

- (void)setHorizontalMargin:(CGFloat)hMargin andVerticalMargin:(CGFloat)vMargin
{
	horizontalMargin = hMargin;
	verticalMargin = vMargin;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if ([[NSGraphicsContext currentContext] isDrawingToScreen]) {
        NSUInteger firstPage;
        NSUInteger lastPage;
        NSUInteger cnt;
		
		
		firstPage = NSMinX(dirtyRect) / (pageSize.width + [self pageSeparatorWidth]);
		lastPage = NSMaxX(dirtyRect) / (pageSize.width + [self pageSeparatorWidth]);

//		[marginColor set];
		[[NSColor whiteColor] set];
        NSRectFill(dirtyRect);
		/*
        [lineColor set];
        for (cnt = firstPage; cnt <= lastPage; cnt++) {
			// Draw boundary around the page, making sure it doesn't overlap the document area in terms of pixels
			NSRect docRect = NSInsetRect([self centerScanRect:[self textRectForPageNumber:cnt]], -1.0, -1.0);
			NSFrameRectWithWidth(docRect, 1.0);
        }
		*/
        if ([[self superview] isKindOfClass:[NSClipView class]]) {
            NSColor *backgroundColor = [(NSClipView *)[self superview] backgroundColor];
            backgroundColor = [NSColor darkGrayColor];
            for (cnt = firstPage; cnt <= lastPage; cnt++) {
                NSRect pageRect = [self textRectForPageNumber:cnt];
                NSRect separatorRect;
                separatorRect = NSMakeRect(NSMinX(pageRect), NSMaxY(pageRect), NSWidth(pageRect), [self pageSeparatorWidth]);
				NSRectFill (separatorRect);
            }
        }
    }
}

- (void)updateFrame
{
	if ([self superview]) {
		NSRect rect = NSZeroRect;
		
		rect.size = pageSize;
		rect.size.width = rect.size.width * numPages;
		if (numPages > 1) {
			rect.size.width += [self pageSeparatorWidth] * (numPages - 1);
		}
		rect.size = [self convertSize:rect.size toView:[self superview]];
		[self setFrame:rect];
		[self setNeedsDisplay:YES];
    }
}


- (CGFloat)pageSeparatorWidth
{
	return 0.0;
}


- (void)setPageSize:(NSSize)aSize
{
	pageSize = aSize;
}

- (void)setPageWidth:(CGFloat)aWidth
{
	[self setPageSize:NSMakeSize(aWidth, pageSize.height)];
}

- (void)setLineColor:(NSColor *)aColor
{
	lineColor = aColor;
}

- (NSColor *)lineColor {
    return lineColor;
}


- (void)setMarginColor:(NSColor *)aColor
{
	marginColor = aColor;
	
}

- (NSColor *)marginColor
{
    return marginColor;
}

- (void)setNumberOfPages:(NSUInteger)num
{
    if (numPages != num) {
		NSRect oldFrame = [self frame];
        NSRect newFrame;
		
        numPages = num;
        [self updateFrame];
		newFrame = [self frame];
        if (newFrame.size.height > oldFrame.size.height) {
			[self setNeedsDisplayInRect:NSMakeRect(oldFrame.origin.x, NSMaxY(oldFrame), oldFrame.size.width, NSMaxY(newFrame) - NSMaxY(oldFrame))];
        }
    }
}

- (NSUInteger)numberOfPages
{
	return numPages;
}

- (NSUInteger)shownPage
{
	return [self visiblePage];
}

- (NSSize)pageSize
{
	return pageSize;
}

- (NSSize )textSize
{
	NSSize textSize = pageSize;
	
	textSize.width -= horizontalMargin * 2;
	textSize.height -= verticalMargin * 2;
	return textSize;
}

- (NSRect)textRectForPageNumber:(NSUInteger)pageNumber
{
    NSRect rect;
    rect.size = pageSize;
	
	rect.size.width -= horizontalMargin * 2;
	rect.size.height -= verticalMargin * 2;
    rect.origin = [self frame].origin;
	rect.origin.x += ((pageSize.width + [self pageSeparatorWidth]) * pageNumber) + horizontalMargin;
	
    return rect;
}

- (NSRect)pageRectForPageNumber:(NSUInteger)pageNumber
{
    NSRect rect;
    rect.size = pageSize;
    rect.origin = [self frame].origin;
	
	rect.origin.x += ((rect.size.width + [self pageSeparatorWidth]) * pageNumber);
    return rect;
}


/* For locations on the page separator right after a page, returns that page number.  Same for any locations on the empty (gray background) area to the side of a page. Will return 0 or numPages-1 for locations beyond the ends. Results are 0-based.
 */
- (NSUInteger)pageNumberForPoint:(NSPoint)loc
{
    NSUInteger pageNumber;
	if (loc.x < 0) pageNumber = 0;
	else if (loc.x >= [self bounds].size.width) pageNumber = numPages - 1;
	else pageNumber = loc.x / (pageSize.width + [self pageSeparatorWidth]);
	
    return pageNumber;
}

/* This method makes sure that we center the view on the page. By default, the text view "bleeds" into the margins by defaultTextPadding() as a way to provide padding around the editing area. If we don't do anything special, the text view appears at the margin, which causes the text to be offset on the page by defaultTextPadding(). This method makes sure the text is centered.
 */
- (NSPoint)locationOfPrintRect:(NSRect)rect
{
    NSSize paperSize = [printInfo paperSize];
    return NSMakePoint((paperSize.width - rect.size.width) / 2.0, (paperSize.height - rect.size.height) / 2.0);
}

- (NSTextLayoutOrientation)layoutOrientation
{
    return layoutOrientation;
}

- (BOOL)isOpaque {
    return YES;
}

- (NSUInteger)visiblePage
{
	NSRect aRect = [self visibleRect];
	NSUInteger cPage;

	cPage = (double)(aRect.origin.x + (aRect.size.width/2.1)) / pageSize.width;
	cPage = (aRect.origin.x / pageSize.width);
	return cPage;
	
}


- (NSRect)fullPageRectForPageNumber:(NSUInteger)pageNumber
{
    NSRect rect;
    rect.size = pageSize;
    rect.origin = [self frame].origin;
	
	rect.origin.x += ((rect.size.width + [self pageSeparatorWidth]) * pageNumber);
    return rect;
}

- (void)scrollToNextPage
{
	NSUInteger shownPage = [self visiblePage];
	
	NSUInteger pageToShow = shownPage + 1;
	if (shownPage < [self numberOfPages]) {
		if (twoPageMode) {
			pageToShow += 2; 
		}
		if (pageToShow <= [self numberOfPages]) {
			NSRect rectToShow = [self fullPageRectForPageNumber:pageToShow];
			[self scrollRectToVisible:rectToShow];
		}
	}
}

- (void)scrollToPrevPage
{
	NSUInteger shownPage = [self visiblePage];
	int pageToShow = (int)shownPage-1;
	if (shownPage > 0) {
		if (twoPageMode) {
			pageToShow--;
		}
		if (pageToShow <0) {
			pageToShow = 0;
		}
		NSRect rectToShow = [self fullPageRectForPageNumber:pageToShow];
		[self scrollRectToVisible:rectToShow];
	}
}

- (void)scrollToLastPage
{
	NSUInteger pageToShow = [self numberOfPages]-1;
	if (twoPageMode) {
		pageToShow--;
	}
	NSRect rectToShow = [self fullPageRectForPageNumber:pageToShow];
	[self scrollRectToVisible:rectToShow];
}
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@end
