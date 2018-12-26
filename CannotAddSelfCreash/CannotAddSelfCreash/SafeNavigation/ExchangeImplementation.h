//
//  ExchangeImplementation.h
//  CannotAddSelfCreash
//
//  Created by run on 2018/12/25.
//  Copyright © 2018 run. All rights reserved.
//

#ifndef ExchangeImplementation_h
#define ExchangeImplementation_h

#import <objc/runtime.h>

static inline BOOL ExchangeImplementationsInTwoClasses(Class _fromClass,
                                                       SEL _originSelector,
                                                       Class _toClass,
                                                       SEL _newSelector) {
  if (!_fromClass || !_toClass) {
    return NO;
  }
  
  Method oriMethod = class_getInstanceMethod(_fromClass, _originSelector);
  Method newMethod = class_getInstanceMethod(_toClass, _newSelector);
  if (!newMethod) {
    return NO;
  }
  
  BOOL isAddedMethod = class_addMethod(_fromClass, _originSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
  if (isAddedMethod) {
    // 如果 class_addMethod 成功了，说明之前 fromClass 里并不存在 originSelector，
    // 所以要用一个空的方法代替它，以避免 class_replaceMethod 后，后续 toClass 的这个方法被调用时可能会 crash
    IMP oriMethodIMP = method_getImplementation(oriMethod)
    ?: imp_implementationWithBlock(^(id selfObject){
    });
    const char* oriMethodTypeEncoding =
    method_getTypeEncoding(oriMethod) ?: "v@:";
    class_replaceMethod(_toClass, _newSelector, oriMethodIMP,
                        oriMethodTypeEncoding);
  } else {
    method_exchangeImplementations(oriMethod, newMethod);
  }
  return YES;
}

static inline BOOL ExchangeImplementations(Class _class, SEL _originSelector,
                                           SEL _newSelector) {
  return ExchangeImplementationsInTwoClasses(_class, _originSelector, _class,
                                             _newSelector);
}

#endif /* ExchangeImplementation_h */
