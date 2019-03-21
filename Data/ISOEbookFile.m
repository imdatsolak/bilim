//
//  ISOEbookFile.m
//  xBilim
//
//  Created by Imdat Solak on 11/2/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOEbookFile.h"

@implementation ISOEbookFile

- (id)initWithBook:(ISOBook *)bookMetaData readChapterContent:(BOOL)readChapterContent
{
	if((self = [super init]) && bookMetaData && [bookMetaData bookFilename])
	{
		self.bookMeta = bookMetaData;
		self.spineArray = [[NSMutableArray alloc] init];
		self.bookCategoryList = [[NSMutableArray alloc] init];
		self.bookTitle = @"<TITLE>";
		self.bookAuthor = @"<AUTHOR>";
		self.bookPublisher = @"<PUBLISHER>";
		self.bookPubDate = @"<PUBDATE>";
	} else {
		self = nil;
	}
	return self;
}

- (id) initWithBook:(ISOBook *)bookMetaData
{
	return [self initWithBook:bookMetaData readChapterContent:YES];
}



@end
