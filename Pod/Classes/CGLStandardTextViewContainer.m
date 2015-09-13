//
//  CGLStandardTextViewContainer.m
//  SFN
//
//  Created by Christopher Ladd on 9/13/15.
//  Copyright © 2015 Christopher Ladd. All rights reserved.
//

#import "CGLStandardTextViewContainer.h"

@implementation CGLStandardTextViewContainer

- (UITextView *)textView {
    return self;
}

- (void)setTextViewDelegate:(id<UITextViewDelegate>)textViewDelegate {
    self.delegate = textViewDelegate;
}

- (id <UITextViewDelegate>)textViewDelegate {
    return self.textView.delegate;
}

@end
