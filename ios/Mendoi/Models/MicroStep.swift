import Foundation

/// マイクロステップを表す構造体
/// APIから取得されるステップ情報を保持
struct MicroStep: Identifiable, Equatable, Codable {
    let id: String
    let label: String
    let description: String
    let emoji: String
    var completed: Bool

    /// Codableのカスタムキー（APIレスポンスと一致させる）
    enum CodingKeys: String, CodingKey {
        case id
        case label
        case description
        case emoji
        case completed
    }

    /// イニシャライザ
    init(id: String, label: String, description: String, emoji: String, completed: Bool = false) {
        self.id = id
        self.label = label
        self.description = description
        self.emoji = emoji
        self.completed = completed
    }

    /// カスタムデコーダー（completedフィールドはAPIレスポンスにないため、デフォルト値を使用）
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        label = try container.decode(String.self, forKey: .label)
        description = try container.decode(String.self, forKey: .description)
        emoji = try container.decode(String.self, forKey: .emoji)
        // completedはAPIレスポンスに含まれないため、デフォルト値falseを使用
        completed = try container.decodeIfPresent(Bool.self, forKey: .completed) ?? false
    }

    /// カスタムエンコーダー
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(label, forKey: .label)
        try container.encode(description, forKey: .description)
        try container.encode(emoji, forKey: .emoji)
        try container.encode(completed, forKey: .completed)
    }
}
