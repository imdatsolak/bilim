//
//  ISOLibrary.h
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOBook.h"

#define LIBRARY_NAME			@"Library.blmlib"
#define LIBRARY_VERSION_MAJ		1
#define LIBRARY_VERSION_MIN		0

#define kSELFBOOKS			@"LibraryBooks"
#define kSELFLIBRARYMAJOR	@"LibraryMajor"
#define kSELFLIBRARYMINOR	@"LibraryMinor"


@interface ISOLibrary : NSObject <NSCoding>
{
	BOOL	needsSaving;
}

@property NSInteger libraryMajorVersion;
@property NSInteger libraryMinorVersion;
@property NSMutableArray *books;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (void)decodeWithDecoder:(NSCoder *)decoder;

- (id)init;
- (BOOL)addBook:(ISOBook *)aBook;
- (BOOL)bookWithPathExists:(NSString *)aPath;
- (ISOBook *)addBookFromPath:(NSString *)aPath;
- (BOOL)addBook:(ISOBook *)theBook shouldCopy:(BOOL)shouldCopy;
- (BOOL)removeBook:(ISOBook *)theBook;
- (ISOBook *)bookAtIndex:(NSInteger)position;


@end
