//
//  ISOBookViewController.h
//  xBilim
//
//  Created by Imdat Solak on 11/2/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBook.h"
#import "ISOSingleNoteEditController.h"
#import "ISONotesViewController.h"
#import "ISONotesListViewController.h"
#import "ISOBookThemeViewController.h"
#import "ISOProject.h"
#import "ISOHeaders.h"

@class ISOMultiPageClipView;
@class ISOChapterListViewController;

@interface ISOBookViewController : NSViewController <NSLayoutManagerDelegate, NSTextViewDelegate, ISONoteOwnerProtocol>
{
	NSTextStorage	*currentChapterText;
	NSLayoutManager *currentLayoutMgr;
	NSLayoutManager	*layoutMgr;

	NSUInteger		currentChapterNumber;
	BOOL			hideControls;
	ISOBook			*currentBook;

	IBOutlet ISOMultiPageClipView	*clipView;
	IBOutlet NSMenu	*textMenu;
	NSRange			selectedTextRange;
	NSTextView		*selectedTextView;
	ISOSingleNoteEditController *singleNoteEditor;
	BOOL			showNotes;
	BOOL			highlightNotes;
	ISONotesViewController	*notesViewController;
	ISOChapterListViewController *chapterViewController;
	ISONotesListViewController *notesListViewController;
	ISOBookThemeViewController *themeViewControler;
	ISOProject *bookProject;
	NSInteger	bookProjectChapterNumber;
	
	
}
@property IBOutlet NSButton *chaptersButton;
@property IBOutlet NSTextField *bookTitleField;
@property IBOutlet NSTextField *pagesTextField;
@property IBOutlet NSButton *prevPageButton;
@property IBOutlet NSButton *nextPageButton;
@property IBOutlet NSLevelIndicator *progressIndicator;
@property IBOutlet NSPopUpButton *actionsPopupButton;

- (NSLayoutManager *)layoutManager;
- (void)setBook:(ISOBook *)aBook;
- (void)resetBook:(ISOBook *)aBook;
- (ISOBook *)currentBook;
- (void)setBookProject:(ISOProject *)aProject;
- (ISOProject *)bookProject;
- (void)setBookProjectChapterNumber:(NSInteger)aNumber;
- (NSInteger)bookProjectChapterNumber;

- (IBAction)chaptersButtonClicked:(id)sender;
- (IBAction)notesButtonClicked:(id)sender;
- (IBAction)themesButtonClicked:(id)sender;
- (IBAction)prevPageButtonClicked:(id)sender;
- (IBAction)nextPageButtonClicked:(id)sender;

- (void)setHideControls:(BOOL)flag;
- (BOOL)isHideControls;
- (void)isoMultiPageClipView:(ISOMultiPageClipView *)aView sizeDidChange:(BOOL)flag;
- (void)adjustPagesToNewViewSize;
- (void)setShowNotes:(BOOL)flag replacingView:(NSView *)notesSuperview;
- (BOOL)isShowNotes;
- (void)noteAdded:(id)aNote;
- (void)noteRemoved:(id)aNote;
- (void)noteChanged:(id)aNote;
- (void)chapterSelectionChangedToChapter:(NSInteger)newChapterNumber;
- (void)noteSelectionChangedToNote:(ISOSingleNote *)aNote;
- (IBAction)deleteNoteButtonClicked:(id)sender;
- (IBAction)editNoteButtonClicked:(id)sender;

@end
