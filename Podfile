source 'https://github.com/CocoaPods/Specs.git'

def import_pods
    pod 'JSONModel', '~> 1.7.0'
    pod 'SDWebImage', '~> 3.8.2'
end

target 'PodcastApp_ObjectiveC' do
    platform :ios, '9.0'
    project 'PodcastApp_ObjectiveC'

    use_frameworks!

    import_pods

    target 'PodcastApp_ObjectiveCTests' do
        inherit! :search_paths

        pod 'OCMock', '~> 3.3.1'
    end
end
