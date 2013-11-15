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
    
    CGFloat width = _scrollView.bounds.size.height;
    CGFloat scrollViewWidth = width * 10 + (self.view.bounds.size.width - width);
    _scrollView.contentSize = CGSizeMake(scrollViewWidth, width);
    for (NSInteger i = 0; i < 10; i++) {
        UIView *view = [self viewWithLabelText:[NSString stringWithFormat:@"%d", i + 1]];
        view.frame = CGRectOffset(view.frame, i * width, 0.0f);
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
    _baseContentOffset = _scrollView.contentOffset.x;
    [_scrollView flashScrollIndicators];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{

//    CGFloat width = _scrollView.bounds.size.height;
//    NSInteger maxIndex = 10 - 1;
//    CGFloat targetX = _scrollView.contentOffset.x + velocity.x * 30.0f;
//    NSInteger targetIndex = lroundf(targetX / width);
//    if (targetIndex < 0)
//        targetIndex = 0;
//    if (targetIndex > maxIndex)
//        targetIndex = maxIndex;
//    targetContentOffset->x = targetIndex * width;
//    NSLog(@"%ld", targetIndex);
    
    CGFloat width = _scrollView.bounds.size.height;
    if (velocity.x < 0) {
        _baseContentOffset = MAX(0, _baseContentOffset - width);
    } else if (velocity.x > 0) {
        _baseContentOffset = MIN(width * 9, _baseContentOffset + width);
    }
    targetContentOffset->x = _baseContentOffset;

}

#pragma mark - Internal

- (UIView *)viewWithLabelText:(NSString *)text
{
    CGFloat width = _scrollView.bounds.size.height;
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
