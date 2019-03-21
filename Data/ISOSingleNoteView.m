//
//  ISOSingleNoteView.m
//  xBilim
//
//  Created by Imdat Solak on 11/6/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOSingleNoteView.h"

@implementation ISOSingleNoteView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		displayCitation = NO;
		note = nil;
		selected = NO;
		showNoteLocation = NO;
		showNoteChapter = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)flag
{
	selected = flag;
}

- (BOOL)isSelected
{
	return selected;
}
- (NSTextField *)noteTextField
{
	if (!noteTextField) {
		noteTextField = [[NSTextField alloc] initWithFrame:[self frame]];
		[noteTextField setEditable:NO];
		[noteTextField setSelectable:NO];
		[noteTextField setFont:[NSFont systemFontOfSize:9]];
		[noteTextField setDrawsBackground:NO];
		[noteTextField setBordered:NO];
		[noteTextField setAllowsEditingTextAttributes:YES];
		[[noteTextField cell] setWraps:YES];
		[[noteTextField cell] setTruncatesLastVisibleLine:YES];
		[[noteTextField cell] setLineBreakMode:NSLineBreakByWordWrapping];
	}
	return noteTextField;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
	if (note) {
		NSRect noteRect = [self bounds];
		NSTextField *nField = [self noteTextField];
		NSColor *noteColor = [note noteTagAsColor];
		NSRect aRect;
		NSMutableAttributedString *textToShow;
		NSMutableString *citationInfo;
		NSString *noteDate = [NSDateFormatter localizedStringFromDate:[note noteDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];

//		[[NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1] set];
//		NSRectFill(dirtyRect);
//
		if (!noteColor) {
			noteColor = [NSColor lightGrayColor];
		}
		if (!selected) {
			noteColor = [noteColor highlightWithLevel:0.7];
		}
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:noteRect xRadius:4 yRadius:4];
		NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[noteColor highlightWithLevel:0.5] endingColor:[noteColor highlightWithLevel:0.9]];
		[gradient drawInBezierPath:path angle:90.0];
		
		aRect = [self bounds];
		aRect.size.width -= 70;
//		aRect.size.height -= 4;
//		aRect.origin.y += 2;
		aRect.origin.x += 2;
		citationInfo = [NSMutableString stringWithFormat:@"%@", noteDate];
		
		if (showNoteLocation) {
			[citationInfo appendString:[NSString stringWithFormat:@" @%@%lu-%lu",
			 NSLocalizedString(@"Location:", @"Title shown in Notes"), [note noteLocation].location, [note noteLocation].location+[note noteLocation].length]];
		}
		if (showNoteChapter) {
			[citationInfo appendString:[NSString stringWithFormat:@" @%@%lu (%@)",
										NSLocalizedString(@"Chapter:", @"Title shown in Notes"), [note chapterNumber], [[note chapterTitle] substringToIndex:MIN(50, [[note chapterTitle] length])]]];
		
		}
		textToShow = [[NSMutableAttributedString alloc] initWithString:citationInfo attributes:
					  [NSDictionary dictionaryWithObject:[NSFont systemFontOfSize:9.0] forKey:NSFontAttributeName]];
		[textToShow addAttribute:NSForegroundColorAttributeName value:[NSColor darkGrayColor] range:NSMakeRange(0, [textToShow length])];
		
		if (displayCitation) {
			NSString *citation = [NSString stringWithFormat:@"\n\"... %@ ...\"\n\n", [note citation]];
			[textToShow appendAttributedString:[[NSAttributedString alloc] initWithString:citation attributes:
								[NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Palatino-Italic" size:12.0] forKey:NSFontAttributeName]]];
		}
		[textToShow appendAttributedString:[[NSAttributedString alloc] initWithString:
											[NSString stringWithFormat:@" %@", [note noteText]] attributes:
											[NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Palatino" size:12.0] forKey:NSFontAttributeName]]];
		[nField setAttributedStringValue:textToShow];
		[nField setFrame:aRect];
		if ([nField superview] != self) {
			[self addSubview:nField];
		}
		[nField display];
	}
}

- (IBAction)deleteNoteButtonClicked:(id)sender
{
	if (owner && [owner respondsToSelector:@selector(deleteNoteButtonClicked:)]) {
		[owner deleteNoteButtonClicked:self];
	}
}

- (IBAction)editNoteButtonClicked:(id)sender
{
	if (owner && [owner respondsToSelector:@selector(editNoteButtonClicked:)]) {
		[owner editNoteButtonClicked:self];
	}
}

- (void)setNote:(ISOSingleNote *)aNote
{
	note = aNote;
}

- (ISOSingleNote *)note
{
	return note;
}

- (void)setOwner:(id)anOwner
{
	owner = anOwner;
}

- (id)owner
{
	return owner;
}


- (void)setDisplayCitation:(BOOL)flag
{
	displayCitation = flag;
}

- (BOOL)isDisplayCitation
{
	return displayCitation;
}

- (void)setShowNoteLocation:(BOOL)flag
{
	showNoteLocation = flag;
}
- (BOOL)isShowNoteLocation
{
	return showNoteLocation;
}

- (void)setShowNoteChapter:(BOOL)flag
{
	showNoteChapter = flag;
}

- (BOOL)isShowNoteChapter
{
	return showNoteChapter;
}
@end
