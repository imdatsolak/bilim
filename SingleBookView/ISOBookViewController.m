//
//  ISOBookViewController.m
//  xBilim
//
//  Created by Imdat Solak on 11/2/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOBookViewController.h"
#import "ISOMultiPageView.h"
#import "ISOMultiPageClipView.h"
#import "ISOTextAttachment.h"
#import "ISOSingleNoteEditController.h"
#import "ISOChapterListViewController.h"
#import "ISONotesListViewController.h"

@interface ISOBookViewController ()

@end

@implementation ISOBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentChapterNumber = 0;
		selectedTextRange = NSMakeRange(0, 0);
		bookProjectChapterNumber = NSIntegerMax;
		highlightNotes = YES;
		showNotes = NO;
    }
    return self;
}

- (void)setBook:(ISOBook *)aBook
{
	currentBook = aBook;
	if (currentBook) {
		bookProjectChapterNumber = NSIntegerMax;
		[self.bookTitleField setStringValue:[currentBook bookTitle]];
		[self _initialSetupForNewBook];
	}
}

- (void)resetBook:(ISOBook *)aBook
{
	if (currentBook == nil) {
		[self setBook:aBook];
	} else {
		bookProjectChapterNumber = NSIntegerMax;
		currentBook = aBook;
		[self.bookTitleField setStringValue:[currentBook bookTitle]];
		[self.progressIndicator setMinValue:0];
		[self.progressIndicator setMaxValue:[currentBook numberOfChapters]];
		currentChapterNumber = [currentBook bookLastReadChapter];
		[self.progressIndicator setIntegerValue:currentChapterNumber];
		[self _showText];
	}
}

- (ISOBook *)currentBook
{
	return currentBook;
}

- (void)setBookProject:(ISOProject *)aProject
{
	bookProject = aProject;
}

- (ISOProject *)bookProject
{
	return bookProject;
}

- (void)setBookProjectChapterNumber:(NSInteger)aNumber
{
	bookProjectChapterNumber = aNumber;
}

- (NSInteger)bookProjectChapterNumber
{
	return bookProjectChapterNumber;
}

/* *************************************************************
 *
 * MULTIPAGE SUPPORT
 *
 * *************************************************************
 */
- (void)_initialSetupForNewBook
{
	NSRect frame = [clipView frame];
	ISOMultiPageView *pagesView = [[ISOMultiPageView alloc] initWithFrame:frame];
	
	[clipView setDocumentView:pagesView];
	[self.progressIndicator setMinValue:0];
	[self.progressIndicator setMaxValue:[currentBook numberOfChapters]];
	currentChapterNumber = [currentBook bookLastReadChapter];
	[self.progressIndicator setIntegerValue:currentChapterNumber];
	[self _showText];

}

- (void)_showText
{
	NSTextStorage *loadedText;
	NSString *chapterFilename;
	NSDictionary *currentChapter;

	[self _cleanUpDisplay];
	layoutMgr = [[NSLayoutManager alloc] init];
	[layoutMgr setDelegate:self];
	[layoutMgr setAllowsNonContiguousLayout:YES];
    [layoutMgr setUsesScreenFonts:NO];
	currentChapter = [currentBook chapterWithIndex:currentChapterNumber];
	chapterFilename = [[currentChapter allKeys] objectAtIndex:0];
	loadedText = [[NSTextStorage alloc] initWithURL:[NSURL fileURLWithPath:chapterFilename isDirectory:NO] documentAttributes:NULL];
	[loadedText addLayoutManager:layoutMgr];
	currentChapterText = loadedText;
	[self _applyDefaultTextAttributesForText:loadedText];
	[self _setupViewWithMultiplePages];
	if (showNotes) {
		[notesViewController setBook:currentBook]; // this is where it gets its notes from
		[notesViewController setCurrentChapterNo:currentChapterNumber];
		[notesViewController setCurrentPage:0];
		[notesViewController reflectChangesInNotesDisplay];
	}

}

