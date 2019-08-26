//
//  ProviderLotame.swift
//  WOSTargeting
//
//  Created by David Wright on 8/26/19.
//  Copyright © 2019 David Wright. All rights reserved.
//

import LotameDMP

struct LotameProperties {
    var lptid: String
    var ltids = [String]()
}

class ProviderLotame {
    
    var lotame: LotameProperties
    
    init() {
        self.lotame = LotameProperties(
            lptid: "",
            ltids: []
        )
    }
    
    public func initialize(clientId: String, sendTestProfile: Bool) {
        DMP.initialize(clientId)
        
        if (sendTestProfile == true) {
            self.submitTestProfile()
        } else {
            self.getTargetingParmsFromLotame()
        }
    }
    
    // Get Lotame targeting query parameters
    public func getParams() -> [URLQueryItem] {
        let lptid = self.lotame.lptid
        let ltids = self.lotame.ltids.joined(separator: ",")

        var queryItems = [URLQueryItem]()
        if (lptid != "" && ltids.isEmpty == false) {
            queryItems.append(URLQueryItem(name: "lptid", value: lptid))
            queryItems.append(URLQueryItem(name: "ltids", value: ltids))
            return queryItems
        }
        return []
    }
    
    // Fetch profile information from Lotame
    private func getTargetingParmsFromLotame() {
        DMP.getAudienceData {
            result in
            if let profile = result.value {
                //print("JSON Audience result:" + result.value!.jsonString!)
                self.lotame.lptid = profile.pid
                for audience in profile.audiences {
                    self.lotame.ltids.append(audience.id)
                }
            } else {
                print("Limited ad tracking enabled or incomplete Lotame data received::: \(result)")
            }
        }
    }
    
    // Send test user profile to Lotame to make them think you are 45-54 male
    private func submitTestProfile() {
        DMP.addBehaviorData(behaviorId: 6322292)
        DMP.addBehaviorData(behaviorId: 6322303)
        DMP.sendBehaviorData() {
            result in
            if result.isSuccess{
                self.getTargetingParmsFromLotame()
            } else {
                print ("Error sending test profile: \(result)")
            }
        }
    }
}