//
//  CGLTextViewContainer.h
//

@import UIKit;

/**
 *   CGLTextViewContainer is a lighweight version of Jared Sinclair's excellent workaround to UITextView's notorious update problems. 
 *
 *   It's pretty much just wholesale stolen, but it differs in a few ways: it trusts clients enough to grant them access to the internal text view, cutting the amount of code needed by about half. Has-a vs. is-a or pretends-to-be-a. It allows configuration of the text container's height. And it takes into account measurements of the text view's inset.
 *
 *   Original source here:
 *   https://github.com/jaredsinclair/JTSTextView
 *
 *   Hopefully, iOS 9 will continue the long chain of text improvements on iOS and we won't need these shenanigans anymore. Until then, this does seem to be a good workaround.
 */
@interface CGLTextViewContainer : UIScrollView

/**
 *  The designated initializer.
 *
 *  @param frame                  the frame of the view
 *  @param maxTextContainerHeight the max height to make the underlying text view. 100,000 points by default.
 *
 *  @return a CGLTextContainer
 */
- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)maxTextContainerHeight;

/**
 *  The underlying text view. @note that you should not change the delegate. If you need access to the text view's delegate methods, either use the notifications, or set yourself as the textViewDelegate of this object.
 */
@property (nonatomic, readonly) UITextView *textView;

/**
 *  A passthrough delegate for the text view.
 */
@property (weak, nonatomic) id <UITextViewDelegate> textViewDelegate;

@end

