//
//  ISOSearchResultsViewController.m
//  xBilim
//
//  Created by Imdat Solak on 10/20/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import "ISOSearchResultsViewController.h"
#import "ISOSearchResult.h"
#import "WebView+SearchWebView.h"

@interface ISOSearchResultsViewController()

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index;

@end

@implementation ISOSearchResultsViewController
#if TARGET_OS_IPHONE
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    ISOSearchResult* hit = (ISOSearchResult *)[results objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"...%@...", hit.neighboringText];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Chapter %d - page %d", hit.chapterIndex, hit.pageIndex+1];
    return cell;
}
#else
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    ISOSearchResult* hit = (ISOSearchResult *)[self.results objectAtIndex:rowIndex];
	return [NSString stringWithFormat:@"...%@...", hit.neighboringText];

}
#endif


#if TARGET_OS_IPHONE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
#else
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
#endif
{
    return [self.results count];
}

#ifdef _DONE_TODO
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISOSearchResult* hit = (ISOSearchResult*)[self.results objectAtIndex:[indexPath row]];
	
    [self.epubViewController loadSpine:hit.chapterIndex atPageIndex:hit.pageIndex highlightSearchResult:hit];
}

#endif

- (void) searchString:(NSString*)query{
    self.results = [[NSMutableArray alloc] init];
    [self.resultsTableView reloadData];
    self.currentQuery=query;
    
    [self searchString:query inChapterAtIndex:0];
}

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index{
}
#ifdef _DONE_TODO
- (void) searchString:(NSString *)query inChapterAtIndex:(int)index{
    
    currentChapterIndex = index;
    
    Chapter* chapter = [epubViewController.loadedEpub.spineArray objectAtIndex:index];
    
    NSRange range = NSMakeRange(0, chapter.text.length);
    range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
    int hitCount=0;
    while (range.location != NSNotFound) {
        range = NSMakeRange(range.location+range.length, chapter.text.length-(range.location+range.length));
        range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
        hitCount++;
    }
    
    if(hitCount!=0){
        UIWebView* webView = [[UIWebView alloc] initWithFrame:chapter.windowSize];
        [webView setDelegate:self];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:chapter.spinePath]];
        [webView loadRequest:urlRequest];
    } else {
        if((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count]){
            [self searchString:currentQuery inChapterAtIndex:(currentChapterIndex+1)];
        } else {
            epubViewController.searching = NO;
        }
    }
}

#endif

#if TARGET_OS_IPHONE
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@", error);
	[webView release];
}
#endif

#if TARGET_OS_IPHONE
- (void) webViewDidFinishLoad:(UIWebView*)webView
#else
- (void) webView:(WebView *)webView didFinishLoadForFrame:(WebFrame *)frame
#endif
{
#ifdef _DONE_TODO
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
	"}";
	
	//    NSLog(@"w:%f h:%f", webView.bounds.size.width, webView.bounds.size.height);
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",[[epubViewController.loadedEpub.spineArray objectAtIndex:currentChapterIndex] fontPercentSize]];
    
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    
    [webView highlightAllOccurencesOfString:currentQuery];
    
    NSString* foundHits = [webView stringByEvaluatingJavaScriptFromString:@"results"];
    
	//    NSLog(@"%@", foundHits);
    
    NSMutableArray* objects = [[NSMutableArray alloc] init];
    
    NSArray* stringObjects = [foundHits componentsSeparatedByString:@";"];
    for(int i=0; i<[stringObjects count]; i++){
        NSArray* strObj = [[stringObjects objectAtIndex:i] componentsSeparatedByString:@","];
        if([strObj count]==3){
            [objects addObject:strObj];
        }
    }
    
    NSArray* orderedRes = [objects sortedArrayUsingComparator:^(id obj1, id obj2){
		int x1 = [[obj1 objectAtIndex:0] intValue];
		int x2 = [[obj2 objectAtIndex:0] intValue];
		int y1 = [[obj1 objectAtIndex:1] intValue];
		int y2 = [[obj2 objectAtIndex:1] intValue];
		if(y1<y2){
			return NSOrderedAscending;
		} else if(y1>y2){
			return NSOrderedDescending;
		} else {
			if(x1<x2){
				return NSOrderedAscending;
			} else if (x1>x2){
				return NSOrderedDescending;
			} else {
				return NSOrderedSame;
			}
		}
    }];
    
    [objects release];
    
    for(int i=0; i<[orderedRes count]; i++){
        NSArray* currObj = [orderedRes objectAtIndex:i];
		
        SearchResult* searchRes = [[SearchResult alloc] initWithChapterIndex:currentChapterIndex pageIndex:([[currObj objectAtIndex:1] intValue]/webView.bounds.size.height) hitIndex:0 neighboringText:[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"unescape('%@')", [currObj objectAtIndex:2]]] originatingQuery:currentQuery];
        [results addObject:searchRes];
		[searchRes release];
    }
    
    [webView dealloc];
    
    [resultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    if((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count]){
        [self searchString:currentQuery inChapterAtIndex:(currentChapterIndex+1)];
    } else {
        epubViewController.searching = NO;
    }
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#if TARGET_OS_IPHONE
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.resultsTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif
@end
