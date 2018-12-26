//
//  SecondViewController.m
//  CannotAddSelfCreash
//
//  Created by run on 2018/12/24.
//  Copyright © 2018 run. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1];
}

@end
