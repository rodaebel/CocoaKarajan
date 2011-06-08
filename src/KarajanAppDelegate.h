//
//  KarajanAppDelegate.h
//  Karajan
//
//  Copyright 2011, Tobias Rodaebel
//

#import <Cocoa/Cocoa.h>

@interface KarajanAppDelegate : NSObject <NSApplicationDelegate> {
@private
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    IBOutlet NSMenuItem *toggleServingMenuItem;
    NSString *toggleServingMenuItemLabel;
    NSPipe *p_in, *p_out;
    NSTask *task;
    BOOL serving;
}

@property (readonly) NSString *toggleServingMenuItemLabel;

@property (readwrite) BOOL serving;

- (IBAction)toggleServing:(id)sender;

- (BOOL)launchKarajan;

- (BOOL)stopKarajan;

@end
