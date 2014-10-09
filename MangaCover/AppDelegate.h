//
//  AppDelegate.h
//  MangaCover
//
//  Created by Jin Yifan on 14-10-9.
//  Copyright (c) 2014年 Jin Yifan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import <zipzap/zipzap.h>
#import <XADMaster/XADArchive.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSImageView *dropper;
    IBOutlet NSTextField *label;
    IBOutlet NSProgressIndicator *ind;
}

- (void) addCover: (NSArray *) files;
@end

@interface NSImage(ProportionalScaling)
- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize;
@end