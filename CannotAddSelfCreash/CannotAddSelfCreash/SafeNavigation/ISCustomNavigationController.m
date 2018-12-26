//
//  ISCustomNavigationController.m
//  CannotAddSelfCreash
//
//  Created by run on 2018/12/25.
//  Copyright © 2018 run. All rights reserved.
//

#import "ISCustomNavigationController.h"

@interface ISCustomNavigationController ()

@end

@implementation ISCustomNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
  self = [super initWithRootViewController:rootViewController];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationBar.barTintColor = [UIColor redColor];
}

@end
