# CGLTextViewContainer

[![Version](https://img.shields.io/cocoapods/v/CGLTextViewContainer.svg?style=flat)](http://cocoapods.org/pods/CGLTextViewContainer)
[![License](https://img.shields.io/cocoapods/l/CGLTextViewContainer.svg?style=flat)](http://cocoapods.org/pods/CGLTextViewContainer)
[![Platform](https://img.shields.io/cocoapods/p/CGLTextViewContainer.svg?style=flat)](http://cocoapods.org/pods/CGLTextViewContainer)

## Usage

CGLTextViewContainer is a lighweight version of Jared Sinclair's excellent workaround to UITextView's notorious update problems. 

It's pretty much just wholesale stolen, but it differs in a few ways: it trusts clients enough to grant them access to the internal text view, cutting the amount of code eeded by about half. Has-a vs. is-a or pretends-to-be-a. It allows configuration of the text container's height. And it takes into account measurements of the text view's nset.

Original source here:
https://github.com/jaredsinclair/JTSTextView

Hopefully, iOS 9 will continue the long chain of text improvements on iOS and we won't need these shenanigans anymore. Until then, this does seem to be a good workaround.

There is a basic example project, but, basically: 

- a CGLTextViewContainer is a UIScrollView, which has, as a subview, a really, really tall text view.

- how long the text view is depends on your initialization. Mr. Sinclair chose 100,000 pts. That seems like a reasonable default. Use `- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)maxTextContainerHeight;` to set a custom value, or just `initWithFrame:` to get the default.

- if you want all these nice fixes, **you must not alter the delegate of the container object's text view**. We're treating you like adults here, people. Earn that trust. There's a passthrough delegate provided.

- updates and improvement are welcome, but I very much hope this code is obsolete in a few months. Experiment with the official UIKit components once they're shipped for iOS9, and pray they work out for you.


## Example

```   
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
```


## Requirements

## Installation

CGLTextViewContainer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CGLTextViewContainer"
```

## Author

Chris Ladd, c.g.ladd@gmail.com

## License

CGLTextViewContainer is available under the MIT license. See the LICENSE file for more info.
