//
//  TranslationType.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/25.
//

import Foundation

enum TranslationType: CaseIterable {
    case jaToZh, jaToEn, zhToJa, zhToEn, enToJa, enToZh

    var buttonText: String {
        switch self {
        case .jaToZh: return "Japanese ➡︎ Chinese"
        case .jaToEn: return "Japanese ➡︎ English"
        case .zhToJa: return "Chinese ➡︎ Japanese"
        case .zhToEn: return "Chinese ➡︎ English"
        case .enToJa: return "English ➡︎ Japanese"
        case .enToZh: return "English ➡︎ Chinese"
        }
    }

    var taskId: String {
        switch self {
        case .jaToZh: return "ja_to_zh"
        case .jaToEn: return "ja_to_en"
        case .zhToJa: return "zh_to_ja"
        case .zhToEn: return "zh_to_en"
        case .enToJa: return "en_to_ja"
        case .enToZh: return "en_to_zh"
        }
    }
}
