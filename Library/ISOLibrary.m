//
//  ISOLibrary.m
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOLibrary.h"
#import "ISOHeaders.h"
#import "ISOBook.h"

@implementation ISOLibrary


- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.books forKey:kSELFBOOKS];
	[encoder encodeInteger:self.libraryMajorVersion forKey:kSELFLIBRARYMAJOR];
	[encoder encodeInteger:self.libraryMinorVersion forKey:kSELFLIBRARYMINOR];
}

- (void)decodeWithDecoder:(NSCoder *)decoder
{
	self.books = [decoder decodeObjectForKey:kSELFBOOKS];
	self.libraryMinorVersion = [decoder decodeIntegerForKey:kSELFLIBRARYMINOR];
	self.libraryMajorVersion = [decoder decodeIntegerForKey:kSELFLIBRARYMAJOR];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self) {
		[self decodeWithDecoder:aDecoder];
		return self;
	}
	return nil;
}


- (id)init
{
	self = [super init];
	if (self) {
		self.books = [[NSMutableArray alloc] init];
		return self;
	}
	return nil;
}

- (BOOL)addBook:(ISOBook *)aBook
{
	return [self addBook:aBook shouldCopy:NO];
}

- (BOOL)bookWithPathExists:(NSString *)aPath
{
	for (ISOBook *aBook in self.books) {
		if ([[aBook bookFilename] compare:aPath options:NSLiteralSearch] == NSOrderedSame) {
			return YES;
		}
	}
	return NO;
}

- (ISOBook *)addBookFromPath:(NSString *)aPath
{
	if (![self bookWithPathExists:aPath]) {
		ISOBook *aBook = [[ISOBook alloc] init];
		if ([aBook importEBookFromFile:aPath]) {
			[self.books addObject:aBook];
			return aBook;
		}
	}
	return nil;
}

- (BOOL)addBook:(ISOBook *)theBook shouldCopy:(BOOL)shouldCopy
{
	if (theBook) {
		[self.books addObject:theBook];
		return YES;
	}
	return NO;
	
}

- (BOOL)removeBook:(ISOBook *)theBook
{
	if (theBook && [self.books containsObject:theBook]) {
		[self.books removeObject:theBook];
		return YES;
	}
	return NO;
}

- (ISOBook *)bookAtIndex:(NSInteger)position
{
	if (position < [self.books count]) {
		return [self.books objectAtIndex:position];
	}
	return nil;
}

@end
