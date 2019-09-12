//
//  ProviderLotame.swift
//  WOSTargeting
//
//  Created by WideOrbit on 8/19/19.
//  Copyright © 2019 WideOrbit. All rights reserved.
//

import LotameDMP

struct LotameProperties {
    var lptid: String
    var ltids = [String]()
}

class ProviderLotame {
    
    static var notificationName = Notification.Name("")
    var lotame: LotameProperties
    
    init() {
        self.lotame = LotameProperties(
            lptid: "",
            ltids: []
        )
    }
    
    public func initialize(clientId: String, notificationName: Notification.Name) {
        DMP.initialize(clientId)
        
        ProviderLotame.notificationName = notificationName

        DMP.sendBehaviorData() {
            result in
            if result.isSuccess{
                DMP.getAudienceData {
                    result in
                    if let profile = result.value {
                        self.lotame.lptid = profile.pid
                        for audience in profile.audiences {
                            self.lotame.ltids.append(audience.id)
                        }
                        NotificationCenter.default.post(name: ProviderLotame.notificationName, object: nil, userInfo: nil)
                    }
                }
            }
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
}
