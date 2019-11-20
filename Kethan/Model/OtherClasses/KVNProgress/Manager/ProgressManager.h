//
//  ProgressManager.h
//
//  Created by Arkenea
//

#import <Foundation/Foundation.h>

#import "KVNProgress.h"

@interface ProgressManager: NSObject

#pragma mark - Configrations -

+ (void)setupKVNProgress;

#pragma mark - Loading -

+ (void)show;

+ (void)showWithStatus: (NSString *)status;

+ (void)showWithStatus: (NSString *)status
                onView: (UIView *)superview;

#pragma mark - Progress -

+ (void)showProgress: (CGFloat)progress;

+ (void)showProgress: (CGFloat)progress
              status: (NSString*)status;

+ (void)showProgress: (CGFloat)progress
              status: (NSString *)status
              onView: (UIView *)superview;

#pragma mark - Success -

+ (void)showSuccess;

+ (void)showSuccessWithCompletion: (KVNCompletionBlock)completion;

+ (void)showSuccessWithStatus: (NSString *)status;

+ (void)showSuccessWithStatus: (NSString *)status
                   completion: (KVNCompletionBlock)completion;

+ (void)showSuccessWithStatus: (NSString *)status
                       onView: (UIView *)superview;

+ (void)showSuccessWithStatus: (NSString *)status
                       onView: (UIView *)superview
                   completion: (KVNCompletionBlock)completion;

#pragma mark - Error -

+ (void)showError;

+ (void)showErrorWithCompletion: (KVNCompletionBlock)completion;

+ (void)showErrorWithStatus: (NSString *)status;

+ (void)showErrorWithStatus: (NSString *)status
                 completion: (KVNCompletionBlock)completion;

+ (void)showErrorWithStatus: (NSString *)status
                     onView: (UIView *)superview;

+ (void)showErrorWithStatus: (NSString *)status
                     onView: (UIView *)superview
                 completion: (KVNCompletionBlock)completion;

#pragma mark - Dimiss

+ (void)dismiss;

+ (void)dismissWithCompletion: (KVNCompletionBlock)completion;

#pragma mark - Update

+ (void)updateStatus: (NSString*)status;

+ (void)updateProgress: (CGFloat)progress
              animated: (BOOL)animated;

#pragma mark - Information

+ (BOOL)isVisible;

@end
