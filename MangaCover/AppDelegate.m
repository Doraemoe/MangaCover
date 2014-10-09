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
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void) start {
    [dropper setHidden:YES];
    [ind setHidden:NO];
    [ind startAnimation:nil];
    [label setStringValue:@"Setting Cover Icon"];
}

- (void) stop {
    [ind stopAnimation:nil];
    [ind setHidden:YES];
    [dropper setHidden:NO];
    [label setStringValue:@"Drag files here to add cover icon"];
}

- (void) addCover:(NSArray *)files {
    [self performSelectorInBackground:@selector(addCoverForFiles:) withObject:files];
}
/*
- (void) addZipCoverForFile:(NSString *)file {
    //NSLog(@"%@", file);
    ZZArchive *archive = [ZZArchive archiveWithURL:[NSURL fileURLWithPath:file] error:nil];
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    NSData *data = nil;
    
    for (ZZArchiveEntry *entry in archive.entries) {
        if (!(entry.fileMode & S_IFDIR)) {
            [marray addObject:[entry fileName]];
            //NSLog(@"%@", [entry fileName]);
        }
    }
    
    [marray sortUsingSelector:@selector(compare:)];
    
    for (ZZArchiveEntry *entry in archive.entries) {
        if ([entry.fileName isEqualToString:marray[0]]) {
            data = [entry newDataWithError:nil];
            break;
        }
    }
    
    NSImage *img = [[NSImage alloc] initWithData:data];
    img = [img imageByScalingProportionallyToSize:kSize];
    [[NSWorkspace sharedWorkspace] setIcon:img forFile:file options:0];
}
*/
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
    
    for (int i = 0; i < [archive numberOfEntries]; ++i) {
        if ([[archive nameOfEntry:i] isEqualToString:marray[0]]) {
            data = [archive contentsOfEntry:i];
            break;
        }
    }
    
    NSImage *img = [[NSImage alloc] initWithData:data];
    img = [img imageByScalingProportionallyToSize:kSize];
    [[NSWorkspace sharedWorkspace] setIcon:img forFile:file options:0];
}

- (void) addCoverForFiles:(NSArray *)files {
    [self start];
    
    for (NSString *file in files) {
        //NSLog(@"%@", file);
        NSString *ext = [file pathExtension];
        if ([ext caseInsensitiveCompare:@"zip"] == NSOrderedSame || [ext caseInsensitiveCompare:@"rar"] == NSOrderedSame || [ext caseInsensitiveCompare:@"7z"] == NSOrderedSame) {
            [self addCoverForFile:file];
        }
    }
    [self stop];
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