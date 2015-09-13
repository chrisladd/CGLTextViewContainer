//
//  CGLTextViewContainer.h
//

@import UIKit;


@protocol CGLTextViewContainer <NSObject>

/**
 *  The underlying text view. @note that you should not change the delegate. If you need access to the text view's delegate methods, either use the notifications, or set yourself as the textViewDelegate of this object.
 */
@property (nonatomic, readonly) UITextView *textView;

/**
 *  A passthrough delegate for the text view.
 */
@property (weak, nonatomic) id <UITextViewDelegate> textViewDelegate;

@end

@interface CGLTextViewContainerProvider : NSObject

/**
 *  Returns a text view container appropriate for the current runtime.
 *
 *  @param frame                  the frame of the view
 *  @param maxTextContainerHeight the max height to make the underlying text view. 100,000 points by default. On iOS9 and later, this parameter is ignored.
 *
 *  @return a CGLTextContainer
 */
+ (UIScrollView <CGLTextViewContainer> *)containerWithFrame:(CGRect)frame height:(CGFloat)maxTextContainerHeight;

@end

