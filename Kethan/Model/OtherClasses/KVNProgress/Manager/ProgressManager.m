//
//  ProgressManager.m
//
//  Created by Arkenea
//

#import "ProgressManager.h"

@implementation ProgressManager

#pragma mark - Configrations -

+ (void)setupKVNProgress
{
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"Roboto-Regular" size:19.0];
    
    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    configuration.circleStrokeBackgroundColor = [UIColor clearColor];
    configuration.circleFillBackgroundColor = [UIColor clearColor];
    //configuration.backgroundFillColor = [UIColor redColor];
    configuration.backgroundFillColor = [UIColor colorWithRed:80.0/255.0 green:99.0/255.0 blue:140.0/255.0 alpha:0.8];
    configuration.backgroundTintColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
    configuration.successColor = [UIColor whiteColor];
    configuration.errorColor = [UIColor whiteColor];
    configuration.circleSize = 30.0;
    configuration.lineWidth = 1.2f;
    configuration.fullScreen = NO;
    configuration.allowUserInteraction = NO;
    configuration.minimumSuccessDisplayTime = 1.0f;
    configuration.minimumErrorDisplayTime = 1.0f;
    
    configuration.tapBlock = ^(KVNProgress *progressView) {
        
    };
    
    [KVNProgress setConfiguration: configuration];
}

#pragma mark - Loading -

+ (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress show];
    });
}

+ (void)showWithStatus: (NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showWithStatus: status];
    });
}

+ (void)showWithStatus: (NSString *)status
                onView: (UIView *)superview
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showWithStatus: status onView: superview];
    });
}

#pragma mark - Progress -

+ (void)showProgress: (CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showProgress: progress];
    });
}

+ (void)showProgress: (CGFloat)progress
              status: (NSString*)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showProgress: progress status: status];
    });
}

+ (void)showProgress: (CGFloat)progress
              status: (NSString *)status
              onView: (UIView *)superview
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showProgress: progress status: status onView: superview];
    });
}

#pragma mark - Success -

+ (void)showSuccess
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showSuccess];
    });
}

+ (void)showSuccessWithCompletion: (KVNCompletionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showSuccessWithCompletion: completion];
    });
}

+ (void)showSuccessWithStatus: (NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showSuccessWithStatus: status];
    });
}

+ (void)showSuccessWithStatus: (NSString *)status
                   completion: (KVNCompletionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showSuccessWithStatus: status completion: completion];
    });
}

+ (void)showSuccessWithStatus: (NSString *)status
                       onView: (UIView *)superview
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showSuccessWithStatus: status onView: superview];
    });
}

+ (void)showSuccessWithStatus: (NSString *)status
                       onView: (UIView *)superview
                   completion: (KVNCompletionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showSuccessWithStatus: status onView: superview completion: completion];
    });
}

#pragma mark - Error -

+ (void)showError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress showError];
    });
}

+ (void)showErrorWithCompletion: (KVNCompletionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isVisible]) {
            [self dismissWithCompletion:^{
                [KVNProgress showErrorWithCompletion: completion];
            }];
        } else {
            [KVNProgress showErrorWithCompletion: completion];
        }
    });
}

+ (void)showErrorWithStatus: (NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isVisible]) {
            [self dismissWithCompletion:^{
                [KVNProgress showErrorWithStatus: status];
            }];
        } else {
            [KVNProgress showErrorWithStatus: status];
        }
    });
}

+ (void)showErrorWithStatus: (NSString *)status
                 completion: (KVNCompletionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isVisible]) {
            [self dismissWithCompletion:^{
                [KVNProgress showErrorWithStatus: status completion: completion];
            }];
        } else {
            [KVNProgress showErrorWithStatus: status completion: completion];
        }
    });
}

+ (void)showErrorWithStatus: (NSString *)status
                     onView: (UIView *)superview
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isVisible]) {
            [self dismissWithCompletion:^{
                [KVNProgress showErrorWithStatus: status onView: superview];
            }];
        } else {
            [KVNProgress showErrorWithStatus: status onView: superview];
        }
    });
}

+ (void)showErrorWithStatus: (NSString *)status
                     onView: (UIView *)superview
                 completion: (KVNCompletionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isVisible]) {
            [self dismissWithCompletion:^{
                [KVNProgress showErrorWithStatus: status onView: superview completion: completion];
            }];
        } else {
            [KVNProgress showErrorWithStatus: status onView: superview completion: completion];
        }
    });
}

+ (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
}

+ (void)dismissWithCompletion: (KVNCompletionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismissWithCompletion: completion];
    });
}

#pragma mark - Update

+ (void)updateStatus: (NSString*)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress updateStatus: status];
    });
}

+ (void)updateProgress: (CGFloat)progress
              animated: (BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress updateProgress: progress animated: animated];
    });
}

#pragma mark - Information

+ (BOOL)isVisible
{
    return [KVNProgress isVisible];
}

@end
