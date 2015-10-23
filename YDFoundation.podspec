
Pod::Spec.new do |s|

  s.name                  = "YDFoundation"
  s.version               = "1.0.0"
  s.summary               = "provider dev foundation api."
  s.description           = "YD Foundation Framework"
  s.homepage              = "https://github.com/imadding/YDFoundation"
  s.license               = { :type => 'Copyright', :text => "Apache License" }
  s.author                = { "madding.lip" => "madding.lip@gmail.com" }
  s.source                = { :git => "git@github.com:imadding/YDFoundation.git", :tag => "v#{s.version}" }
  s.requires_arc          = true
  s.ios.deployment_target = '6.0'

  s.platform = :ios
  s.source_files  = "YDFoundation/Sources/**/*.{h,m}"
  s.public_header_files = "YDFoundation/Sources/public/**/*.h"

end
