# WideOrbit Streaming Targeting SDK for iOS

This library can be used by WideOrbit Streaming customers to obtain audio stream url parameters to increase ad targeting potential.

## Prerequisites
Your Xcode application must be configured to use Cocoapods.

## Installation
Verify or add the following source statements to your Podfile:

    source 'https://github.com/WoStreaming/Specs.git'
    source 'https://github.com/CocoaPods/Specs.git'

Add the following to your target block:

    pod 'WOSTargeting', '1.0.0'

## Usage
WOSTargeting must be imported by any file using the library.

    import WOSTargeting
    
### Initialization
WOSTargeting is a singleton that must be initialized as early as possible in your application lifecycle, AppDelegate for example.

    WOSTargeting.initialize(clientId: "XXXX", appHasPrivacyPolicy: true, sendTestProfile: false)

#### Initialize an observer to know when URL params have been collected

    NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: WOSTargeting.readyNotification, object: nil)

#### Add onNotification function to handle making call to get URL parameters
    
    @objc func onNotification(notification:Notification) {
        let WOParams = WOSTargeting.getStreamUrlParams()
        print ("Add these to your stream url \(WOParams)")
    }

#### Example of what to add to your stream url
    lmt=0&ifa=E7308362-86D8-4D87-A476-DD2D1F6F74C4&bundle=com.yourDomain.yourApp&privacypolicy=1&lptid=ME7308362-86D8-4D87-A476-DD2D1F6F74C4&ltids=511080,99286,513421,593088
