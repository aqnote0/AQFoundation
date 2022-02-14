
Pod::Spec.new do |s|

  s.name                  = "AQFoundation"
  s.version               = "1.3.0"
  s.summary               = "provider foundation api."
  s.description           = "AQNote's Foundation Framework, Provider JSON, Base64, Log etc..."
  s.homepage              = "https://github.com/aqnotecom/com.aqnote.ios.foundation"
  s.license               = { :type => 'Copyright', :text => "Apache License" }
  s.author                = { "Peng Li" => "aqnote@aqnote.com" }
  s.source                = { :git => "https://github.com/aqnotecom/com.aqnote.ios.foundation.git", :tag => "v#{s.version}" }
  s.requires_arc          = true
  s.ios.deployment_target = '15.2'

  s.platform = :ios
  s.source_files  = "AQFoundation/Sources/**/*.{h,m}"
  s.public_header_files = "AQFoundation/Sources/public/**/*.h"

end
