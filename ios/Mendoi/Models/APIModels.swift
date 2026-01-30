import Foundation

// MARK: - Steps API

/// タスク分解APIのリクエスト
struct StepsRequest: Codable {
    let task: String
}

/// タスク分解APIのレスポンス
struct StepsResponse: Codable {
    let steps: [MicroStep]
}

// MARK: - Encourage API

/// 励ましメッセージAPIのリクエスト
struct EncourageRequest: Codable {
    let context: String
}

/// 励ましメッセージAPIのレスポンス
struct EncourageResponse: Codable {
    let message: String
}
