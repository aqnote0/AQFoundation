
Pod::Spec.new do |s|

  s.name                  = "YDFoundation"
  s.version               = "1.0.0-beta2"
  s.summary               = "provider foundation api."
  s.description           = "YD Foundation Framework, Provider JSON, Base64, Log etc..."
  s.homepage              = "https://github.com/imadding/YDFoundation"
  s.license               = { :type => 'Copyright', :text => "Apache License" }
  s.author                = { "madding.lip" => "madding.lip@gmail.com" }
  s.source                = { :git => "https://github.com/imadding/YDFoundation.git", :tag => "v#{s.version}" }
  s.requires_arc          = true
  s.ios.deployment_target = '6.0'

  s.platform = :ios
  s.source_files  = "YDFoundation/Sources/**/*.{h,m}"
  s.public_header_files = "YDFoundation/Sources/public/**/*.h"

end
