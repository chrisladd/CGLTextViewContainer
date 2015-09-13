//
//  CGLHackedTextViewContainer.m
//  SFN
//
//  Created by Christopher Ladd on 9/13/15.
//  Copyright © 2015 Christopher Ladd. All rights reserved.
//

#import "CGLHackedTextViewContainer.h"

@interface CGLHackedTextViewContainer () <UITextViewDelegate>

@property (strong, nonatomic, readwrite) UITextView *textView;
@property (assign, nonatomic) NSRange previousSelectedRange;
@property (assign, nonatomic) BOOL useLinearNextScrollAnimation;
@property (assign, nonatomic) BOOL ignoreNextTextSelectionAnimation;

@end

#define SLOW_DURATION 0.4f
#define FAST_DURATION 0.2f


@implementation CGLHackedTextViewContainer
@synthesize textViewDelegate = _textViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)maxTextContainerHeight {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentSize = frame.size;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        NSTextStorage *textStorage = [[NSTextStorage alloc] init];
        
        // Setup TextKit stack for the private text view.
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [textStorage addLayoutManager:layoutManager];
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.frame.size.width, maxTextContainerHeight)];
        container.widthTracksTextView = YES;
        [layoutManager addTextContainer:container];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0,
                                                                     0.0,
                                                                     CGRectGetWidth(self.frame),
                                                                     maxTextContainerHeight)
                                            textContainer:container];
        
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.textView];
        self.textView.showsHorizontalScrollIndicator = NO;
        self.textView.showsVerticalScrollIndicator = NO;
        [self.textView setAlwaysBounceHorizontal:NO];
        [self.textView setAlwaysBounceVertical:NO];
        [self.textView setScrollsToTop:NO];
        [self.textView setDelegate:self];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame height:100000];
}

- (void)updateContentSize:(BOOL)scrollToVisible delay:(CGFloat)delay {
    CGRect boundingRect = [self.textView.layoutManager usedRectForTextContainer:self.textView.textContainer];
    boundingRect.size.height = roundf(boundingRect.size.height +
                                      self.textView.textContainerInset.top +
                                      self.textView.textContainerInset.bottom);
    
    boundingRect.size.width = CGRectGetWidth(self.bounds);
    [self setContentSize:boundingRect.size];
    [self.textView setNeedsDisplay];
    
    if (scrollToVisible) {
        if (delay) {
            __weak typeof (self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setUseLinearNextScrollAnimation:NO];
                [weakSelf simpleScrollToCaret];
            });
        } else {
            [self setUseLinearNextScrollAnimation:NO];
            [self simpleScrollToCaret];
        }
    }
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    // Fixes a bug that breaks scrolling to top via status bar taps.
    [super setContentOffset:self.contentOffset animated:NO];
    
    contentOffset = CGPointMake(0, roundf(contentOffset.y));
    CGFloat duration;
    UIViewAnimationOptions options;
    if (self.useLinearNextScrollAnimation) {
        duration = (animated) ? SLOW_DURATION : 0;
        options = UIViewAnimationOptionCurveLinear
        | UIViewAnimationOptionBeginFromCurrentState
        | UIViewAnimationOptionOverrideInheritedDuration
        | UIViewAnimationOptionOverrideInheritedCurve;
    } else {
        duration = (animated) ? FAST_DURATION : 0;
        options = UIViewAnimationOptionCurveEaseInOut
        | UIViewAnimationOptionBeginFromCurrentState
        | UIViewAnimationOptionOverrideInheritedDuration
        | UIViewAnimationOptionOverrideInheritedCurve;
    }
    [self setUseLinearNextScrollAnimation:NO];
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [super setContentOffset:contentOffset];
    } completion:nil];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    // Update the content size in setFrame: (rather than layoutSubviews)
    // because self is a UIScrollView and we don't need to update the
    // content size every time the scroll view calls layoutSubviews,
    // which is often.
    
    // Set delay to YES to boot the scroll animation to the next runloop,
    // or else the scrollRectToVisible: call will be
    // cancelled out by the animation context in which setFrame: is
    // usually called.
    
    [self updateContentSize:YES delay:YES];
}
- (void)simpleScrollToCaret {
    CGRect caretRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
    [self scrollToCaretRect:caretRect];
}

- (void)scrollToCaretRect:(CGRect)caretRect {
    CGRect visibleRect = CGRectMake(CGRectGetMinX(caretRect) - self.textView.contentInset.bottom,
                                    CGRectGetMinY(caretRect),
                                    CGRectGetWidth(caretRect),
                                    CGRectGetHeight(caretRect) + (self.textView.contentInset.bottom * 2.0));
    
    [self scrollRectToVisible:visibleRect animated:YES];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL shouldChange = YES;
    if ([self.textViewDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        shouldChange = [self.textViewDelegate textView:self.textView shouldChangeTextInRange:range replacementText:text];
    }
    if (shouldChange) {
        // Ignore the next animation that would otherwise be triggered by the cursor moving
        // to a new spot. We animate to chase after the cursor as you type via the updateContentSize:(BOOL)scrollToVisible
        // method. Most of the time, we want to also animate inside of textViewDidChangeSelection:, but only when
        // that change is a "true" text selection change, and not the implied change that occurs when a new character is
        // typed or deleted.
        [self setIgnoreNextTextSelectionAnimation:YES];
    }
    return shouldChange;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateContentSize:YES delay:NO];
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textViewDelegate textViewDidChange:self.textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSRange selectedRange = textView.selectedRange;
    if (self.ignoreNextTextSelectionAnimation == YES) {
        [self setIgnoreNextTextSelectionAnimation:NO];
    } else if (selectedRange.length != textView.textStorage.length) {
        if (selectedRange.length == 0 || selectedRange.location < self.previousSelectedRange.location) {
            // Scroll to start caret
            CGRect caretRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.start];
            [self setUseLinearNextScrollAnimation:YES];
            [self scrollToCaretRect:caretRect];
        }
        else if (selectedRange.location > self.previousSelectedRange.location) {
            CGRect firstRect = [textView firstRectForRange:textView.selectedTextRange];
            CGFloat bottomVisiblePointY = self.contentOffset.y + self.frame.size.height - self.contentInset.top - self.contentInset.bottom;
            if (firstRect.origin.y > bottomVisiblePointY - firstRect.size.height*1.1) {
                // Scroll to start caret
                CGRect caretRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.start];
                [self setUseLinearNextScrollAnimation:YES];
                [self scrollToCaretRect:caretRect];
            }
        }
        else if (selectedRange.location == self.previousSelectedRange.location) {
            // Scroll to end caret
            CGRect caretRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
            [self setUseLinearNextScrollAnimation:YES];
            [self scrollToCaretRect:caretRect];
        }
    }
    [self setPreviousSelectedRange:selectedRange];
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.textViewDelegate textViewDidChangeSelection:self.textView];
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.textViewDelegate respondsToSelector:_cmd]) {
        return [self.textViewDelegate textViewShouldBeginEditing:textView];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.textViewDelegate respondsToSelector:_cmd]) {
        return [self.textViewDelegate textViewShouldEndEditing:textView];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textViewDelegate respondsToSelector:_cmd]) {
        [self.textViewDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.textViewDelegate respondsToSelector:_cmd]) {
        [self.textViewDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([self.textViewDelegate respondsToSelector:_cmd]) {
        return [self.textViewDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if ([self.textViewDelegate respondsToSelector:_cmd]) {
        return [self.textViewDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    
    return NO;
}

@end
