//
//  ISOBook.m
//  xBilim
//
//  Created by Imdat Solak on 11/2/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOBook.h"
#import "ZipArchive.h"
#import "ISOHeaders.h"

@implementation ISOBook

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.bookChapters forKey:kBookChapters];
	[encoder encodeObject:self.bookFilename forKey:kBookFilename];
	[encoder encodeObject:self.bookTitle forKey:kBookTitle];
	[encoder encodeObject:self.bookAuthor forKey:kBookAuthor];
	[encoder encodeObject:self.bookPubYear forKey:kBookPubYear];
	[encoder encodeObject:self.bookPubDate forKey:kBookPubDate];
	[encoder encodeObject:self.bookPublisher forKey:kBookPublisher];
	[encoder encodeObject:self.bookCategory forKey:kBookCategory];
	[encoder encodeObject:self.bookID forKey:kBookID];
	[encoder encodeObject:self.bookCover forKey:kBookCover];
	[encoder encodeInt:self.bookLastReadChapter forKey:kLastReadChapter];
	[encoder encodeInt:self.bookLastReadPositionInChapter forKey:kLastReadPositionInChapter];
	[encoder encodeObject:self.unpackedBookPath forKey:kUnpackedBookPath];
	[encoder encodeObject:bookNotes forKey:kBookNotes];
	[encoder encodeBool:self.paperBook forKey:kPaperBook];
	[encoder encodeObject:self.paperBookEdition forKey:kPaperBookEdition];
	[encoder encodeObject:self.paperBookComments forKey:kPaperBookComments];
	[encoder encodeObject:self.paperBookISBN forKey:kPaperBookISBN];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if (self) {
		self.bookChapters = [decoder decodeObjectForKey:kBookChapters];
		self.bookFilename = [decoder decodeObjectForKey:kBookFilename];
		self.bookTitle = [decoder decodeObjectForKey:kBookTitle];
		self.bookAuthor = [decoder decodeObjectForKey:kBookAuthor];
		self.bookPubYear = [decoder decodeObjectForKey:kBookPubYear];
		self.bookPubDate = [decoder decodeObjectForKey:kBookPubDate];
		self.bookPublisher = [decoder decodeObjectForKey:kBookPublisher];
		self.bookCategory = [decoder decodeObjectForKey:kBookCategory];
		self.bookID = [decoder decodeObjectForKey:kBookID];
		self.bookCover = [decoder decodeObjectForKey:kBookCover];
		self.bookLastReadChapter = [decoder decodeIntForKey:kLastReadChapter];
		self.bookLastReadPositionInChapter = [decoder decodeIntForKey:kLastReadPositionInChapter];
		self.unpackedBookPath = [decoder decodeObjectForKey:kUnpackedBookPath];
		self.paperBook = [decoder decodeBoolForKey:kPaperBook];
		self.paperBookEdition = [decoder decodeObjectForKey:kPaperBookEdition];
		if (self.paperBookEdition == nil) {
			self.paperBookEdition = @"";
		}
		self.paperBookComments = [decoder decodeObjectForKey:kPaperBookComments];
		if (self.paperBookComments == nil) {
			self.paperBookComments = @"";
		}
		self.paperBookISBN = [decoder decodeObjectForKey:kPaperBookISBN];
		if (self.paperBookISBN == nil) {
			self.paperBookISBN = @"";
		}
		bookNotes = [decoder decodeObjectForKey:kBookNotes];
		if (bookNotes == nil) {
			bookNotes = [[NSMutableArray alloc] init];
		}
		if (self.bookPubYear == nil) {
			self.bookPubYear = [self.bookPubDate substringToIndex:4];
		}
		
		return self;
	}
	return nil;
}

- (id)init
{
	self = [super init];
	if (self) {
		self.bookFilename = @"";
		self.bookTitle = @"";
		self.bookAuthor = @"";
		self.bookPubYear = @"";
		self.bookPubDate = @"";
		self.bookPublisher = @"";
		self.bookCategory = @"";
		self.bookID = @"";
		self.bookCover = @"";
		self.bookLastReadChapter = 0;
		self.bookLastReadPositionInChapter = 0;
		self.unpackedBookPath = @"";
		self.paperBook = NO;
		self.paperBookEdition = @"";
		self.paperBookComments = @"";
		self.paperBookISBN = @"";
		
		bookNotes = [[NSMutableArray alloc] init];
		return self;
	}
	return nil;
}

