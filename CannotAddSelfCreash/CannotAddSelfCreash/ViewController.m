//
//  ViewController.m
//  CannotAddSelfCreash
//
//  Created by run on 2018/12/24.
//  Copyright © 2018 run. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()  <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pushMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *pushOneButton;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"0";
  
  [self.pushOneButton addTarget:self action:@selector(pushOneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  [self.pushMoreButton addTarget:self action:@selector(pushMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushOneButtonClick:(id)sender {
  [self pushTestAnimation:YES title:@"4"];
}

- (void)pushMoreButtonClick:(id)sender {
  [self pushTestAnimation:NO title:@"1"];
  [self pushTestAnimation:YES title:@"2"];
  [self pushTestAnimation:YES title:@"3"];
}

- (void)pushTestAnimation:(BOOL)animated title:(NSString*)title {
  SecondViewController* secondVC = [[SecondViewController alloc] init];
  secondVC.navigationItem.title = title;
  [self.navigationController pushViewController:secondVC animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  NSLog(@"willShowViewController");
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  NSLog(@"didShowViewController");
}

@end
