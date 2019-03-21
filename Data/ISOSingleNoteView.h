//
//  ISOSingleNoteView.h
//  xBilim
//
//  Created by Imdat Solak on 11/6/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOSingleNote.h"
#import "ISOHeaders.h"

@interface ISOSingleNoteView : NSView <ISONoteHolderProtocol>
{
	BOOL			displayCitation;
	id				owner;
	ISOSingleNote	*note;
	NSTextField		*noteTextField;
	BOOL			selected;
	BOOL			showNoteLocation;
	BOOL			showNoteChapter;
}

- (IBAction)deleteNoteButtonClicked:(id)sender;
- (IBAction)editNoteButtonClicked:(id)sender;

- (void)setNote:(ISOSingleNote *)aNote;
- (ISOSingleNote *)note;
- (void)setOwner:(id)anOwner;
- (id)owner;
- (void)setDisplayCitation:(BOOL)flag;
- (BOOL)isDisplayCitation;
- (void)setSelected:(BOOL)flag;
- (BOOL)isSelected;
- (void)setShowNoteLocation:(BOOL)flag;
- (BOOL)isShowNoteLocation;
- (void)setShowNoteChapter:(BOOL)flag;
- (BOOL)isShowNoteChapter;

@end
