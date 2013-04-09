//
//  KarajanAppDelegate.m
//  Karajan
//

#import "KarajanAppDelegate.h"
#import "KarajanPreferences.h"

@implementation KarajanAppDelegate

@synthesize toggleServingMenuItemLabel;

@synthesize serving = _serving;

@synthesize netService = _netService;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.serving = NO;
}

- (void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setImage:[NSImage imageNamed:@"Karajan.png"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"Karajan_alt.png"]];
    [statusItem setHighlightMode:YES];
}

#pragma mark - NSApplicationDelegate Protocol Methods

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    if (self.serving)
        [self stopKarajan];

    return NSTerminateNow;
}

#pragma mark - Karajan API

- (NSString *)toggleServingMenuItemLabel
{
    return (self.serving) ? NSLocalizedString(@"stop", @"Launch Karajan") : NSLocalizedString(@"start", @"Stop Karajan");
}

- (IBAction)toggleServing:(id)sender
{
    [self willChangeValueForKey:@"toggleServingMenuItemLabel"];
    self.serving = (self.serving) ? [self stopKarajan] : [self launchKarajan];
    [self didChangeValueForKey:@"toggleServingMenuItemLabel"];
}

- (void)dataReady:(NSNotification *)n
{
    NSData *data = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];

    if ([data length])
        NSLog(@"%@", [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding]);

    if (task)
        [[p_out fileHandleForReading] readInBackgroundAndNotify];
}

- (void)taskTerminated:(NSNotification *)note
{    
    if (self.netService != nil) {
        [self.netService setDelegate:nil];
        [self.netService stop];
        self.netService = nil;
    }

    [task release];
    task = nil;
    [p_in release];
    p_in = nil;
    [p_out release];
    p_out = nil;

    [self willChangeValueForKey:@"toggleServingMenuItemLabel"];
    self.serving = NO;
    [self didChangeValueForKey:@"toggleServingMenuItemLabel"];
}

- (BOOL)launchKarajan
{
    NSLog(@"Launching");
    p_in  = [[NSPipe alloc] init];
    p_out = [[NSPipe alloc] init];
    task  = [[NSTask alloc] init];

    NSString *bundleResourcePath = [[NSBundle mainBundle] resourcePath];

    NSString *erlPath = [NSString stringWithFormat:@"%@/lib/erlang/bin/erl", bundleResourcePath];
    NSString *karajandPath = [NSString stringWithFormat:@"%@/Karajan/bin/karajand", bundleResourcePath];
    NSString *configPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"configPath"];
    NSString *modulesPath = ([configPath length] == 0) ? @"" : [NSString stringWithFormat:@"--path=%@", [configPath stringByDeletingLastPathComponent]];

    KarajanPreferences *preferences = [KarajanPreferences sharedPrefsWindowController];
    NSString *incomingPort = [NSString stringWithFormat:@"--incoming-port=%ld", preferences.incomingPort];

    NSString *karajandConfig = [NSString stringWithFormat:@"--config=%@", configPath];

    [task setStandardInput:p_in];
    [task setStandardOutput:p_out];

    NSDictionary *environ = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSHomeDirectory(), erlPath, nil] forKeys:[NSArray arrayWithObjects:@"HOME", @"ERL", nil]];

    [task setEnvironment:environ];
    [task setLaunchPath:karajandPath];
    [task setArguments:[NSArray arrayWithObjects:modulesPath, karajandConfig, incomingPort, nil]];

    NSFileHandle *fh = [p_out fileHandleForReading];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(dataReady:) name:NSFileHandleReadCompletionNotification object:fh];

    [nc addObserver:self selector:@selector(taskTerminated:) name:NSTaskDidTerminateNotification object:task];

    [task launch];

    [fh readInBackgroundAndNotify];

    NSString *serviceName = [NSString stringWithFormat:@"%@ (Karajan)", [[NSHost currentHost] localizedName]];

    self.netService = [[[NSNetService alloc] initWithDomain:@"" type:@"_osc._udp." name:serviceName port:(int)preferences.incomingPort] autorelease];
    if (self.netService != nil) {
        [self.netService setDelegate:self];
        [self.netService publishWithOptions:0];
    }

    return YES;
}

- (BOOL)stopKarajan
{
    NSLog(@"Stopping");

    [task terminate];

    return NO;
}

- (IBAction)openPreferences:(id)sender
{
    [[KarajanPreferences sharedPrefsWindowController] showWindow:nil];
    (void)sender;
}

@end
