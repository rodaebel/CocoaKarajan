//
//  KarajanPreferences.m
//  Karajan
//

#import "KarajanPreferences.h"

static KarajanPreferences *_sharedPrefsWindowController = nil;


@implementation KarajanPreferences

+ (KarajanPreferences *)sharedPrefsWindowController
{
    if (!_sharedPrefsWindowController) {
        _sharedPrefsWindowController = [[self alloc] initWithWindowNibName:[self nibName]];
    }
    return _sharedPrefsWindowController;
}

+ (NSString *)nibName
{
    return @"Preferences";
}

- (void) dealloc {
    [super dealloc];
}

- (void)awakeFromNib{
    [self.window setContentSize:[generalPreferenceView frame].size];
    [[self.window contentView] addSubview:generalPreferenceView];
    [toolbar setSelectedItemIdentifier:@"General"];
    [self.window center];
}

- (NSView *)viewForTag:(int)tag {
    NSView *view = nil;
    switch(tag) {
        case 0: default: view = generalPreferenceView; break;
        case 1: view = advancedPreferenceView; break;
    }
    return view;
}

- (NSRect)newFrameForNewContentView:(NSView *)view {
    NSRect newFrameRect = [self.window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [self.window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;    
    NSRect frame = [self.window frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);

    return frame;
}

- (IBAction)switchView:(id)sender {
    int tag = (int)[sender tag];

    NSView *view = [self viewForTag:tag];
    NSView *previousView = [self viewForTag:currentViewTag];
    currentViewTag = tag;
    NSRect newFrame = [self newFrameForNewContentView:view];

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.1];

    if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
        [[NSAnimationContext currentContext] setDuration:1.0];

    [[[self.window contentView] animator] replaceSubview:previousView with:view];
    [[self.window animator] setFrame:newFrame display:YES];

    [NSAnimationContext endGrouping];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)aToolbar {
    return [[aToolbar items] valueForKey:@"itemIdentifier"];
}

@end