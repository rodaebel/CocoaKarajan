//
//  KarajanPreferences.h
//  Karajan
//

#import <Cocoa/Cocoa.h>


@interface KarajanPreferences : NSWindowController <NSToolbarDelegate>
{
@private
	IBOutlet NSToolbar *toolbar;
	IBOutlet NSView *generalPreferenceView;
	IBOutlet NSView *advancedPreferenceView;
	int currentViewTag;
	IBOutlet NSTextField *configPathTextField;
}

@property (getter = getIncomingPort, setter = setIncomingPort:) NSInteger incomingPort;

@property (getter = getOutgoingPort, setter = setOutgoingPort:) NSInteger outgoingPort;

+ (KarajanPreferences *)sharedPrefsWindowController;

+ (NSString *)nibName;

- (NSView *)viewForTag:(int)tag;

- (IBAction)switchView:(id)sender;

- (NSRect)newFrameForNewContentView:(NSView *)view;

- (IBAction)beginFilePicker:(id)sender;

- (IBAction)restoreDefaults:(id)sender;

@end