- (void)_cleanUpDisplay
{
	NSArray *containers = [[self layoutManager] textContainers];
	NSUInteger numContainers = [containers count];
	
	while (numContainers--) {
		[self removePage];
	}
	
}
- (void)_applyDefaultTextAttributesForText:(NSTextStorage *)text
{
	[text beginEditing];
	[text enumerateAttributesInRange:NSMakeRange(0, [text length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		NSFont *aFont = [attrs objectForKey:NSFontAttributeName];
		NSMutableDictionary * newAttrs = [NSMutableDictionary dictionaryWithDictionary:attrs];
		NSParagraphStyle *aStyle = [newAttrs objectForKey:NSParagraphStyleAttributeName];
		NSMutableParagraphStyle *newStyle = [[NSMutableParagraphStyle alloc] init];
		NSInteger hl = [aStyle headerLevel];
		
		[newStyle setParagraphStyle:aStyle];
		if (aFont) {
			NSFontDescriptor *fDesc = [aFont fontDescriptor];
			NSFontSymbolicTraits fTrait = [fDesc symbolicTraits];
			NSString *fontName = @"Palatino";
			CGFloat fontSize = 14.0;
			
			if (hl>0) {
				aFont = [NSFont fontWithName:@"Palatino-Bold" size:16.0 + (12-(hl*2))];
				// NSLog(@"Chapter at Pos: {%lu->%lu} {%@}", range.location, range.length,  [[text attributedSubstringFromRange:range] string]);
			} else {
				if (fTrait & NSFontItalicTrait) {
					fontName = @"Palatino-Italic";
				} else if (fTrait & NSFontBoldTrait) {
					fontName = @"Palatino-Bold";
				} else {
				}
				if ((NSInteger)[attrs objectForKey:NSSuperscriptAttributeName]) {
					fontSize = 9.0;
				}
				aFont = [NSFont fontWithName:fontName size:fontSize];
			}
		}
		if (hl == 0) {
			if ([newStyle firstLineHeadIndent] == 0) {
				[newStyle setFirstLineHeadIndent:12.0];
			}
			[newStyle setParagraphSpacing:6.0];
			[newStyle setParagraphSpacingBefore:0.0];
		}
		if (([aStyle alignment] == NSLeftTextAlignment) || ([aStyle alignment] == NSNaturalTextAlignment)){
			[newStyle setAlignment:NSJustifiedTextAlignment];
		}
		//		[newStyle setLineSpacing:3.0];
		if (aFont) {
			[newAttrs setObject:aFont forKey:NSFontAttributeName];
		}
		[newAttrs setObject:newStyle forKey:NSParagraphStyleAttributeName];
		NSTextAttachment *att = [attrs objectForKey:NSAttachmentAttributeName];
		if (att) {
			[att setAttachmentCell:[[ISOTextAttachment alloc] init]];
		}
		[text setAttributes:newAttrs range:range];
	}];
	[self _reflectAllNotesInText];
	[text endEditing];
}

/*
 NSString *NSFontAttributeName;
 NSString *NSParagraphStyleAttributeName;
 NSString *NSForegroundColorAttributeName;
 NSString *NSUnderlineStyleAttributeName;
 NSString *NSSuperscriptAttributeName;
 NSString *NSBackgroundColorAttributeName;
 NSString *NSAttachmentAttributeName;
 NSString *NSLigatureAttributeName;
 NSString *NSBaselineOffsetAttributeName;
 NSString *NSKernAttributeName;
 NSString *NSLinkAttributeName;
 NSString *NSStrokeWidthAttributeName;
 NSString *NSStrokeColorAttributeName;
 NSString *NSUnderlineColorAttributeName;
 NSString *NSStrikethroughStyleAttributeName;
 NSString *NSStrikethroughColorAttributeName;
 NSString *NSShadowAttributeName;
 NSString *NSObliquenessAttributeName;
 NSString *NSExpansionAttributeName;
 NSString *NSCursorAttributeName;
 NSString *NSToolTipAttributeName;
 NSString *NSMarkedClauseSegmentAttributeName;
 NSString *NSWritingDirectionAttributeName;
 NSString *NSVerticalGlyphFormAttributeName;
 NSString *NSTextAlternativesAttributeName;
 */

- (void)setHighlightNotes:(BOOL)flag
{
	highlightNotes = flag;
}

- (BOOL)isHighlightNotes
{
	return highlightNotes;
}

- (void)_addAttributeForNote:(ISOSingleNote *)singleNote
{
	NSColor *tagColor = [singleNote noteTagAsColor];
	NSRange noteRange = [singleNote noteLocation];
	
	if (highlightNotes) {
		if (tagColor) {
			if (hideControls || !showNotes) {
				tagColor = [tagColor highlightWithLevel:0.9];
			} else {
				tagColor = [tagColor highlightWithLevel:0.7];
			}
			[currentChapterText addAttribute:NSBackgroundColorAttributeName value:tagColor range:noteRange];
		} else {
			NSNumber *underlineStyle = [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle];
			
			[currentChapterText addAttribute:NSUnderlineStyleAttributeName value:underlineStyle range:noteRange];
			[currentChapterText addAttribute:NSUnderlineColorAttributeName value:[NSColor orangeColor] range:noteRange];
		}
	}
}

- (void)_removeAttributesForNote:(ISOSingleNote *)singleNote
{
	NSRange noteRange = [(ISOSingleNote *)singleNote noteLocation];

	[currentChapterText beginEditing];
	[currentChapterText removeAttribute:NSBackgroundColorAttributeName range:noteRange];
	[currentChapterText removeAttribute:NSUnderlineStyleAttributeName range:noteRange];
	[currentChapterText removeAttribute:NSUnderlineColorAttributeName range:noteRange];
	[currentChapterText endEditing];
	
}


- (void)_reflectSingleNoteInText:(ISOSingleNote *)singleNote
{
	[self _addAttributeForNote:singleNote];
}

- (void)_reflectAllNotesInText
{
	int i;
	
	NSArray *chapterNotes = [currentBook notesForChapterNumber:currentChapterNumber];
	for (i=0;i<[chapterNotes count];i++) {
		ISOSingleNote *aNote = [chapterNotes objectAtIndex:i];
		[self _reflectSingleNoteInText:aNote];
	}

}

- (NSLayoutManager *)layoutManager
{
	return layoutMgr;
}

- (NSTextView *)firstTextView
{
    return [[self layoutManager] firstTextView];
}

- (void)_updateTextViewGeometry
{
    ISOMultiPageView *pagesView = [clipView documentView];
//	[currentChapterText beginEditing];
    [[[self layoutManager] textContainers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj textView] setFrame:[pagesView textRectForPageNumber:idx]];
    }];
