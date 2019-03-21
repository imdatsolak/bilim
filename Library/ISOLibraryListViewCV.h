//
//  ISOLibraryListViewCV.h
//  xBilim
//
//  Created by Imdat Solak on 10/31/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOBookCoverView.h"

@interface ISOLibraryListViewCV : NSTableCellView
{

}
@property IBOutlet ISOBookCoverView *bookCoverView;
@property IBOutlet NSTextField *bookTitleField;
@property IBOutlet NSTextField *bookAuthorField;
@property IBOutlet NSTextField *bookPubYearField;
@property IBOutlet NSTextField *bookPublisherField;

@end
