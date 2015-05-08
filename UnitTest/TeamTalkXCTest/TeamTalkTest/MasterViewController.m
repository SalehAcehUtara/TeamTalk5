//
//  MasterViewController.m
//  TeamTalkTest
//
//  Created by Bjoern Rasmussen on 4-01-15.
//  Copyright (c) 2015 BearWare.dk. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#include "../../../TeamTalk_DLL/TeamTalk.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSString* str = [[NSString alloc]initWithUTF8String:TT_GetVersion()];
    NSLog(@"This is some TTT messsage %@", str);
    
    TTInstance* ttInst = TT_InitTeamTalkPoll();
    TT_InitSoundInputDevice(ttInst, 0);
    TT_InitSoundOutputDevice(ttInst, 0);
    TT_GetMyUserID(ttInst);
    TT_GetMyChannelID(ttInst);
    TT_GetRootChannelID(ttInst);
    TT_DBG_SetSoundInputTone(ttInst, STREAMTYPE_VOICE, 440);
    Channel chan;
    TT_DoJoinChannel(ttInst, &chan);
    TT_Connect(ttInst, "foo", 10333, 10333, 0, 0, FALSE);
    TT_DoSubscribe(ttInst, 0, 0);
    TT_DoJoinChannelByID(ttInst, 0, "");
    TT_GetMessage(ttInst, NULL, NULL);
    TT_StartSoundLoopbackTest(0, 0, 16000, 1, FALSE, NULL);
    TT_DoLogin(ttInst, "", "", "");
    TT_DoTextMessage(ttInst, NULL);
    TT_EnableAudioBlockEvent(ttInst, 0, 0, FALSE);
    TT_EnableVoiceTransmission(ttInst, FALSE);
    TT_CloseSoundLoopbackTest(ttInst);
    TT_GetSoundDevices(NULL, 0);
    
    TT_CloseTeamTalk(ttInst);
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
