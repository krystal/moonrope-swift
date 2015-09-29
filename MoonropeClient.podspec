Pod::Spec.new do |s|
  s.name          = "MoonropeClient"
  s.version       = "0.0.1"
  s.summary       = "A Moonrope API client for Swift."
  s.description   = "Blah"
  s.homepage      = "http://github.com/adamcooke/moonrope-swift"
  s.license       = "MIT"
  s.author        = {"Adam Cooke" => "me@adamcooke.io"}
  s.source        = {:git => "https://github.com/adamcooke/moonrope-swift.git", :tag => "0.0.1"}
  s.source_files  = "MoonropeClient/Source/**/*.{swift}"
  s.exclude_files = "MoonropeClient/Source/Exclude"
end