- (id)initWithPaperBookTitle:(NSString *)aTitle author:(NSString *)anAuthor publisher:(NSString *)publisher pubYear:(NSString *)pubYear edition:(NSString *)edition comments:(NSString *)comments andISBN:(NSString *)isbn
{
	self = [self init];
	if (self) {
		self.bookTitle = aTitle;
		self.bookAuthor = anAuthor;
		self.bookPublisher = publisher;
		self.bookPubYear = pubYear;
		self.bookPubDate = [NSDate dateWithNaturalLanguageString:[NSString stringWithFormat:@"%@-01-01 00:00:00", pubYear]];
		self.paperBookEdition = edition;
		self.paperBookComments = comments;
		self.paperBookISBN = isbn;
		self.paperBook = YES;
	}
	return self;
}


- (void)_sendBookChangedNotification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
}

- (NSUInteger)numberOfChapters
{
	return [self.bookChapters count];
}

- (NSDictionary *)lastViewedChapter
{
	return [self chapterWithIndex:[self bookLastReadChapter]];
}

- (NSDictionary *)chapterWithIndex:(NSUInteger)index
{
	if (index < [self.bookChapters count]) {
		return [self.bookChapters objectAtIndex:index];
	}
	return nil;
}

- (NSString *)chapterTitleAtIndex:(NSUInteger)index
{
	NSDictionary *aDict = [self chapterWithIndex:index];
	if (aDict) {
		return [[aDict allValues] objectAtIndex:0];
	} else {
		return @"";
	}
}

- (BOOL)importEBookFromFile:(NSString *)bookFile
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:bookFile]) {
		self.bookID = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
		self.bookFilename = bookFile;
		self.bookLastReadChapter = 0;
		self.bookLastReadPositionInChapter = 0;
		[self parseEBook];
		return YES;
	}
	return NO;
}

- (void)setLastReadPage:(int)pageNo inChapter:(int)chapterNo
{
	self.bookLastReadChapter = chapterNo;
	self.bookLastReadPositionInChapter = pageNo;
	[self _sendBookChangedNotification];
}

/* ***************************************************************************************
 *
 * PARSING EPUB
 *
 * ***************************************************************************************
 */
- (void)parseEBook
{
	[self unzipAndSaveFileNamed:self.bookFilename];
	[self parseManifestAndOPF];
}

- (void)unzipAndSaveFileNamed:(NSString*)fileName
{
	ZipArchive		*za;
	NSString		*strPath;
	NSFileManager	*filemanager;
	NSError			*error;
	
	za = [[ZipArchive alloc] init];
	if( [za UnzipOpenFile:self.bookFilename]){
		strPath = [NSString stringWithFormat:@"%@/%@", ISOApplicationDirectoryUsingPath(@"OpenBooks"), self.bookID];
		filemanager = [[NSFileManager alloc] init];
		
		if ([filemanager fileExistsAtPath:strPath]) { // if it was already unzipped, delete it (you never know)
			[filemanager removeItemAtPath:strPath error:&error];
		}
		self.unpackedBookPath = strPath;
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret ){
			// error handler here
#if TARGET_OS_IPHONE
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
														  message:@"Error while unzipping the epub"
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
			[alert show];
#else
			[NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Error while unzipping the epub"];
			
#endif
		}
		[za UnzipCloseFile];
	}
}

/* **************************************************************************************
 * Parsing ePUB-File (mainly OPF/NCX)
 *
 * I'm using NSXML for this. In order for this to work on iOS, we need to use
 * CXML-Library
 * **************************************************************************************
 */

- (void)parseManifestAndOPF
{
	NSString		*manifestFilePath;
	NSFileManager	*fileManager;
	NSXMLDocument	*manifestFile;
	NSArray			*opfPath;
	
	manifestFilePath = [NSString stringWithFormat:@"%@/%@/META-INF/container.xml", ISOApplicationDirectoryUsingPath(@"OpenBooks"), self.bookID];
	fileManager = [[NSFileManager alloc] init];
	if ([fileManager fileExistsAtPath:manifestFilePath]) {
		manifestFile = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil];
		opfPath = [manifestFile nodesForXPath:@"//@full-path[1]" error:nil];
		[opfPath enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSString *opfFile = [NSString stringWithFormat:@"%@/%@/%@", ISOApplicationDirectoryUsingPath(@"OpenBooks"), self.bookID,[obj objectValue]];
			if ([fileManager fileExistsAtPath:opfFile]) {
				[self parseOPF:opfFile];
				*stop = YES;
			}
		}];
	} else {
		NSLog(@"ERROR: ePub not Valid");
	}
}

