//
//  CGLViewController.m
//  CGLTextViewContainer
//
//  Created by Chris Ladd on 04/05/2015.
//  Copyright (c) 2014 Chris Ladd. All rights reserved.
//

#import "CGLViewController.h"
#import <CGLTextViewContainer/CGLTextViewContainer.h>

@interface CGLViewController ()
@property (nonatomic) CGLTextViewContainer *textViewContainer;
@end

@implementation CGLViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up your text view, with a height (optionally) that you want to set your
    // internal text view to be.
    self.textViewContainer = [[CGLTextViewContainer alloc] initWithFrame:self.view.bounds height:200000];

    
    // optionally configure the underlying text view how you'd like it.
    self.textViewContainer.textView.typingAttributes = @{
                                                         NSFontAttributeName : [UIFont fontWithName:@"Menlo-BoldItalic" size:18.0]
                                                         };
    
    self.textViewContainer.textView.textContainerInset = UIEdgeInsetsMake(40.0,
                                                                          20.0,
                                                                          40.0,
                                                                          20.0);
    // and: don't you dare alter the delegate of the text view container's underlying text view. Either use the pass-through delegate or, as here, subscribe to notifications, being sure to set yourself as the delegate.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextViewChanged:) name:UITextViewTextDidChangeNotification object:self.textViewContainer.textView];

    [self.view addSubview:self.textViewContainer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textViewContainer.textView becomeFirstResponder];
}

- (NSString *)l33tSpeakFromText:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@"own" withString:@"pwn"];
    text = [text stringByReplacingOccurrencesOfString:@"the" withString:@"t3h"];
    text = [text stringByReplacingOccurrencesOfString:@"o" withString:@"0"];
    text = [text stringByReplacingOccurrencesOfString:@"t" withString:@"7"];
    text = [text stringByReplacingOccurrencesOfString:@"e" withString:@"3"];
    text = [text stringByReplacingOccurrencesOfString:@"i" withString:@"1"];
    text = [text stringByReplacingOccurrencesOfString:@"l" withString:@"1"];
    text = [text stringByReplacingOccurrencesOfString:@"!" withString:@"1"];
    text = [text stringByReplacingOccurrencesOfString:@"or" withString:@"r0"];
    text = [text stringByReplacingOccurrencesOfString:@"ck" withString:@"xxor"];
    
    return text;
}

- (void)handleTextViewChanged:(NSNotification *)notification {
    UITextView *textView = notification.object;
    textView.text = [self l33tSpeakFromText:textView.text];
}

@end
