//
//  DropView.h
//  MangaCover
//
//  Created by Jin Yifan on 14-10-9.
//  Copyright (c) 2014年 Jin Yifan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@interface DropView : NSImageView {
    IBOutlet AppDelegate *ctrl;
}

- (id)initWithCoder:(NSCoder *)aDecoder;

@end
