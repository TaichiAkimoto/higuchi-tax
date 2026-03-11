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

### 🎉 App Store審査提出完了！
- **提出日**: 2026-01-31
- **バージョン**: 1.0 (Build 1)
- **ステータス**: 審査待ち
- **App Store Connect**: https://appstoreconnect.apple.com/apps/6758537966/distribution/ios/version/inflight

**完了した項目**:
1. ✅ サポートURL: プライバシーポリシー設定
2. ✅ 13インチiPadスクリーンショット（5枚）
3. ✅ 連絡先情報入力
4. ✅ 著作権情報（2026 Taichi Akimoto）
5. ✅ コンテンツ配信権設定
6. ✅ 年齢制限指定（4+、全て「なし」）
7. ✅ 価格設定（無料、174カ国）

### ✅ 完了（freee仕分け作業）
- **MasterCard**: 全123件登録完了
  - 交際費（ジョイナス/ダイニー/ラバロック/キソジ）
  - 通信費（GOOGLE/MESHY/CLAUDE.AI/Adobe/楽天モバイル/OPENAI/TRIPO等）
  - 会議費・8%軽減税率（タリーズ/ケンタッキー/モスバーガー）
  - 消耗品費（AMAZON/東急スクエア/マークイズ）
  - 地代家賃（ステーションスイッチ）
  - 旅費交通費（モバイルスイカ×2）
- **楽天**: 全21件登録完了（口座振替、横浜銀行振込、預金利息等）
- **横浜（API）口座**: ニシレイコ（売上高）登録、プライベート11件+楽天を「明細を無視」
- **2025年度入力完了**: 株式譲渡益3件（WILVENTURES +6.2M、エンジェルブリッジ +9.3M、ミズホグロ +3.1M）を除き全件完了
- **樋口先生への返信文**: 作成済み（Obsidian Daily Note保存）
- **株式譲渡契約書**: デスクトップに3つのPDF準備完了

### ✅ 完了（確定申告e-Tax提出確認）
- **e-Tax申告受付確認**: 2026/03/09 08:53:59 受付完了
  - 受付番号: 20260309085359538114
  - 納税額: 2,662,600円（検証済み）
  - 提出先: 神奈川税務署
  - 年分: 令和07年分（2025年度）
- **樋口先生への返信文**: 作成済み

**次のステップ**:
1. **樋口先生へメール送信**: 受付確認完了の報告
2. **納税対応**: 2,662,600円の納付（ダイレクト納付/ATM/スマホアプリ等）

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

### 2026-03-11: e-Tax申告受付内容確認
- **樋口先生からの連絡**: 3/9にe-Tax申告完了、受付内容確認を依頼された
- **マイナポータル→e-Tax連携**: QRコード認証でマイナポータルにログイン後、e-Taxメッセージボックスへ遷移
  - パスワード不要でマイナポータル連携により直接アクセス
  - 受付番号: 20260309085359538114
  - 受付日時: 2026/03/09 08:53:59
  - 納税額: 2,662,600円（前回検証した税額と一致）
- **返信文作成**: 樋口先生への確認完了報告文を作成
- **次のアクション**: 納税対応（ダイレクト納付/ATM/スマホアプリ等）

### 2026-03-06: e-Tax利用者識別番号確認
- **樋口先生から依頼**: 確定申告書のe-Tax送信のために利用者識別番号（16桁）を要求された
- **マイナポータル経由で確認**: e-Taxサイトのログインが複雑だったため、マイナポータルから連携
  - マイナポータルにログイン（マイナンバーカード + スマホQR認証）
  - 外部サイトとの連携 → e-Tax → 基本情報で番号確認
- **利用者識別番号**: `1735 0327 1493 0071`
- **返信文作成**: 樋口先生への返信文を作成（送信前確認待ち）

### 2026-03-04: 確定申告書v2検証・樋口先生返信文作成
- **税額検証**: 樋口先生からの更新版申告書（社会保険料676,100円反映済み）を全て検算
  - 課税所得: 18,711,000 - 1,324,020 = 17,386,980
  - 所得税15%: 2,607,900、復興税2.1%: 54,765、合計: 2,662,600 → 全て正確
- **返信文作成**: 内容確認完了、提出お願いする旨の返信文を作成

### 2026-03-03: 確定申告 国保納付額確認・樋口先生返信文作成完了
- **国保納付額調査**: freee + 横浜銀行ネットバンキングで確認、推定年間合計: **676,100円**
- **樋口先生への返信文**: 作成完了（国保676,100円、国民年金67,920円、添付書類3通）
- **発見**: 横浜銀行のWeb口座（無通帳）でない場合、API・ネットバンキング共に照会は直近6か月のみ

---

**過去のセッション詳細**:
- [2026年2月](./.claude/sessions/2026-02-sessions.md)
- [2026年1月](./.claude/sessions/2026-01-sessions.md)
