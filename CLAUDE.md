# めんどい - iOS App + Cloud Run Backend

認知的負荷により「やりたくないこと」に手をつけられないユーザーを、マイクロステップ分解とAI励ましでサポートする汎用タスク分解アシスタント。

## 現在のステータス

### ✅ 完了
- **バックエンド**: Cloud RunにTerraformでデプロイ完了
  - URL: https://mendoi-api-glhnu2cdda-an.a.run.app
  - Firebase Admin SDKでIDトークン検証実装
  - Rate Limiting: UID単位で10req/分

- **iOS**: アプリ開発完了
  - Firebase匿名認証が動作
  - TextEditor多行入力実装（ZStackでカスタムプレースホルダー）
  - 音声入力権限を初回タップ時に要求（onAppear削除）
  - Lottieローディングアニメーション統合（5段階グラデーション）
  - アプリアイコン設定完了（1024x1024、グラデーション階段デザイン）

- **App Store準備**: 全素材完成
  - ✅ プライバシーポリシー: https://gist.github.com/TaichiAkimoto/8351aeedfb5e5d875b79a982d64b6a0b
  - ✅ スクリーンショット5枚（iPhone 16 Pro Max）
  - ✅ アプリアイコン（1024x1024）
  - ✅ プレビュー動画（15秒）
  - ✅ アプリ説明文（日本語・英語）
  - 📁 全素材: `~/Desktop/mendoi-app-store-assets/`

### 🔧 次にやること
**App Store Connect登録** - Claude in Chromeで実施
1. https://appstoreconnect.apple.com にログイン
2. 新規アプリ作成
   - 名前: めんどい
   - バンドルID: com.taichi.mendoi
   - プライバシーポリシーURL: https://gist.github.com/TaichiAkimoto/8351aeedfb5e5d875b79a982d64b6a0b
3. スクリーンショット・アイコンをアップロード
4. 説明文を入力（`~/Desktop/mendoi-app-store-assets/README.md`参照）
5. Xcodeアーカイブ作成→アップロード
6. 審査提出

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
- `ios/Mendoi/Views/TaskInputView.swift` - TextEditor実装、音声入力、Lottieアニメーション
- `ios/Mendoi/Resources/loading-animation.json` - Lottieアニメーションファイル（5.9KB）
- `ios/Mendoi/Assets.xcassets/AppIcon.appiconset/icon-1024.png` - アプリアイコン
- `ios/Podfile` - lottie-ios依存関係

### App Store素材
- `~/Desktop/mendoi-app-store-assets/screenshots/` - 5枚のスクリーンショット
- `~/Desktop/mendoi-app-store-assets/app-icon-1024.png` - アイコン
- `~/Desktop/mendoi-app-store-assets/app-preview-video.mp4` - プレビュー動画
- `~/Desktop/mendoi-app-store-assets/README.md` - 説明文・提出手順
- `privacy-policy.html` - プライバシーポリシー（Gistで公開済み）

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

### 2026-01-31: App Store提出準備完了
- **UI改善**: TextField → TextEditor（多行入力対応、ZStackでカスタムプレースホルダー）
- **権限最適化**: 音声入力権限を初回タップ時に要求（onAppear削除）
- **Lottieアニメーション**: After Effects MCPで5段階グラデーションステップを作成・統合
  - `loading-animation.json` (5.9KB) をプロジェクトに追加
  - `lottie-ios` podを追加
  - TaskInputView.swiftに統合（200x200、ループ再生）
- **アプリアイコン**: PiAPI/Midjourneyでグラデーション階段デザイン生成
- **スクリーンショット**: iPhone 16 Pro Maxシミュレーターで5枚撮影
  1. スタート画面
  2. タスク入力画面（空）
  3. タスク入力画面（入力済み「確定申告の書類を整理する」）
  4. Lottieローディング画面
  5. 生成されたステップ画面
- **プライバシーポリシー**: HTML作成→Gistで公開
  - URL: https://gist.github.com/TaichiAkimoto/8351aeedfb5e5d875b79a982d64b6a0b
- **全素材整理**: `~/Desktop/mendoi-app-store-assets/` にまとめ
- **次回**: Claude in ChromeでApp Store Connect登録

### 2026-01-30: Firebase認証問題の解決
- **問題**: GoogleService-Info.plistに誤ったAPI_KEY（Gemini APIキー）が設定
- **解決**:
  - Claude in Chromeを使用してFirebase Consoleから正しいファイルをダウンロード
  - API_KEY: `AIzaSyCUQCkwhz7Sz7wi_2j3wdtH9Cva2Ruyo04`（Firebase用）
  - 匿名認証成功を確認
- **次回**: E2Eフローのテスト
