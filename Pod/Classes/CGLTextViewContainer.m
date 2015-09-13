//
//  CGLTextViewContainer.m
//

#import "CGLTextViewContainer.h"
#import "CGLHackedTextViewContainer.h"
#import "CGLStandardTextViewContainer.h"

@implementation CGLTextViewContainerProvider

+ (BOOL)isOS9OrGreater {
    if (NSClassFromString(@"UIStackView")) {
        return YES;
    }
    
    return NO;
}

+ (UIScrollView <CGLTextViewContainer> *)containerWithFrame:(CGRect)frame height:(CGFloat)maxTextContainerHeight {
    UIScrollView <CGLTextViewContainer> *container;
    if ([self isOS9OrGreater]) {
        container = [[CGLStandardTextViewContainer alloc] initWithFrame:frame];
    }
    else {
        container = [[CGLHackedTextViewContainer alloc] initWithFrame:frame height:maxTextContainerHeight];
    }
    
    return container;
}

@end
