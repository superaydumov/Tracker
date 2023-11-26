//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 27.11.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration.init(apiKey: "9cfbd321-3f05-4f07-befc-6d2e65177ac3") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("Report ERROR: %@", error.localizedDescription)
        })
    }
}