- (void) parseOPF:(NSString*)opfPath
{
	[self parseOPF:opfPath readChapterContent:NO];
}

- (NSString *)_extractManifestItemWithID:(NSString *)theID formOPF:(NSXMLDocument *)opfFile
{
	NSString		*xQuery = [NSString stringWithFormat:@"//package[1]/manifest[1]/item[@id='%@']", theID];
	NSArray			*itemsArray = [opfFile objectsForXQuery:xQuery constants:nil error:nil];
	if (itemsArray && [itemsArray count]) {
		NSXMLElement	*element = [itemsArray objectAtIndex:0];
		return [[element attributeForName:@"href"] stringValue];
	} else {
		return @"";
	}
}


- (void)_addTocFromNavArray:(NSArray *)navArray toToc:(NSMutableArray *)tocArray withEbookBasePath:(NSString *)ebookBasePath
{
	static int		inclevel = 0;
	NSXMLElement	*element;
	
	inclevel++;
	
	for (element in navArray) {
		NSArray			*textElement;
		NSArray			*contentElement;
		NSString		*contentURL;
		NSString		*chapterTitle;
		NSDictionary	*tocDict;
		NSArray			*subNavPoints;
		NSRange			aRange;
		
		textElement = [element objectsForXQuery:@"./navLabel/text" constants:nil error:nil];
		chapterTitle = [[textElement objectAtIndex:0] stringValue];
		
		contentElement = [element objectsForXQuery:@"./content" constants:nil error:nil];
		contentURL = [[[contentElement objectAtIndex:0] attributeForName:@"src"] stringValue];
		aRange = [contentURL rangeOfString:@"#"];
		if (aRange.location != NSNotFound) {
			contentURL = [contentURL substringToIndex:aRange.location];
		}
		contentURL = [contentURL stringByRemovingPercentEncoding];
		contentURL = [NSString stringWithFormat:@"%@%@", ebookBasePath, contentURL];
		if (inclevel>1) {
			char buf[32] = "";
			strncat(buf, "\t\t\t\t\t", MIN(5, inclevel-1));
			chapterTitle = [NSString stringWithFormat:@"%d%s%@", inclevel-1, buf, chapterTitle];
		}
		tocDict = [NSDictionary dictionaryWithObject:chapterTitle forKey:contentURL];
		[tocArray addObject:tocDict];
		subNavPoints = [element objectsForXQuery:@"./navPoint" constants:nil error:nil];
		if (inclevel < 5 && subNavPoints && [subNavPoints count]) {
			[self _addTocFromNavArray:subNavPoints toToc:tocArray withEbookBasePath:ebookBasePath];
		}
	}
	inclevel--;
	
}
- (void)_createTOCFromNcx:(NSXMLDocument *)ncxToc addToArray:(NSMutableArray *)tocArray withEbookBasePath:(NSString *)ebookBasePath
{
	NSArray *mainNavPointArray = [ncxToc objectsForXQuery:@"//ncx/navMap/navPoint" constants:nil error:nil];
	
	[self _addTocFromNavArray:mainNavPointArray toToc:tocArray withEbookBasePath:ebookBasePath];
}

// Since TextStorage doesn't yet support ".XHTML"-extensions, we need to rename such files
// to ".HTML"
- (NSString *)_checkAndCorrectXHtmlExtension:(NSString *)aPath ebookPath:(NSString *)ebookBasePath
{
	NSString *newChapterURL;
	
	if (ebookBasePath != nil) {
		aPath = [NSString stringWithFormat:@"%@%@", ebookBasePath, aPath];
	}
	newChapterURL = aPath;
	if ([[aPath pathExtension] isEqualToString:@"xhtml"]) {
		NSString *newString = [aPath stringByDeletingPathExtension];
		newString = [newString stringByAppendingPathExtension:@"html"];
		if ([[NSFileManager defaultManager] moveItemAtPath:aPath toPath:newString error:nil]) {
			newChapterURL = newString;
		}
	}
	return newChapterURL;
}

