# WideOrbit Streaming Targeting SDK for iOS

This library can be used by WideOrbit Streaming customers to obtain audio stream url parameters to increase ad targeting potential.

## Prerequisites
Your Xcode application must be configured to use Cocoapods.

## Installation
Verify or add the following source statements to your Podfile:

    source 'https://github.com/WoStreaming/Specs.git'
    source 'https://github.com/CocoaPods/Specs.git'

Add the following to your target block:

    pod 'WOSTargeting', '1.0.1'

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
        let targetingQueryItems = WOSTargeting.getURLQueryItems()
        print ("Add these to your stream url \(targetingQueryItems)")
    }

## Example using default Xcode ViewController.swift

    import WOSTargeting

    class ViewController: UIViewController {
      override func viewDidLoad() {
        super.viewDidLoad()
        
        // Step 1: Call initialize with your client id, a flag indicating your app has privacy policy and whether you want to create a test targeting profile
        WOSTargeting.initialize(clientId: "XXXX", appHasPrivacyPolicy: true, sendTestProfile: false)
        
        // Step 2: Define an observer that will get notified when targeting data is ready. 
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: WOSTargeting.readyNotification, object: nil)
        
      // Do any additional setup after loading the view.
    }
    
      // Step 3: Define the observer callback to get the URL parameters
      @objc func onNotification(notification:Notification) {
      
        // Get stream URL parameters
        let targetingQueryItems = WOSTargeting.getURLQueryItems()
        
        // Using URLComponents to construct the stream url
        var urlComponents = URLComponents(string: "https://live.wostreaming.net/manifest/xxxxxxxx-wkrpfmaac-hlsc3.m3u8")
        urlComponents?.queryItems = targetingQueryItems
       
        if let url = urlComponents?.url {
            print ("Stream URL: \(url))")
        }
      }
    }


#### Example response from WOSTargeting.getStreamUrlParams()
    https://live.wostreaming.net/manifest/xxxxxxxx-wkrpfmaac-hlsc3.m3u8?lmt=0&ifa=AA762328-E74C-49D0-B386-E646FC3B7301&bundle=com.wideorbit.WOSTargetingExample&privacypolicy=1&lptid=MAA762328-E74C-49D0-B386-E646FC3B7301&ltids=593088,511080,513421,99286)
