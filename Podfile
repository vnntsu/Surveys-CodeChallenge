platform :ios, '10.0'

def network_pods
  pod 'Alamofire', '5.0.0-rc.3'
end

def dev_pods
  pod 'SwiftLint', '~> 0.35'
end

def test_pods
  pod 'Quick', '~> 2.2'
  pod 'Nimble', '~> 8.0'
end

def util_pods
    pod 'Kingfisher', '~> 5.10'
end

target 'SurveysCodeChallenge' do
  use_frameworks!
  network_pods
  util_pods
  dev_pods

  target 'SurveysCodeChallengeTests' do
    inherit! :search_paths
    dev_pods
    test_pods
  end

end