- (void)_correctTOCForBuggyBooksFromOPFOrder:(NSArray *)spineOrderArray withEbookBasePath:(NSString *)ebookBasePath
{
	NSMutableArray *newTocArray = [[NSMutableArray alloc] init];
	NSMutableArray *additionalEntries = [[NSMutableArray alloc] init];
	int i, j;
	int addendum = 1;
	
	for (i=0;i<[spineOrderArray count];i++) {
		BOOL found = NO;
		NSString *thisChapterURL = [spineOrderArray objectAtIndex:i];
		for (j=0;j<[self.bookChapters count]; j++) {
			NSDictionary *aDict = [self.bookChapters objectAtIndex:j];
			NSString *firstKey = [[aDict allKeys] objectAtIndex:0];
			if ([firstKey isEqualToString:thisChapterURL]) {
				NSString *firstValue = [aDict objectForKey:firstKey];
				NSDictionary *newDict = [NSDictionary dictionaryWithObject:firstValue forKey:[self _checkAndCorrectXHtmlExtension:thisChapterURL ebookPath:nil]];
				[newTocArray addObject:newDict];
				found = YES;
			}
		}
		if (!found) {
			NSString *cTitle = [NSString stringWithFormat:NSLocalizedString(@"Addendum %d", @"Chapter Title"), addendum++];
			thisChapterURL = [self _checkAndCorrectXHtmlExtension:thisChapterURL ebookPath:nil];
			[additionalEntries addObject:[NSDictionary dictionaryWithObject:cTitle forKey:thisChapterURL]];
		}
	}
	if ([additionalEntries count]) {
		[newTocArray addObjectsFromArray:additionalEntries];
	}
	self.bookChapters = newTocArray;
}

- (void) parseOPF:(NSString*)opfPath readChapterContent:(BOOL)readChapterContent
{
	NSXMLDocument			*opfFile;
	NSArray					*itemsArray;
    NSString				*ncxFileName;
	NSString				*coverImageName;
	NSString				*coverFileName;
	int						lastSlash;
	NSString				*ebookBasePath;
	NSXMLDocument			*ncxToc;
	NSXMLElement			*element;
	
	NSMutableDictionary		*fileListDictionary;
	NSMutableArray			*spineOrderArray;
	NSMutableArray			*tocArray;
	
	NSString				*spineID;
	
    lastSlash = (int)[opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
	ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
	
	opfFile = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
	
	// Get Cover Image and NCX-Filename from OPF
	coverImageName = [self _extractManifestItemWithID:@"cover" formOPF:opfFile];
	coverFileName = [self _extractManifestItemWithID:@"titlepage" formOPF:opfFile];
	
	
	// Next let's try to find out SPINE-ID within the Manifest File so that we can identify
	// the SPINE (NCX) file. It is usually called "ncx", but you never know...
	itemsArray = [opfFile objectsForXQuery:@"//package[1]//spine[1]" constants:nil error:nil];
	element = [itemsArray objectAtIndex:0];
	if (element) {
		spineID = [[element attributeForName:@"toc"] stringValue];
	} else {
		spineID = @"ncx";
	}
	ncxFileName = [self _extractManifestItemWithID:spineID formOPF:opfFile];
	
	
	// Next create the list of files in the eBook
	itemsArray = [opfFile objectsForXQuery:@"//package[1]/manifest[1]/item" constants:nil error:nil];
	fileListDictionary = [[NSMutableDictionary alloc] init];
	for (element in itemsArray) {
		NSString *theID;
		NSString *theValue;
		NSString *theType;
		
		theID = [[element attributeForName:@"id"] stringValue];
		theValue = [[element attributeForName:@"href"] stringValue];
		theType = [[element attributeForName:@"media-type"] stringValue];
		if ([theType isEqualToString:@"application/xhtml+xml"]) {
			[fileListDictionary setObject:theValue forKey:theID];
		}
	}
	
	// Next, create the spine ORDER with the filepaths stored in the "play-order"
	itemsArray = [opfFile objectsForXQuery:@"//package[1]//spine[1]/itemref" constants:nil error:nil];
	spineOrderArray = [[NSMutableArray alloc] init];
	for (element in itemsArray) {
		NSString *aKey = [[element attributeForName:@"idref"] stringValue];
		NSString *aValue = [fileListDictionary objectForKey:aKey];
		if (aValue) {
			[spineOrderArray addObject: [NSString stringWithFormat:@"%@%@", ebookBasePath, aValue]];
		}
	}
	
	// Now create the Spine
	// Now create the TOC as designed by the publisher
	ncxFileName = [NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName];
    ncxToc = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:ncxFileName] options:0 error:nil];
	tocArray = [[NSMutableArray alloc] init];
	[self _createTOCFromNcx:ncxToc addToArray:tocArray withEbookBasePath:ebookBasePath];
	self.bookChapters = tocArray;
	[self _correctTOCForBuggyBooksFromOPFOrder:spineOrderArray withEbookBasePath:ebookBasePath]; // Correct for buggy OPF/NCX combinations
	
	// In order for the bookcover to be persistent, we need to
	// copy it to some place - best would be to remove unpacked book data after use...
	// TODO:
	self.bookCover = [NSString stringWithFormat:@"%@/%@", self.unpackedBookPath, coverImageName];
	
	// Finally extract some meta information (author, title, publisher, ...)
	itemsArray = [opfFile objectsForXQuery:@"//package[1]/metadata" constants:nil error:nil];
	element = [itemsArray objectAtIndex:0];
	for (NSXMLElement *ni in [element children]) {
		if ([[ni name] compare:@"dc:title"] == NSOrderedSame) {
			self.bookTitle = [ni stringValue];
		} else if ([[ni name] compare:@"dc:creator"] == NSOrderedSame) {
			self.bookAuthor = [ni stringValue];
		} else if ([[ni name] compare:@"dc:publisher"] == NSOrderedSame) {
			self.bookPublisher = [ni stringValue];
		} else if ([[ni name] compare:@"dc:date"] == NSOrderedSame) {
			self.bookPubDate = [ni stringValue];
			self.bookPubYear = [self.bookPubDate substringToIndex:4];
		} else if ([[ni name] compare:@"dc:subject"] == NSOrderedSame) {
			self.bookCategory = [ni stringValue];
		}
	}
}

