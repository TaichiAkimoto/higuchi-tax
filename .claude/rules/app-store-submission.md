# App Store Connect提出ガイド - めんどいアプリ

## アプリ基本情報

- **アプリ名**: めんどい
- **バンドルID**: com.taichi.mendoi
- **バージョン**: 1.0 (Build 1)
- **カテゴリ**: 生産性（プライマリ）、ライフスタイル（セカンダリ）
- **対象年齢**: 4+
- **プライバシーポリシーURL**: https://gist.github.com/TaichiAkimoto/8351aeedfb5e5d875b79a982d64b6a0b

## 提出素材の場所

全て `~/Desktop/mendoi-app-store-assets/` に保存済み：

### スクリーンショット（iPhone 6.7" - iPhone 16 Pro Max）
1. `01-start-screen.png` - スタート画面
2. `02-task-input-empty.png` - タスク入力画面（空）
3. `03-task-entered.png` - タスク入力画面（入力済み）
4. `04-loading-animation.png` - Lottieローディング
5. `05-generated-steps.png` - 生成されたステップ

### その他素材
- `app-icon-1024.png` - アプリアイコン（1024x1024）
- `app-preview-video.mp4` - プレビュー動画（15秒）
- `README.md` - 説明文（日本語・英語）、提出手順

## App Store Connect提出手順（Claude in Chrome使用）

### 1. ログイン
```
URL: https://appstoreconnect.apple.com
Apple IDでログイン
```

### 2. 新規アプリ作成
1. 「マイApp」→「+」ボタン→「新規App」
2. 入力項目：
   - プラットフォーム: **iOS**
   - 名前: **めんどい**
   - プライマリ言語: **日本語**
   - バンドルID: **com.taichi.mendoi**
   - SKU: **mendoi-ios-app**（任意の一意識別子）

### 3. アプリ情報入力

#### 基本情報
- サブタイトル: **認知的負荷を減らすマイクロステップアシスタント**
- カテゴリ:
  - プライマリ: **生産性**
  - セカンダリ: **ライフスタイル**
- プライバシーポリシーURL: **https://gist.github.com/TaichiAkimoto/8351aeedfb5e5d875b79a982d64b6a0b**

#### 説明文（日本語）
```
やりたくないこと、ありませんか？

「めんどい」は認知的負荷により動けなくなったあなたを、
マイクロステップ分解とAI励ましでサポートします。

【特徴】
✨ タスクを4-6個の超具体的なステップに自動分解
🎤 音声入力対応で、考えるのもめんどいあなたに
💪 第1ステップは必ず物理的な動作（立つ、歩く）
🤗 心理的ハードルを極限まで下げる優しい設計
⚡ Gemini AIによる高品質なステップ生成

【こんな方におすすめ】
- やらなきゃいけないのに動けない
- タスクが大きすぎて何から始めればいいか分からない
- ADHD傾向で計画を立てるのが苦手
- 完璧主義で最初の一歩が踏み出せない

【使い方】
1. やりたくないことを入力（音声でもOK）
2. AIがマイクロステップに分解
3. 第1ステップだけやってみる
4. できなくても大丈夫 👍

まずは「封筒を開ける」から始めましょう。
```

#### 説明文（英語 - オプション）
```
Struggling to start tasks?

"Mendoi" helps you overcome cognitive overload by breaking down
overwhelming tasks into tiny, achievable micro-steps with AI support.

Features:
✨ Auto-decompose tasks into 4-6 specific steps
🎤 Voice input support
💪 First step is always physical movement
🤗 Minimizes psychological barriers
⚡ Powered by Gemini AI

Perfect for:
- Task paralysis and procrastination
- ADHD-friendly planning
- Perfectionists who struggle to start
- Breaking down overwhelming projects

Start with something small, like "open an envelope."
```

#### キーワード
```
タスク管理,ADHD,認知,マイクロステップ,AI,生産性,やる気,モチベーション,先延ばし,Todo
```

### 4. スクリーンショットアップロード
- デバイス: **iPhone 6.7"（iPhone 16 Pro Max）**
- 順番に5枚全てアップロード（01〜05）

### 5. App Storeアイコン
- `app-icon-1024.png` をアップロード

### 6. プレビュー動画（オプション）
- `app-preview-video.mp4` をアップロード

### 7. プライバシー設定
- データ収集: **匿名ユーザーID**のみ（Firebase匿名認証）
- 個人情報収集: **なし**
- 位置情報: **使用しない**
- トラッキング: **なし**

### 8. Xcodeアーカイブ作成・アップロード

```bash
cd /Users/taichi/new/mendoi/ios

# アーカイブ作成
xcodebuild -workspace Mendoi.xcworkspace \
  -scheme Mendoi \
  -configuration Release \
  -archivePath ~/Desktop/mendoi-app-store-assets/Mendoi.xcarchive \
  archive

# Xcodeで開いてDistribute App
open ~/Desktop/mendoi-app-store-assets/Mendoi.xcarchive
```

または：
```bash
# Xcode GUIから
# 1. Xcode → Product → Archive
# 2. Organizer → Distribute App → App Store Connect
# 3. アップロード完了を待つ
```

### 9. 審査提出
1. App Store Connectでビルドを選択
2. 「審査に提出」ボタンをクリック
3. 追加情報入力（必要な場合）
4. 提出完了

## トラブルシューティング

### アーカイブ失敗
- **原因**: Signing設定が不正
- **解決**: Xcode → Signing & Capabilities → Team選択
- **確認**: Automatically manage signing有効化

### アップロード失敗（Application Loader）
- **原因**: バンドルIDの不一致
- **解決**: App Store ConnectとXcodeのバンドルIDが一致しているか確認
- **確認**: `com.taichi.mendoi`

### スクリーンショットサイズエラー
- **原因**: 解像度が要件を満たしていない
- **解決**:
  - iPhone 6.7" (2796 x 1290 pixels)
  - すでに撮影済みのスクリーンショットは正しいサイズ

## 技術情報

### 使用技術
- **フロントエンド**: Swift 5, SwiftUI, iOS 16.0+
- **認証**: Firebase Anonymous Authentication
- **バックエンド**: Cloud Run (Node.js/Express)
- **AI**: Google Gemini API
- **依存関係**: CocoaPods (Firebase, Lottie)

### APIエンドポイント
- **URL**: https://mendoi-api-glhnu2cdda-an.a.run.app
- **認証**: Firebase ID Token (Bearer)
- **Rate Limit**: 10 req/min per UID

### ビルド設定
- **最小iOS**: 16.0
- **対応デバイス**: iPhone（縦向き、横向き）
- **サポート言語**: 日本語（プライマリ）

## 次回セッションでの再開

「App Store Connectで続きから」と言えば、Claude in Chromeを使って提出作業を継続できます。
