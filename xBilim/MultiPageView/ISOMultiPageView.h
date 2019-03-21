//
//  ISOMultiPageView.h
//  MultiPageTest
//
//  Created by Imdat Solak on 10/29/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ISOMultiPageView : NSView
{
	NSPrintInfo *printInfo;
    NSColor *lineColor;
    NSColor *marginColor;
    NSUInteger numPages;
    NSTextLayoutOrientation layoutOrientation;
	NSSize	pageSize;
	CGFloat horizontalMargin;
	CGFloat verticalMargin;
	BOOL twoPageMode;
}

- (BOOL)isTwoPageMode;
- (void)recalculatePagesWithSuperViewFrame;
- (void)setNumberOfPages:(NSUInteger)num;
- (NSUInteger)numberOfPages;
- (NSUInteger)shownPage;
- (NSSize)pageSize;
- (NSSize)textSize;
- (NSRect)textRectForPageNumber:(NSUInteger)pageNumber;
- (NSRect)pageRectForPageNumber:(NSUInteger)pageNumber;
- (void)updateFrame;
- (CGFloat)pageSeparatorWidth;
- (void)setPageSize:(NSSize)aSize;
- (void)setPageWidth:(CGFloat)aWidth;
- (void)setLineColor:(NSColor *)aColor;
- (void)setMarginColor:(NSColor *)aColor;
- (NSTextLayoutOrientation)layoutOrientation;
- (void)drawRect:(NSRect)dirtyRect;

- (void)scrollToNextPage;
- (void)scrollToPrevPage;
- (void)scrollToLastPage;

@end
