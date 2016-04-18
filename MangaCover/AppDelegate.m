//
//  AppDelegate.m
//  MangaCover
//
//  Created by Jin Yifan on 14-10-9.
//  Copyright (c) 2014年 Jin Yifan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate


NSSize kSize = {512, 512};

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSNumberFormatter *formatter = [_number formatter];
    [formatter setMaximum:[NSNumber numberWithInt:999]];
    _page = 0;
    [_ind startAnimation:nil];
    [_ind stopAnimation:nil];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if ([_number intValue] == 0) {
        [_number setIntValue:1];
    }
    int remain = [_number intValue] % 10;
    if (remain == 1) {
        [_ordinal setStringValue:@"st image as cover"];
    }
    else if (remain == 2) {
        [_ordinal setStringValue:@"nd image as cover"];
    }
    else if (remain == 3) {
        [_ordinal setStringValue:@"rd image as cover"];
    }
    else {
        [_ordinal setStringValue:@"th image as cover"];
    }
}

- (void) start {
    [_dropper setHidden:YES];
    [_ind startAnimation:nil];
    [_label setStringValue:@"Setting Cover Icon"];
}

- (void) stop {
    [_ind stopAnimation:nil];
    [_dropper setHidden:NO];
    [_label setStringValue:@"Drag files here to add cover icon"];
}

- (void) addCover:(NSArray *)files {
    [self performSelectorInBackground:@selector(addCoverForFiles:) withObject:files];
}

- (void) addCoverForFile:(NSString *)file {
    
    XADArchive *archive = [XADArchive archiveForFile:file];
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    NSData *data = nil;
    
    for (int i = 0; i < [archive numberOfEntries]; ++i) {
        if (![archive entryIsDirectory:i]) {
            [marray addObject:[archive nameOfEntry:i]];
        }
    }
    
    [marray sortUsingSelector:@selector(caseInsensitiveCompare:)];
    //NSLog(@"%@",marray[0]);
    if (_page >= [marray count]) {
        _page = (int)[marray count] - 1;
    }
    
    for (int i = 0; i < [archive numberOfEntries]; ++i) {
        if ([[archive nameOfEntry:i] isEqualToString:marray[_page]]) {
            data = [archive contentsOfEntry:i];
            break;
        }
    }
    
    NSImage *img = [[NSImage alloc] initWithData:data];
    img = [img imageByScalingProportionallyToSize:kSize];
    [[NSWorkspace sharedWorkspace] setIcon:img forFile:file options:0];
}

- (void) addCoverForFiles:(NSArray *)files {
 //   [self start];
    [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
    
    for (NSString *file in files) {
        //NSLog(@"%@", file);
        NSString *ext = [file pathExtension];
        if ([ext caseInsensitiveCompare:@"zip"] == NSOrderedSame || [ext caseInsensitiveCompare:@"rar"] == NSOrderedSame || [ext caseInsensitiveCompare:@"7z"] == NSOrderedSame) {
            [self addCoverForFile:file];
        }
    }
  //  [self stop];
    [self performSelectorOnMainThread:@selector(stop) withObject:nil waitUntilDone:YES];

}

- (IBAction)openPref:(id)sender {
    [NSApp beginSheet:_prefWindow modalForWindow:_window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)endPref:(id)sender {
    //NSLog(@"%i", [number intValue]);
    _page = [_number intValue] - 1;
    [NSApp endSheet:_prefWindow];
    [_prefWindow orderOut:sender];
}

@end

@implementation NSImage (ProportionalScaling)

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize{
    NSImage* sourceImage = self;
    NSImage* newImage = nil;
    
    if ([sourceImage isValid]){
        NSSize imageSize = [sourceImage size];
        float width  = imageSize.width;
        float height = imageSize.height;
        
        float targetWidth  = targetSize.width;
        float targetHeight = targetSize.height;
        
        float scaleFactor  = 0.0;
        float scaledWidth  = targetWidth;
        float scaledHeight = targetHeight;
        
        NSPoint thumbnailPoint = NSZeroPoint;
        
        if ( NSEqualSizes( imageSize, targetSize ) == NO )
        {
            
            float widthFactor  = targetWidth / width;
            float heightFactor = targetHeight / height;
            
            if ( widthFactor < heightFactor )
                scaleFactor = widthFactor;
            else
                scaleFactor = heightFactor;
            
            scaledWidth  = width  * scaleFactor;
            scaledHeight = height * scaleFactor;
            
            if ( widthFactor < heightFactor )
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
            else if ( widthFactor > heightFactor )
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
        newImage = [[NSImage alloc] initWithSize:targetSize];
        [newImage lockFocus];
        NSRect thumbnailRect;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        [sourceImage drawInRect: thumbnailRect
                       fromRect: NSZeroRect
                      operation: NSCompositeSourceOver
                       fraction: 1.0];
        [newImage unlockFocus];
    }
    return newImage;
}
@end