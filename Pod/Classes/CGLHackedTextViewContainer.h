//
//  CGLHackedTextViewContainer.h
//  SFN
//
//  Created by Christopher Ladd on 9/13/15.
//  Copyright © 2015 Christopher Ladd. All rights reserved.
//

#import "CGLTextViewContainer.h"

/**
 *   CGLHackedTextViewContainer is a lighweight version of Jared Sinclair's excellent workaround to UITextView's notorious update problems.
 *
 *   It's pretty much just wholesale stolen, but it differs in a few ways: it trusts clients enough to grant them access to the internal text view, cutting the amount of code needed by about half. Has-a vs. is-a or pretends-to-be-a. It allows configuration of the text container's height. And it takes into account measurements of the text view's inset.
 *
 *   Original source here:
 *   https://github.com/jaredsinclair/JTSTextView
 *
 *   Hopefully, iOS 9 will continue the long chain of text improvements on iOS and we won't need these shenanigans anymore. Until then, this does seem to be a good workaround.
 */
@interface CGLHackedTextViewContainer : UIScrollView <CGLTextViewContainer>

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)maxTextContainerHeight;

@end
