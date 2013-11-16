//
//  ViewController.m
//  SnapScroll
//
//  Created by Christian Mittendorf on 15.11.13.
//  Copyright (c) 2013 Christian Mittendorf. All rights reserved.
//

#import "ViewController.h"

@interface UIColor (RandomColor)

+ (UIColor *)randomColor;

@end

@implementation UIColor (RandomColor)

+ (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(255) / 100.0f;
    CGFloat g = arc4random_uniform(255) / 100.0f;
    CGFloat b = arc4random_uniform(255) / 100.0f;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

@end

@interface ViewController () <UIScrollViewDelegate>
@property (assign) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController
{
    CGFloat _baseContentOffset;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _scrollView.pagingEnabled = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    CGFloat width = _scrollView.bounds.size.width;
    CGFloat scrollViewHeight = width * 10 + (self.view.bounds.size.height - width);
    _scrollView.contentSize = CGSizeMake(width, scrollViewHeight);
    for (NSInteger i = 0; i < 10; i++) {
        UIView *view = [self viewWithLabelText:[NSString stringWithFormat:@"%ld", i + 1]];
        view.frame = CGRectOffset(view.frame, 0.0f, i * width);
        [_scrollView addSubview:view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Livecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _baseContentOffset = _scrollView.contentOffset.y;
    [_scrollView flashScrollIndicators];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat width = _scrollView.bounds.size.width;
    if (velocity.y < 0) {
        _baseContentOffset = MAX(0, _baseContentOffset - width);
    } else if (velocity.y > 0) {
        _baseContentOffset = MIN(width * 9, _baseContentOffset + width);
    }

    // Setting the targetContentOffset->y will add a smal "jump" at the last item
    // targetContentOffset->y = _baseContentOffset;

    // Using this approach avoids the jump and smoothes the animation
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake(0, _baseContentOffset) animated:YES];
    });
}

#pragma mark - Internal

- (UIView *)viewWithLabelText:(NSString *)text
{
    CGFloat width = _scrollView.bounds.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, width)];
    view.backgroundColor = [UIColor randomColor];
    view.layer.bounds = CGRectInset(view.layer.bounds, 6, 6);
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(width * 0.65f)];
    [label sizeToFit];
    label.center = view.center;
    [view addSubview:label];
                    
    return view;
}

@end
