//
//  ISOEbookFile.h
//  xBilim
//
//  Created by Imdat Solak on 11/2/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOBook.h"

@interface ISOEbookFile : NSObject

@property NSString *unpackedBookPath;

@property NSArray *spineArray;
@property ISOBook *bookMeta;

@property NSString *bookTitle;
@property NSString *bookAuthor;
@property NSString *bookPubDate;
@property NSString *bookPublisher;
@property NSString *bookCover;
@property NSMutableArray *bookCategoryList;

- (id) initWithBook:(ISOBook *)bookMetaData readChapterContent:(BOOL)readChapterContent;
- (id) initWithBook:(ISOBook *)bookMetaData;

@end
