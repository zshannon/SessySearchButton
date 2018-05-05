Pod::Spec.new do |spec|
  spec.name         = 'SessySearchButton'
  spec.version      = '1.0.3'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/zshannon/SessySearchButton'
  spec.authors      = { 'Zane Shannon' => 'zane@zaneshannon.com' }
  spec.summary      = 'A nice lil sassy search button that grows.'
  spec.source       = { :git => 'https://github.com/zshannon/SessySearchButton.git', :tag => 'v1.0.3' }
  spec.source_files = 'SessySearchButton.swift'
  spec.ios.deployment_target  = '11.0'

  spec.dependency 'AwesomeEnum'
end
