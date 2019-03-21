//
//  ISOPVBookCellView.h
//  xBilim
//
//  Created by Imdat Solak on 11/1/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBookCoverView.h"

@interface ISOPVBookCellView : NSTableCellView

@property IBOutlet ISOBookCoverView *coverView;
@property IBOutlet NSTextField *bookTitleField;
@property IBOutlet NSTextField *bookAuthorField;
@property IBOutlet NSTextField *bookPubYearField;
@property IBOutlet NSTextField *bookPublisherField;
@property IBOutlet NSButton *bookIsUsedButton;

@end
