//
//  ViewController.m
//  SimulateQQRecord
//
//  Created by trq on 17/3/20.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import "ViewController.h"
#import "SRView.h"


@interface ViewController ()<SRViewDelegate>
@property (nonatomic, strong) SRView *viewSR;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRecordView:(id)sender {
    //NSMicrophoneUsageDescription
    [self.view addSubview:self.viewSR];
}

- (SRView *)viewSR {
    if (!_viewSR) {
        _viewSR = [SRView createSRView];
        _viewSR.delegate = self;
        _viewSR.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-kSRViewHeight, CGRectGetWidth([UIScreen mainScreen].bounds), kSRViewHeight);
    }
    return _viewSR;
}

- (void)sr_viewDidCancel:(SRView *)view_SR {
    
}

- (void)sr_viewDidConfirm:(SRView *)view_SR recordPath:(NSString *)path duration:(NSString *)duration {
    
}

@end
