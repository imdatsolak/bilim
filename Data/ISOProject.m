//
//  ISOProject.m
//  xBilim
//
//  Created by Imdat Solak on 10/18/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOProject.h"
#import "ISOHeaders.h"

#define kSINGLEPROJECT_TITLE			@"SingleProjectTitle"
#define kSINGLEPROJECT_CHAPTERS			@"SingleProjectChapters"
#define kSINGLEPROJECT_DESCRIPTION		@"SingleProjectDescription"
#define kSINGLEPROJECT_CREATIONDATE		@"SingleProjectCreationDate"
@implementation ISOProject

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.projectTitle forKey:kSINGLEPROJECT_TITLE];
	[encoder encodeObject:self.chapters forKey:kSINGLEPROJECT_CHAPTERS];
	[encoder encodeObject:self.projectDescription forKey:kSINGLEPROJECT_DESCRIPTION];
	[encoder encodeObject:self.creationDate forKey:kSINGLEPROJECT_CREATIONDATE];
}

- (void)decodeWithDecoder:(NSCoder *)decoder
{
	self.projectTitle = [decoder decodeObjectForKey:kSINGLEPROJECT_TITLE];
	self.chapters = [decoder decodeObjectForKey:kSINGLEPROJECT_CHAPTERS];
	self.projectDescription = [decoder decodeObjectForKey:kSINGLEPROJECT_DESCRIPTION];
	self.creationDate = [decoder decodeObjectForKey:kSINGLEPROJECT_CREATIONDATE];
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

- (id)initWithTitle:(NSString *)aTitle andDescription:(NSString *)aDesc
{
	self = [super init];
	if (self) {
		self.projectTitle = aTitle;
		self.projectDescription = aDesc;
		self.chapters = [[NSMutableArray alloc] init];
		self.creationDate = [NSDate date];
		return self;
	}
	return nil;
}

- (id) initWithTitle:(NSString *)aTitle
{
	return [self initWithTitle:aTitle andDescription:@""];
}

- (void)addChapter:(ISOProjectChapter *)aChapter
{
	if (aChapter) {
		[self.chapters addObject:aChapter];
	}
}

- (void)removeChapter:(ISOProjectChapter *)aChapter
{
	if (aChapter && [self.chapters containsObject:aChapter]) {
		[self.chapters removeObject:aChapter];
	}
}

- (ISOProjectChapter *)chapterWithChapterNumber:(NSInteger)anIndex
{
	if (anIndex < [self.chapters count]) {
		return [self.chapters objectAtIndex:anIndex];
	} else {
		return nil;
	}
}

- (NSInteger)numberOfProjectChapters
{
	return [self.chapters count];
}
@end
