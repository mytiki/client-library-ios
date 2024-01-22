Pod::Spec.new do |s|
  s.name             = 'TikiClient'
  s.version          = '0.1.0'
  s.summary          = 'Lean Cocoapods lib for seamless integration with TIKI Rest APIs'

  s.description      = <<-DESC
  The TIKI APIs comprise a set of HTTP REST APIs designed for seamless integration with any
  standard HTTP client. The Client Libraries serve as a user-friendly layer around the TIKI APIs,
  introducing methods for common operations such as authorization, licensing, capture, card-linked
  offers, and rewards. It is a collection of pre-existing code with minimal dependencies, offering
  a streamlined integration process with TIKI Rest APIs, which reduces the amount of code necessary
  for integration.
  
  TikiClient is the top-level entry point for the TIKI Client Library. It offers simple methods
  that call the underlying libraries to perform common operations. Programmers can use it to
  simplify the integration process or opt for individual libraries based on their specific needs.
                       DESC

  s.homepage         = 'https://mytiki.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ricardobrg' => 'ricardobrg@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/tiki/publish-client-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'TikiClient/Classes/**/*'

  s.dependency 'TikiSdkDebug', '3.0.0', :configurations => 'Debug'
  s.dependency 'TikiSdkRelease', '3.0.0', :configurations => 'Release'
end
