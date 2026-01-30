# めんどい - iOS App + Cloud Run Backend

認知的負荷により「やりたくないこと」に手をつけられないユーザーを、マイクロステップ分解とAI励ましでサポートする汎用タスク分解アシスタント。

## 現在のステータス

### ✅ 完了
- バックエンド: Cloud RunにTerraformでデプロイ完了
  - URL: https://mendoi-api-glhnu2cdda-an.a.run.app
  - Firebase Admin SDKでIDトークン検証実装
  - Rate Limiting: UID単位で10req/分
- iOS: Firebase匿名認証が動作
  - GoogleService-Info.plist正常（Firebase API Key使用）
  - 匿名ログイン成功: UID取得・IDトークンリフレッシュ確認
  - APIClient: IDトークン付きリクエスト実装済み

### 🔧 次にやること
1. **E2Eテスト**: シミュレーターでタスク入力→ステップ生成→完了フロー確認
2. **実機テスト**: 音声入力機能のテスト
3. **エラーハンドリング確認**: ネットワークエラー、API障害時の挙動

## アーキテクチャ

```
iOS App (Swift/SwiftUI)
  ↓ Firebase Anonymous Auth
  ↓ HTTPS + ID Token
Cloud Run (Node.js/Express)
  ↓ Firebase Admin SDK (Token検証)
  ↓ Gemini API
```

## 重要ファイル

### バックエンド
- `backend/src/server.ts` - Expressサーバー
- `backend/src/routes/steps.ts` - タスク分解エンドポイント
- `backend/src/services/firebase.ts` - Firebase Admin SDK初期化
- `backend/src/middleware/auth.ts` - IDトークン検証
- `backend/terraform/main.tf` - Cloud Runデプロイ設定

### iOS
- `ios/Mendoi/GoogleService-Info.plist` - Firebase設定（**重要**: Firebase API Key）
- `ios/Mendoi/Services/AuthManager.swift` - 匿名認証管理
- `ios/Mendoi/Services/APIClient.swift` - バックエンドAPI通信
- `ios/Mendoi/ViewModels/AppViewModel.swift` - メイン状態管理

## 再開方法

次回のセッションで「続きから」または「前回の続きを」と言ってください。

または具体的に：
- 「E2Eテストを実行して」
- 「実機で音声入力をテストして」

## トラブルシューティング

### Firebase認証エラー（API_KEY_SERVICE_BLOCKED）
- **原因**: GoogleService-Info.plistに誤ったAPI_KEY
- **解決**: Firebase ConsoleからiOSアプリ用の正しいGoogleService-Info.plistをダウンロード
- **確認**: PROJECT_ID=mendoi-d2ebb, BUNDLE_ID=com.taichi.mendoi

### ビルドエラー（Firebase module not found）
- **原因**: CocoaPods依存関係未インストール
- **解決**: `cd ios && pod install` 実行
- **重要**: `.xcworkspace`を使用してビルド（`.xcodeproj`ではない）

## セッション履歴

### 2026-01-30: Firebase認証問題の解決
- **問題**: GoogleService-Info.plistに誤ったAPI_KEY（Gemini APIキー）が設定
- **解決**:
  - Claude in Chromeを使用してFirebase Consoleから正しいファイルをダウンロード
  - API_KEY: `AIzaSyCUQCkwhz7Sz7wi_2j3wdtH9Cva2Ruyo04`（Firebase用）
  - 匿名認証成功を確認
- **次回**: E2Eフローのテスト
