//
//  ContentType.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/26.
//

import Foundation

enum ContentType {
    case form, json
    
    var type: String {
        switch self {
        case .form: return "application/x-www-form-urlencoded"
        case .json: return "application/json"
        }
    }
}
