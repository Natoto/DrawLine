//
//  ViewController.m
//  DrawLine
//
//  Created by boob on 2017/8/14.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "ViewController.h"
#import "PENGDrawLineView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PENGDrawLineView *drawview;

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

- (IBAction)buttonTap:(id)sender {
    [self.drawview goBack];
}

@end
