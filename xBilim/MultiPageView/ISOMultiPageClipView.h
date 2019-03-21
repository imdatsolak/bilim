//
//  ISOClipView.h
//  xBilim
//
//  Created by Imdat Solak on 11/3/13.
//  Copyright (c) 2013 Imdat Solak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISOMultiPageView.h"
#import "ISOBookViewController.h"

@interface ISOMultiPageClipView : NSClipView
{
	IBOutlet id delegate;
}

- (void)setDelegate:(id)anObject;
- (id)delegate;
@end
