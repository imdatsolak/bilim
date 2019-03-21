//
//  ISOProjects.m
//  xBilim
//
//  Created by Imdat Solak on 11/5/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOProjects.h"
#import "ISOHeaders.h"

@implementation ISOProjects

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.projects forKey:PROJECTS_PROJECTDATA];
	[encoder encodeInteger:self.projectsMajorVersion forKey:PROJECTS_MAJOR_VERSION_KEY];
	[encoder encodeInteger:self.projectsMinorVersion forKey:PROJECTS_MINOR_VERSION_KEY];
}

- (void)decodeWithDecoder:(NSCoder *)decoder
{
	self.projects = [decoder decodeObjectForKey:PROJECTS_PROJECTDATA];
	self.projectsMinorVersion = [decoder decodeIntegerForKey:PROJECTS_MINOR_VERSION_KEY];
	self.projectsMajorVersion = [decoder decodeIntegerForKey:PROJECTS_MAJOR_VERSION_KEY];
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
		self.projects = [[NSMutableArray alloc] init];
		return self;
	}
	return nil;
}

- (BOOL)addProject:(ISOProject *)theProject
{
	if (theProject && ![self.projects containsObject:theProject]) {
		[self.projects addObject:theProject];
		return YES;
	}
	return NO;
	
}

- (BOOL)removeProject:(ISOProject *)theProject
{
	if (theProject && [self.projects containsObject:theProject]) {
		[self.projects removeObject:theProject];
		return YES;
	}
	return NO;
}

- (ISOProject *)projectAtIndex:(NSInteger)position
{
	if (position < [self.projects count]) {
		return [self.projects objectAtIndex:position];
	}
	return nil;
}

- (NSInteger)numberOfProjects
{
	return [self.projects count];
}

@end
