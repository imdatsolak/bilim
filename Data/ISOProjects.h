//
//  ISOProjects.h
//  xBilim
//
//  Created by Imdat Solak on 11/5/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOProject.h"

#define PROJECTS_NAME			@"Projects.blmprj"
#define PROJECTS_MINOR_VERSION	0
#define PROJECTS_MAJOR_VERSION	1

#define PROJECTS_PROJECTDATA	@"ProjectData"
#define PROJECTS_MINOR_VERSION_KEY	@"ProjectsMinorVersion"
#define PROJECTS_MAJOR_VERSION_KEY	@"ProjectsMajorVersion"

@interface ISOProjects : NSObject <NSCoding>
{
}

@property NSMutableArray *projects;
@property NSInteger projectsMajorVersion;
@property NSInteger projectsMinorVersion;


- (BOOL)addProject:(ISOProject *)theProject;
- (BOOL)removeProject:(ISOProject *)theProject;
- (ISOProject *)projectAtIndex:(NSInteger)position;
- (NSInteger )numberOfProjects;

@end
