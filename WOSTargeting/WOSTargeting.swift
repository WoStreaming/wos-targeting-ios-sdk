//
//  WOSTargeting.swift
//
//
//  Created by WideOrbit on 8/19/19.
//  Copyright © 2019 WideOrbit. All rights reserved.
//

import Foundation
import AdSupport

struct AppProperties {
    var bundleID: String
    var hasPrivacyPolicy: Bool
}

struct DeviceProperties {
    var isAdvertisingTrackingEnabled: Bool
    var advertisingIdentifier: String
}

public class WOSTargeting {
    
    public static let shared = WOSTargeting()
    
    public static let readyNotification = Notification.Name("WOSTargetingReadyNotification")
    
    var app: AppProperties
    var device: DeviceProperties
    var lotameDMP: ProviderLotame
    
    private init() {
        self.app = AppProperties(
            bundleID: "",
            hasPrivacyPolicy: false
        )
        
        self.device = DeviceProperties(
            isAdvertisingTrackingEnabled: false,
            advertisingIdentifier: ""
        )
        
        self.lotameDMP = ProviderLotame()
    }
    
    public static func initialize(clientId: String, appHasPrivacyPolicy: Bool, sendTestProfile: Bool) {
        shared.getAppProperties(hasPrivacyPolicy: appHasPrivacyPolicy)
        shared.getAdvertisingIdentifier()
        shared.initDMP(clientId: clientId, sendTestProfile: sendTestProfile)
    }
    
    // Returns URLQueryItem array
    public static func getURLQueryItems() -> [URLQueryItem] {
        let limitedAdTracking = shared.device.isAdvertisingTrackingEnabled ? "0" : "1"
        let advertisingIdentifier = shared.device.advertisingIdentifier
        let bundleIdentifier = shared.app.bundleID
        let hasPrivacyPolicy = shared.app.hasPrivacyPolicy ? "1" : "0"
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "lmt", value: limitedAdTracking))
        queryItems.append(URLQueryItem(name: "ifa", value: advertisingIdentifier))
        queryItems.append(URLQueryItem(name: "bundle", value: bundleIdentifier))
        queryItems.append(URLQueryItem(name: "privacypolicy", value: hasPrivacyPolicy))
        
        let lotameParams = shared.lotameDMP.getParams()
        if (lotameParams.isEmpty == false) {
            queryItems += lotameParams
        }
      
        return queryItems
    }
    
    private func getAppProperties(hasPrivacyPolicy: Bool) {
        self.app.bundleID = Bundle.main.bundleIdentifier ?? ""
        self.app.hasPrivacyPolicy = hasPrivacyPolicy
    }
    
    private func initDMP(clientId: String, sendTestProfile: Bool) {
        self.lotameDMP.initialize(clientId: clientId, sendTestProfile: sendTestProfile, notificationName: WOSTargeting.readyNotification)
    }
    
    private func getAdvertisingIdentifier() {
        let a = ASIdentifierManager.shared()
        self.device.isAdvertisingTrackingEnabled = a.isAdvertisingTrackingEnabled
        self.device.advertisingIdentifier = a.advertisingIdentifier.uuidString
    }
}
