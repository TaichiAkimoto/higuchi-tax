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

**次のステップ**:
1. **樋口先生へメール送信**: 返信文作成済み、税額検証完了（2,662,600円）

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

### 2026-03-04: 確定申告書v2検証・樋口先生返信文作成
- **税額検証**: 樋口先生からの更新版申告書（社会保険料676,100円反映済み）を全て検算
  - 課税所得: 18,711,000 - 1,324,020 = 17,386,980
  - 所得税15%: 2,607,900、復興税2.1%: 54,765、合計: 2,662,600 → 全て正確
  - 税額減少: 676,100×15% ≈ 101,000円（樋口先生の説明「10万円ほど減少」と一致）
- **返信文作成**: 内容確認完了、提出お願いする旨の返信文を作成
- **次**: メール送信

### 2026-03-03: 確定申告 国保納付額確認・樋口先生返信文作成完了
- **国保納付額調査**: freee + 横浜銀行ネットバンキングで確認
  - freeeで5件確認（1-2月: 10,700円×2、10-12月: 92,000円×3）
  - 横浜銀行API・ネットバンキング共に直近6か月制限で3-8月データ取得不可と判明
  - 推定年間合計: **676,100円**（FY2024残り3回×10,700 + FY2025の7回×92,000）
- **樋口先生への返信文**: 作成完了
  - 国保: 推定676,100円（区役所に確認予定と明記）
  - 国民年金: 67,920円（2025年1月分のみ）
  - 国保加入ステータス: 現在国民健康保険加入
  - 添付リマインド: 株式譲渡契約書PDF 3通
- **発見**: 横浜銀行のWeb口座（無通帳）でない場合、API・ネットバンキング共に照会は直近6か月のみ
- **次**: メール送信 → 神奈川区役所に電話して正確な金額確認 → 必要に応じて修正連絡

### 2026-02-23 (2): 年金控除証明書取得（マイナポータル連携中）
- **マイナポータルログイン**: マイナンバーカード + スマホQRコードで認証成功
- **ねんきんネット連携開始**: マイナポータル⇔ねんきんネット連携を申請
- **ブロッカー**: 連携処理は平日8-23時のみ。次の平日朝9時以降に完了予定
- **控除証明書の種類確認**: 国民年金保険料のみ必要（国保は樋口先生から聞かれていない）
- **次**: 明日朝9時以降に連携完了確認 → ねんきんネットで控除証明書取得 → 樋口先生にメール送信

### 2026-02-23: 樋口先生メール返信準備完了
- **株式譲渡契約書の分析**: 3社（Angel Bridge, WiL Ventures, みずほ）への株式会社カナリー普通株15,400株売却
  - 総額: 18,711,000円（1株1,215円、全て2025/11/14付）
  - 取得費: ゼロ（創業期に無償取得）
- **返信文作成**: 事業所得△265万円、来期見込み（コンサル報酬）、給与収入なしを明記
- **添付書類準備**: デスクトップに契約書PDF 3通をコピー（WiL Venturesはzipから抽出）
- **Obsidian保存**: Daily/2026-02-23/樋口先生返信.md に詳細記録
- **次**: メール送信のみ

### 2026-02-20 (4): freee全口座ダブルチェック・樋口先生返信文作成
- **全口座確認**: Chrome DevTools MCPで未処理明細をダブルチェック
  - MasterCard: 0件（全件処理済み）
  - 楽天: 0件（全件処理済み）
  - 横浜（API）: 3件（株式譲渡益のみ、樋口先生に任せる）
- **樋口先生への返信文作成**: 2024年度年度締め完了、2025年度入力完了（株式譲渡益3件を除く）を報告
- **Obsidian Daily Note保存**: 返信文とダブルチェック結果を記録
- **次**: メール送信

### 2026-02-20 (3): freee MasterCard全件完了
- **MasterCard 23件**: 全て登録完了（交際費/通信費/会議費/消耗品費/地代家賃/旅費等）
  - Chrome DevTools MCPで一括修正（勘定科目input + 税区分select）
  - 海外サービス（CLAUDE/OPENAI/MESHY/TRIPO/GOOGLE CLOUD）は対象外に修正
  - 食事系（タリーズ/ケンタッキー/モスバーガー）は8%軽減税率に修正
- **横浜口座**: ニシレイコ（売上高）登録、プライベート11件を「明細を無視」で一括処理
  - ドロップダウンメニュー操作: `aria-label`でボタン特定 → MouseEvent座標クリック → popup内の「明細を無視」選択
- **楽天 神奈川税務署**: 明細を無視
- **完了**: freee仕分け作業全て完了（樋口先生保留3件を除く）

---

**過去のセッション詳細**:
- [2026年2月](./.claude/sessions/2026-02-sessions.md)
- [2026年1月](./.claude/sessions/2026-01-sessions.md)
