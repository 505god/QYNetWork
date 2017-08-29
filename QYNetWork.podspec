#
#  Be sure to run `pod spec lint QYNetWork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "QYNetWork"
  s.version      = "1.0"
  s.summary      = "对AFNetWorking进行二次封装"
  s.homepage     = "https://github.com/505god/QYNetWork"
  s.license      = "MIT"
  s.author       = { "qcx" => "18915410342@126.com" }
  s.platform     = :ios
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/505god/QYNetWork.git", :tag => "1.0" }
  s.source_files  = 'QYNetWork/Classes/*.{h,m}'
  s.dependency "AFNetworking", "~> 3.1.0"
  s.dependency "RealReachability", "~> 1.1.8"
  s.requires_arc = true
end
