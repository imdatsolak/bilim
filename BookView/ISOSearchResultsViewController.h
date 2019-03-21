//
//  ISOSearchResultsViewController.h
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISOCurrentBookViewController.h"

@interface ISOSearchResultsViewController : NSViewController
#if TARGET_OS_IPHONE
<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
#else
<NSTableViewDataSource, NSTableViewDelegate>
#endif
{
    int currentChapterIndex;
}

#if TARGET_OS_IPHONE
	@property IBOutlet UITableView* resultsTableView;
#else
	@property IBOutlet NSTableView* resultsTableView;
#endif

@property ISOCurrentBookViewController *epubViewController;
@property NSMutableArray *results;
@property NSString *currentQuery;


// - (void) searchString:(NSString*)query;

@end
