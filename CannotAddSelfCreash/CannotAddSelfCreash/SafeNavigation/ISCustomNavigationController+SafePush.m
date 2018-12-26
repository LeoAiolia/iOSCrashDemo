//
//  ISCustomNavigationController+SafePush.m
//  CannotAddSelfCreash
//
//  Created by run on 2018/12/25.
//  Copyright © 2018 run. All rights reserved.
//

#import "ISCustomNavigationController+SafePush.h"
#import "ExchangeImplementation.h"

static char const* const objectTagKey = "objectTag";

@interface ISCustomNavigationController () <UINavigationControllerDelegate>

@property(readwrite, getter=isViewTransitionInProgress) BOOL viewTransitionInProgress;

@end

@implementation ISCustomNavigationController (SafePush)

- (void)setViewTransitionInProgress:(BOOL)property {
  NSNumber* number = [NSNumber numberWithBool:property];
  objc_setAssociatedObject(self, objectTagKey, number, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isViewTransitionInProgress {
  NSNumber* number = objc_getAssociatedObject(self, objectTagKey);
  return [number boolValue];
}

#pragma mark - Intercept Pop, Push, PopToRootVC

- (NSArray*)safePopToRootViewControllerAnimated:(BOOL)animated {
  if (self.viewTransitionInProgress) return nil;
  if (animated) {
    self.viewTransitionInProgress = YES;
  }
  return [self safePopToRootViewControllerAnimated:animated];
}
- (NSArray*)safePopToViewController:(UIViewController*)viewController
                           animated:(BOOL)animated {
  if (self.viewTransitionInProgress) return nil;
  if (animated) {
    self.viewTransitionInProgress = YES;
  }
  
  return [self safePopToViewController:viewController animated:animated];
}
- (UIViewController*)safePopViewControllerAnimated:(BOOL)animated {
  if (self.viewTransitionInProgress) return nil;
  if (animated) {
    self.viewTransitionInProgress = YES;
  }
  
  return [self safePopViewControllerAnimated:animated];
}

- (void)safePushViewController:(UIViewController*)viewController
                      animated:(BOOL)animated {
  self.delegate = self;
  
  if (self.isViewTransitionInProgress == NO) {
    [self safePushViewController:viewController animated:animated];
    if (animated) {
      self.viewTransitionInProgress = YES;
    }
  }
}

- (void)navigationController:(UINavigationController*)navigationController
       didShowViewController:(UIViewController*)viewController
                    animated:(BOOL)animated {
  self.viewTransitionInProgress = NO;
}

- (void)navigationController:(UINavigationController*)navigationController
      willShowViewController:(UIViewController*)viewController
                    animated:(BOOL)animated {
  id<UIViewControllerTransitionCoordinator> topVcCoordinator =
  navigationController.topViewController.transitionCoordinator;
  void (^block)(void) = ^{
    self.viewTransitionInProgress = NO;
    self.interactivePopGestureRecognizer.delegate = (id)viewController;
    [self.interactivePopGestureRecognizer setEnabled:YES];
  };
  if (@available(iOS 10_0, *)) {
    [topVcCoordinator
     notifyWhenInteractionChangesUsingBlock:^(
                                              id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
       block();
     }];
  } else {
    [topVcCoordinator notifyWhenInteractionEndsUsingBlock:^(id context) {
      block();
    }];
  }
  
  if (navigationController.delegate != self) {
    [navigationController.delegate navigationController:navigationController
                                 willShowViewController:viewController
                                               animated:animated];
  }
}
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class cls = [self class];
    ExchangeImplementations(cls, @selector(pushViewController:animated:),
                            @selector(safePushViewController:animated:));
    
    ExchangeImplementations(cls, @selector(popViewControllerAnimated:),
                            @selector(safePopViewControllerAnimated:));
    
    ExchangeImplementations(cls, @selector(popToRootViewControllerAnimated:),
                            @selector(safePopToRootViewControllerAnimated:));
    
    ExchangeImplementations(cls, @selector(popToViewController:animated:),
                            @selector(safePopToViewController:animated:));
  });
}

@end
