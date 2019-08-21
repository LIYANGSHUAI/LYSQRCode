Pod::Spec.new do |s|

s.name         = "LYSQRCodeView"
s.version      = "0.0.1"
s.summary      = "简单的实现二维码扫描组件以及识别图片中二维码"
s.description  = <<-DESC
简单的实现二维码扫描组件以及识别图片中二维码
简单的实现二维码扫描组件以及识别图片中二维码
DESC
s.homepage     = "https://github.com/LIYANGSHUAI/LYSQRCode"
s.platform       = :ios
s.license      = "MIT"
s.author             = { "LIYANGSHUAI" => "liyangshuai163@163.com" }
s.source       = { :git => "https://github.com/LIYANGSHUAI/LYSQRCode.git", :tag => "0.0.1" }
s.source_files  = "LYSUIKit/*.{h,m}"
end
