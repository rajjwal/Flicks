//
//  youTubePlayerViewController.m
//  Flicks
//
//  Created by Rajjwal Rawal on 2/11/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

#import "youTubePlayerViewController.h"

@interface youTubePlayerViewController ()

@end

@implementation youTubePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.playerView loadWithVideoId:@"M7lc1UVf-VE"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
