//
//  KarajanPreferences.h
//  Karajan
//

#import <Cocoa/Cocoa.h>


@interface KarajanPreferences : NSWindowController {
    IBOutlet NSToolbar *toolbar;
    IBOutlet NSView *generalPreferenceView;
    IBOutlet NSView *advancedPreferenceView;
    int currentViewTag;
}

+ (KarajanPreferences *)sharedPrefsWindowController;

+ (NSString *)nibName;

- (NSView *)viewForTag:(int)tag;

- (IBAction)switchView:(id)sender;

- (NSRect)newFrameForNewContentView:(NSView *)view;

@end