//	[currentChapterText endEditing];
}

- (NSUInteger)numberOfPages
{
    return [[clipView documentView] numberOfPages];
}

- (void)addPage
{
    NSUInteger numberOfPages = [self numberOfPages];
    ISOMultiPageView *pagesView = [clipView documentView];
    
    NSSize textSize = [pagesView textSize];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:textSize];
    NSTextView *textView;
	
    [textContainer setWidthTracksTextView:YES];
    [textContainer setHeightTracksTextView:YES];
    [[self layoutManager] addTextContainer:textContainer];
	
    [pagesView setNumberOfPages:numberOfPages + 1];
	
    textView = [[NSTextView alloc] initWithFrame:[pagesView textRectForPageNumber:numberOfPages] textContainer:textContainer];
	[textView setEditable:NO];
	[textView setSelectable:YES];
	[textView setImportsGraphics:YES];
	//    [textView setLayoutOrientation:NSTextLayoutOrientationHorizontal];
    [textView setHorizontallyResizable:NO];
    [textView setVerticallyResizable:YES];
	[textView setDelegate:self];
	//	[textView setBackgroundColor:[NSColor whiteColor]];
	
    [pagesView addSubview:textView];
//	[textView setMenu:[textMenu copy]];
	[textView setContinuousSpellCheckingEnabled:NO];
    [textView setGrammarCheckingEnabled:NO];
    [textView setAutomaticSpellingCorrectionEnabled:NO];
    [textView setSmartInsertDeleteEnabled:NO];
    [textView setAutomaticQuoteSubstitutionEnabled:NO];
    [textView setAutomaticDashSubstitutionEnabled:NO];
    [textView setAutomaticLinkDetectionEnabled:NO];
    [textView setAutomaticDataDetectionEnabled:NO];
    [textView setAutomaticTextReplacementEnabled:NO];
	[textView setMenu:nil];

	// [scrollRectToVisible...]
	
}