/* ***********************************************************************
 * Notes Handling
 * ***********************************************************************
 */
- (void)noteChanged:(ISOSingleNote *)aNote
{
	if ([bookNotes containsObject:aNote]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
	}
}

- (void)addNote:(ISOSingleNote *)aNote
{
	if (aNote) {
		if (![bookNotes containsObject:aNote]) { // we add it only if it is not in our list yet...
			[bookNotes addObject:aNote];
		}
		// but as we are not sure whether the content changed, we request a re-sync in any case...
		[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
	}
}

- (void)removeNote:(ISOSingleNote *)aNote
{
	if ([bookNotes containsObject:aNote]) {
		[bookNotes removeObject:aNote];
		[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
	}
}

- (void)removeNoteAtIndex:(NSInteger)index
{
	if (index < [bookNotes count]) {
		[bookNotes removeObjectAtIndex:index];
		[[NSNotificationCenter defaultCenter] postNotificationName:ISOBilimDataChangedNotification object:nil];
	}
}

- (NSArray *)bookNotes
{
	return bookNotes;
}

- (NSArray *)notesForChapterNumber:(NSInteger)chapterNo
{
	NSMutableArray *newArray = [[NSMutableArray alloc] init];;
	int i;
	
	for (i=0;i<[bookNotes count];i++) {
		ISOSingleNote *aNote = [bookNotes objectAtIndex:i];
		if ([aNote chapterNumber] == chapterNo) {
			[newArray addObject:aNote];
		}
	}
	if ([newArray count]) {
		return newArray;
	} else {
		return nil;
	}
}

- (NSArray *)notesForProject:(ISOProject *)aProject andProjectChapter:(NSInteger)chapterNo
{
	int i;
	NSMutableArray *retVal = [[NSMutableArray alloc] init];
	
	for (i=0;i<[bookNotes count]; i++) {
		ISOSingleNote *aNote = [bookNotes objectAtIndex:i];
		if ([aNote hasProject:aProject withProjectChapterNumber:chapterNo]) {
			[retVal addObject:aNote];
		}
	}
	if ([retVal count]) {
		return retVal;
	}
	return nil;
}

@end
