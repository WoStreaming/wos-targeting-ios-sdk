//
//  WOSTargeting.swift
//
//
//  Created by WideOrbit on 8/19/19.
//  Copyright © 2019 WideOrbit. All rights reserved.
//

import Foundation
import AdSupport
import LotameDMP

struct AppProperties {
    var bundleID: String
    var hasPrivacyPolicy: Bool
}

struct DeviceProperties {
    var isAdvertisingTrackingEnabled: Bool
    var advertisingIdentifier: String
}

struct LotameProperties {
    var lptid: String
    var ltids = [String]()
}

public class WOSTargeting {

    public static let shared = WOSTargeting()
    let lotameId = "6394"
    var app: AppProperties
    var device: DeviceProperties
    var lotame: LotameProperties

    private init() {
        self.app = AppProperties(
                bundleID: "",
                hasPrivacyPolicy: false
        )
        self.device = DeviceProperties(
                isAdvertisingTrackingEnabled: false,
                advertisingIdentifier: ""
        )
        self.lotame = LotameProperties(
                lptid: "",
                ltids: []
        )
    }

    public static func initialize(appHasPrivacyPolicy: Bool) {
        shared.getAppProperties(hasPrivacyPolicy: appHasPrivacyPolicy)
        shared.getLotameData()
        shared.getAdvertisingIdentifier()
    }

    public static func getStreamUrlParams() -> String {
        let lptid = shared.lotame.lptid
        let ltids = shared.lotame.ltids.joined(separator: ",")
        let limitedAdTracking = shared.device.isAdvertisingTrackingEnabled ? "0" : "1"
        let advertisingIdentifier = shared.device.advertisingIdentifier
        let bundleIdentifier = shared.app.bundleID
        let hasPrivacyPolicy = shared.app.hasPrivacyPolicy ? "1" : "0"

        var url = URLComponents()
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "lmt", value: limitedAdTracking))
        queryItems.append(URLQueryItem(name: "ifa", value: advertisingIdentifier))
        queryItems.append(URLQueryItem(name: "bundle", value: bundleIdentifier))
        queryItems.append(URLQueryItem(name: "privacypolicy", value: hasPrivacyPolicy))

        if (lptid != "" && ltids.isEmpty == false) {
            queryItems.append(URLQueryItem(name: "lptid", value: lptid))
            queryItems.append(URLQueryItem(name: "ltids", value: ltids))
        }

        if (queryItems.isEmpty == false) {
            url.queryItems = queryItems
            return url.query!
        }

        return ""
    }

    private func getAppProperties(hasPrivacyPolicy: Bool) {
        self.app.bundleID = Bundle.main.bundleIdentifier ?? ""
        self.app.hasPrivacyPolicy = hasPrivacyPolicy
    }

    private func getLotameData() {
        DMP.initialize(self.lotameId)
        DMP.addBehaviorData(behaviorId: 6322292)
        DMP.addBehaviorData(behaviorId: 6322303)
        DMP.sendBehaviorData()
        DMP.getAudienceData {
            result in
            if let profile = result.value {
//                print("JSON Audience result:" + result.value!.jsonString!)
                self.lotame.lptid = profile.pid
                for audience in profile.audiences {
                    self.lotame.ltids.append(audience.id)
                }
            } else {
                print("Limited ad tracking enabled or incomplete Lotame data received::: \(result)")
            }
        }
    }

    private func getAdvertisingIdentifier() {
        let a = ASIdentifierManager.shared()
        self.device.isAdvertisingTrackingEnabled = a.isAdvertisingTrackingEnabled
        self.device.advertisingIdentifier = a.advertisingIdentifier.uuidString
    }
}