- (void)removePage
{
    NSUInteger numberOfPages = [self numberOfPages];
    NSArray *textContainers = [[self layoutManager] textContainers];
    NSTextContainer *lastContainer = [textContainers objectAtIndex:[textContainers count] - 1];
    ISOMultiPageView *pagesView = [clipView documentView];
    
    [pagesView setNumberOfPages:numberOfPages - 1];
    [[self layoutManager] removeTextContainerAtIndex:[textContainers count] - 1];
    [[lastContainer textView] removeFromSuperview];
}

- (NSView *)documentView
{
    return [clipView documentView];
}

- (void)_setupViewWithMultiplePages
{
	NSTextView *textView = [self firstTextView];
	ISOMultiPageView *pagesView = [clipView documentView];
    
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:[clipView window]];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidExitFullScreen:) name:NSWindowDidEnterFullScreenNotification object:[clipView window]];
	
	[clipView setDocumentView:pagesView];
	[pagesView updateFrame];
	// Add the first new page before we remove the old container so we can avoid losing all the shared text view state.
	[self addPage];
	if (textView) {
		[[self layoutManager] removeTextContainerAtIndex:0];
	}
	
	[self _updateTextViewGeometry];
	
	//	[clipView setHasVerticalScroller:NO];
	//	[clipView setHasHorizontalScroller:YES];
	
	// Make sure the selected text is shown
	[[self firstTextView] scrollRangeToVisible:[[self firstTextView] selectedRange]];
	
	NSRect visRect = [pagesView visibleRect];
	NSRect pageRect = [pagesView pageRectForPageNumber:0];
	if (visRect.size.width < pageRect.size.width) {	// If we can't show the whole page, tweak a little further
		NSRect docRect = [pagesView textRectForPageNumber:0];
		if (visRect.size.width >= docRect.size.width) {	// Center document area in window
			visRect.origin.x = docRect.origin.x - floor((visRect.size.width - docRect.size.width) / 2);
			if (visRect.origin.x < pageRect.origin.x) visRect.origin.x = pageRect.origin.x;
		} else {	// If we can't show the document area, then show left edge of document area (w/out margins)
			visRect.origin.x = docRect.origin.x;
		}
		[pagesView scrollRectToVisible:visRect];
	}
	
	//    [clipView setHasHorizontalRuler:YES];
	//    [clipView setHasVerticalRuler:NO];
	//	[clipView setHorizontalLineScroll:[pagesView pageSize].width];
	
    [[clipView window] makeFirstResponder:[self firstTextView]];
    [[clipView window] setInitialFirstResponder:[self firstTextView]];	// So focus won't be stolen (2934918)
	[pagesView setNeedsDisplay:YES];	/* Because the page size or margins might change (could optimize this) */
}


- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag
{
	NSArray *containers = [layoutManager textContainers];
	
	if (!layoutFinishedFlag || (textContainer == nil)) {
		NSTextContainer *lastContainer = [containers lastObject];
		if ((textContainer == lastContainer) || (textContainer == nil)) {
			[self addPage];
		}
	} else {
		NSUInteger lastUsedContainerIndex = [containers indexOfObjectIdenticalTo:textContainer];
		NSUInteger numContainers = [containers count];
		
		while (++lastUsedContainerIndex < numContainers) {
			[self removePage];
		}
		[self updatePagesField];
		
	}
}


- (void)updatePagesField
{
	ISOMultiPageView *view = [clipView documentView];
	NSUInteger	shownPage = [view shownPage]+1;  // internally, we count from 0 :-)
	NSUInteger	numPages = [view numberOfPages];
	NSString	*pageInfoString;
	
	if ([view isTwoPageMode]) {
		pageInfoString = [NSString stringWithFormat:@"%lu-%lu/%lu", shownPage, shownPage+1, numPages];
	} else {
		pageInfoString = [NSString stringWithFormat:@"%lu/%lu", shownPage, numPages];
	}
	[self.pagesTextField setStringValue:pageInfoString];
}


- (IBAction)chaptersButtonClicked:(id)sender
{
	NSRect aRect = [sender bounds];
	
	if (chapterViewController == nil) {
		chapterViewController = [[ISOChapterListViewController alloc] initWithNibName:@"ISOChapterListViewController" bundle:[NSBundle mainBundle]];
		[chapterViewController setOwner:self];
	}
	[chapterViewController displayChaptersOfBook:currentBook relativeToRect:aRect inView:sender];
}

