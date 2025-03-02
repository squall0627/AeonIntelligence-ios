//
//  Configuration.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/26.
//

import Foundation

struct Configuration: Codable {
    //    static var baseURL: String {
    //        guard
    //            let baseURL = Bundle.main.infoDictionary?["API_BASE_URL"] as? String
    //        else {
    //            fatalError("API_BASE_URL not found in configuration")
    //        }
    //        return baseURL
    //    }
    static let shared = Configuration()

    let apiBaseUrl: String

    private init() {
        let url = Bundle.main.url(
            forResource: "Config", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        let config = try? JSONDecoder().decode(
            Configuration.self, from: data!)
        self.apiBaseUrl = config!.apiBaseUrl

    }

}
