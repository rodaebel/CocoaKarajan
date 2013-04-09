//
//  KarajanAppDelegate.h
//  Karajan
//

#import <Cocoa/Cocoa.h>

@interface KarajanAppDelegate : NSObject <NSApplicationDelegate, NSNetServiceDelegate>
{
@private
    IBOutlet NSMenu *       statusMenu;
    IBOutlet NSMenuItem *   toggleServingMenuItem;
    NSStatusItem *          statusItem;
    NSString *              toggleServingMenuItemLabel;

    NSPipe *                p_in;
    NSPipe *                p_out;
    NSTask *                task;

    BOOL                    _serving;
    NSNetService *          _netService;
}

@property (readonly) NSString *toggleServingMenuItemLabel;

@property (readwrite) BOOL serving;

@property (nonatomic, retain, readwrite) NSNetService *netService;

- (IBAction)toggleServing:(id)sender;

- (BOOL)launchKarajan;

- (BOOL)stopKarajan;

- (IBAction)openPreferences:(id)sender;

@end