- (IBAction)notesButtonClicked:(id)sender
{
	NSRect aRect = [sender bounds];
	
	if (notesListViewController == nil) {
		notesListViewController = [[ISONotesListViewController alloc] initWithNibName:@"ISONotesListViewController" bundle:[NSBundle mainBundle]];
		[notesListViewController setOwner:self];
	}
	[notesListViewController displayNotesOfBook:currentBook relativeToRect:aRect inView:sender withCurrentChapter:currentChapterNumber];

}

- (IBAction)themesButtonClicked:(id)sender
{
	NSRect aRect = [sender bounds];
	
	if (themeViewControler == nil) {
		themeViewControler = [[ISOBookThemeViewController alloc] initWithNibName:@"ISOBookThemeViewController" bundle:[NSBundle mainBundle]];
		[themeViewControler setOwner:self];
	}
	[themeViewControler displayThemeSelectorRelativeToRect:aRect inView:sender];
}

- (void)goToChapterNumber:(NSInteger )chapterNumber andPage:(NSInteger)pageNumber
{
	ISOMultiPageView *mpView = [clipView documentView];

	currentChapterNumber = chapterNumber;	
	[self _showText];
	if (pageNumber == NSIntegerMax) {
		[mpView scrollToLastPage];
		[currentBook setLastReadPage:(int)[mpView shownPage] inChapter:(int)currentChapterNumber];
	} else {
		[currentBook setLastReadPage:(int)pageNumber inChapter:(int)currentChapterNumber];
	}
	[self.progressIndicator setIntegerValue:currentChapterNumber];
	[self updatePagesField];
	[notesViewController setCurrentChapterNo:currentChapterNumber];
	[notesViewController setCurrentPage:[mpView shownPage]];
	[notesViewController reflectChangesInNotesDisplay];

}

- (IBAction)prevPageButtonClicked:(id)sender
{
	ISOMultiPageView *mpView = [clipView documentView];
	NSUInteger shownPage = [mpView shownPage];

	if (shownPage > 0) {
		[[clipView documentView] scrollToPrevPage];
		[self updatePagesField];
		[notesViewController setCurrentPage:shownPage-1];
		[notesViewController reflectChangesInNotesDisplay];
	} else {
		if (currentChapterNumber>0) {
			currentChapterNumber--;
			[self goToChapterNumber:currentChapterNumber andPage:NSIntegerMax];
			/*
			[self _showText];
			[mpView scrollToLastPage];
			[currentBook setLastReadPage:(int)[mpView shownPage] inChapter:(int)currentChapterNumber];
			[self.progressIndicator setIntegerValue:currentChapterNumber];
			[self updatePagesField];
			[notesViewController setCurrentChapterNo:currentChapterNumber];
			[notesViewController setCurrentPage:[mpView shownPage]];
			[notesViewController reflectChangesInNotesDisplay];
			 */
		} else {
			NSBeep();
		}
	}
}

- (IBAction)nextPageButtonClicked:(id)sender
{
	ISOMultiPageView *mpView = [clipView documentView];
	NSUInteger shownPage = [mpView shownPage];
	NSUInteger numPages = [mpView numberOfPages];
	
	if ([mpView isTwoPageMode]) {
		numPages--;
	}
	if (shownPage+1 < numPages) {
		[[clipView documentView] scrollToNextPage];
		[self updatePagesField];
		[notesViewController setCurrentPage:shownPage+1];
		[notesViewController reflectChangesInNotesDisplay];
	} else {
		if ([currentBook numberOfChapters] > currentChapterNumber+1) {
			currentChapterNumber++;
			[self goToChapterNumber:currentChapterNumber andPage:1];
			/*
			[self _showText];
			[currentBook setLastReadPage:1 inChapter:(int)currentChapterNumber];
			[self.progressIndicator setIntegerValue:currentChapterNumber];
			[self updatePagesField];
			[notesViewController setCurrentChapterNo:currentChapterNumber];
			[notesViewController setCurrentPage:[mpView shownPage]];
			[notesViewController reflectChangesInNotesDisplay];
			 */
		} else {
			NSBeep();
		}
	}
}

- (void)setHideControls:(BOOL)flag
{
	hideControls = flag;
}

- (BOOL)isHideControls
{
	return hideControls;
}

