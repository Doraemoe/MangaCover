//
//  AppDelegate.h
//  MangaCover
//
//  Created by Jin Yifan on 14-10-9.
//  Copyright (c) 2014年 Jin Yifan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XADMaster/XADArchive.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSImageView *dropper;
@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSProgressIndicator *ind;
@property (weak) IBOutlet NSTextField *number;
@property (weak) IBOutlet NSTextField *ordinal;
@property (weak) IBOutlet NSMenuItem *pref;
@property (weak) IBOutlet NSWindow *prefWindow;
@property int page;

- (void) addCover: (NSArray *) files;
- (IBAction)openPref:(id)sender;
- (IBAction)endPref:(id)sender;
@end

@interface NSImage(ProportionalScaling)
- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize;
@end