//
//  KOViewController.m
//  VersionUpManager
//
//  Created by kmk on 03/28/2017.
//  Copyright (c) 2017 kmk. All rights reserved.
//

#import "KOViewController.h"
#import <VersionUpManager/VersionUpManager.h>


@interface KOViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblOldVer;
@property (weak, nonatomic) IBOutlet UILabel *lblNewVer;

@end

@implementation KOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[VersionUpManager sharedManager] runVersionUpdateProcessIfNeedsWith:^(NSString *oldVer, NSString *newVer) {
        NSLog(@"oldVer:%@, newVer:%@",oldVer, newVer);
        _lblOldVer.text = [NSString stringWithFormat:@"oldVer:%@", oldVer];
        _lblNewVer.text = [NSString stringWithFormat:@"newVer:%@", newVer];
    }];
    
    [[VersionUpManager sharedManager] runOnceWithToken:@"token" onProcessBlock:^(NSString *oldVer, NSString *newVer) {
        NSLog(@"only run once with [token].");
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