- (void)setShowNotes:(BOOL)flag replacingView:(NSView *)aView
{
	showNotes = flag;
	if (showNotes) {
		NSRect aRect;
		if (notesViewController == nil) {
			notesViewController = [[ISONotesViewController alloc] initWithNibName:@"ISONotesViewController" bundle:[NSBundle mainBundle]];
			[notesViewController setOwner:self];
		}
		[notesViewController setHideNotes:NO];
		if (aView != nil) {
			aRect = [aView frame];
			[notesViewController.view setFrame:aRect];
			
			[notesViewController.view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
			[notesViewController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
			[[aView superview] replaceSubview:aView with:notesViewController.view];
		}
	} else if (!showNotes) {
		[notesViewController hideNotes];
	}
}

- (BOOL)isShowNotes
{
	return showNotes;
}

- (void)noteSelectionChangedToNote:(ISOSingleNote *)aNote
{
	
}

- (NSLayoutManager *)currentLayoutManager
{
	return currentLayoutMgr;
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex
{
	NSLog(@"clicked on link: %@", link);
	return YES;
}

- (void)doIt:(id)sender
{
	NSLog(@"DOIT");
}


// --------------------------------------------------------------------
- (void)isoMultiPageClipView:(ISOMultiPageClipView *)aView sizeDidChange:(BOOL)flag
{
}

- (void)adjustPagesToNewViewSize
{
	ISOMultiPageView *pagesView = [clipView documentView];
	[[clipView window] disableFlushWindow];
	[pagesView recalculatePagesWithSuperViewFrame];
	[self _updateTextViewGeometry];
	[[clipView window] enableFlushWindow];
	[notesViewController reflectChangesInNotesDisplay];
}


- (void)windowDidResize:(id)aObj
{
	[self adjustPagesToNewViewSize];
}

- (IBAction)copyAsCitation:(id)sender
{
	[NSApp sendAction:@selector(copy:) to:nil from:sender];
}

- (void)noteAdded:(id)aNote
{
	if (aNote && [aNote isKindOfClass:[ISOSingleNote class]]) {
		[currentChapterText beginEditing];
		[self _reflectSingleNoteInText:(ISOSingleNote *)aNote];
		[currentChapterText endEditing];
		[currentBook addNote:aNote]; // this is ok as if the note already exists, it's not added again.
		[notesViewController reflectChangesInNotesDisplay];
	}
}

- (IBAction)deleteNoteButtonClicked:(id)sender
{
	if ([sender respondsToSelector:@selector(note)]) {
//		ISOSingleNote *aNote = (ISOSingleNote *)[sender note];
		//...
	}
}

- (IBAction)editNoteButtonClicked:(id)sender
{
	if ([sender respondsToSelector:@selector(note)]) {
//		ISOSingleNote *aNote = (ISOSingleNote *)[sender note];
		//...
	}
}



- (void)noteRemoved:(id)aNote
{
	[self _removeAttributesForNote:aNote];
	[notesViewController reflectChangesInNotesDisplay];
}

- (void)noteChanged:(id)aNote
{
	[self _removeAttributesForNote:aNote];

	[currentChapterText beginEditing];
	[self _reflectSingleNoteInText:(ISOSingleNote *)aNote];
	[currentChapterText endEditing];
	[currentBook noteChanged:aNote];
	[notesViewController reflectChangesInNotesDisplay];
}

- (IBAction)createNewNote:(id)sender
{
	ISOSingleNote *theNote;
	NSRange selectionRange = selectedTextRange;
	NSString *selectionText = [[currentChapterText attributedSubstringFromRange:selectionRange] string];
	
	if (singleNoteEditor == nil) {
		singleNoteEditor = [[ISOSingleNoteEditController alloc] initWithNibName:@"ISOSingleNoteEditController" bundle:[NSBundle mainBundle]];
	}
	if (singleNoteEditor) {
		theNote = [[ISOSingleNote alloc] initWithNoteText:@"" citation:selectionText location:selectionRange inChapterNo:currentChapterNumber withChapterTitle:[currentBook chapterTitleAtIndex:currentChapterNumber]];
		NSTextContainer *textContainer = [layoutMgr textContainerForGlyphAtIndex:selectionRange.location effectiveRange:nil];
		NSRange glyphRange = [layoutMgr glyphRangeForCharacterRange:selectionRange actualCharacterRange:nil];
		NSRect boundingRect = [layoutMgr boundingRectForGlyphRange:(NSRange)glyphRange inTextContainer:textContainer];
		if (bookProject != nil) {
			[theNote addProject:bookProject withProjectChapterNumber:bookProjectChapterNumber];
		}
		[singleNoteEditor setNote:theNote inBook:currentBook];
		[singleNoteEditor editNoteRelativeToRect:boundingRect inView:[textContainer textView] notifyOnOK:self withSelector:@selector(noteAdded:)];
	}
}

- (IBAction)changeSelectionTag:(id)sender
{
}

- (void)chapterSelectionChangedToChapter:(NSInteger)newChapterNumber
{
	if ([currentBook numberOfChapters] > newChapterNumber) {
		currentChapterNumber = newChapterNumber;
		[self goToChapterNumber:currentChapterNumber andPage:1];
	}
}

- (BOOL)validateMenuItem:(NSMenuItem *)aCell
{
    SEL action = [aCell action];
    if (action == @selector(createNewNote:)) {
		return selectedTextRange.length > 0;
    } else if (action == @selector(copyAsCitation:)) {
		return selectedTextRange.length > 0;
    } else if (action == @selector(changeSelectionTag:)) {
		return selectedTextRange.length > 0;
    }
    return YES;
}

- (NSArray *)textView:(NSTextView *)aTextView willChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges toCharacterRanges:(NSArray *)newSelectedCharRanges
{
	selectedTextRange = [[newSelectedCharRanges objectAtIndex:0] rangeValue];
	selectedTextView = aTextView;
	
	return newSelectedCharRanges;
}

- (NSMenu *)textView:(NSTextView *)view menu:(NSMenu *)menu forEvent:(NSEvent *)event atIndex:(NSUInteger)charIndex
{
	NSArray		*menuItemTitles = [NSArray arrayWithObjects:@"Copy as Citation", @"Create Note...", nil];
	NSArray		*menuItemActions = [NSArray arrayWithObjects:@"copyAsCitation:", @"createNewNote:",  nil];
	NSArray		*tagsMenuItemTitles = [NSArray arrayWithObjects:@"Red", @"Pink", @"Turquise", @"Blue", @"Brown", @"Green", @"Navy Green", @"Yellow", @"Remove Tag", nil];
	NSArray		*tagsMenuItemImages = [NSArray arrayWithObjects:@"red.png", @"pink.png", @"turquise.png", @"blue.png", @"brown.png", @"green.png", @"navygreen.png", @"yellow.png", @"notag.png", nil];
	NSArray		*menuItems = [menu itemArray];
	BOOL		found = NO;
	int			i;
	NSInteger	itemPosition = 0;
	
	for (i=0;i<[menuItems count] && !found; i++) {
		NSMenuItem *anItem = [menuItems objectAtIndex:i];
		if ([anItem action] == @selector(copyAsCitation:)) {
			found = YES;
		}
	}
	if (!found) {
		for (i=0;i<[menuItemTitles count];i++) {
			NSMenuItem *anItem = [[NSMenuItem alloc] initWithTitle:[menuItemTitles objectAtIndex:i] action:NSSelectorFromString([menuItemActions objectAtIndex:i]) keyEquivalent:@""];
			[anItem setTarget:self];
			[menu insertItem:anItem atIndex:itemPosition];
			itemPosition++;
		}
		NSMenuItem *subMenuItem = [[NSMenuItem alloc] initWithTitle:@"Mark" action:nil keyEquivalent:@""];
		NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@"Mark"];
		for (i=0;i<[tagsMenuItemTitles count]; i++) {
			NSMenuItem *anItem = [[NSMenuItem alloc] initWithTitle:[tagsMenuItemTitles objectAtIndex:i] action:@selector(changeSelectionTag:) keyEquivalent:@""];
			[anItem setTarget:self];
			[anItem setImage:[NSImage imageNamed:[tagsMenuItemImages objectAtIndex:i]]];
			[subMenu addItem:anItem];
		}
		[subMenuItem setSubmenu:subMenu];
		[menu insertItem:subMenuItem atIndex:itemPosition];
		itemPosition++;
		[menu insertItem:[NSMenuItem separatorItem] atIndex:itemPosition];
	}
    return menu;
}
@end
