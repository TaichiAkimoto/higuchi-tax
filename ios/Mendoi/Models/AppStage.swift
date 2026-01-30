import Foundation

/// アプリのステージを表すenum
/// 6つのステージ: start → taskInput → validation → missionSetup → guide → finish
enum AppStage: Equatable {
    case start          // スタート画面
    case taskInput      // タスク入力画面（音声/テキスト）
    case validation     // 心理的共感メッセージ画面
    case missionSetup   // 3つのルール説明画面
    case guide          // マイクロステップ実行画面
    case finish         // 完了画面
}
