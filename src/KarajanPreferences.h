//
//  KarajanPreferences.h
//  Karajan
//

#import <Cocoa/Cocoa.h>


@interface KarajanPreferences : NSWindowController <NSToolbarDelegate> {
@private
    IBOutlet NSToolbar *toolbar;
    IBOutlet NSView *generalPreferenceView;
    IBOutlet NSView *advancedPreferenceView;
    int currentViewTag;
    IBOutlet NSTextField *configPathTextField;
}

+ (KarajanPreferences *)sharedPrefsWindowController;

+ (NSString *)nibName;

- (NSView *)viewForTag:(int)tag;

- (IBAction)switchView:(id)sender;

- (NSRect)newFrameForNewContentView:(NSView *)view;

- (IBAction)beginFilePicker:(id)sender;

- (void)filePickerDidEnd:(NSSavePanel *)save returnCode:(int)returnCode context:(void*)context;

- (IBAction)restoreDefaults:(id)sender;

@end
