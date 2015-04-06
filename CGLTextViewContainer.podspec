Pod::Spec.new do |s|
  s.name             = "CGLTextViewContainer"
  s.version          = "0.1.0"
  s.summary          = "CGLTextViewContainer takes the best fix I've found for UITextView's layout problems, and wraps it in a lighter, simpler interface. It is, at its core, the same good stuff in JTSTextView."
  s.description      = <<-DESC
                           CGLTextViewContainer is a lighweight version of Jared Sinclair's excellent workaround to UITextView's notorious update problems. 
                        
                           It's pretty much just wholesale stolen, but it differs in a few ways: it trusts clients enough to grant them access to the internal text view, cutting the amount of code                        needed by about half. Has-a vs. is-a or pretends-to-be-a. It allows configuration of the text container's height. And it takes into account measurements of the text view's                        inset.
                        
                           Original source here:
                           https://github.com/jaredsinclair/JTSTextView
                        
                           Hopefully, iOS 9 will continue the long chain of text improvements on iOS and we won't need these shenanigans anymore. Until then, this does seem to be a good workaround.

                       DESC
  s.homepage         = "https://github.com/chrisladd/CGLTextViewContainer"
  s.license          = 'MIT'
  s.author           = { "Chris Ladd" => "c.g.ladd@gmail.com" }
  s.source           = { :git => "https://github.com/chrisladd/CGLTextViewContainer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/chrisladd'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit'

end
