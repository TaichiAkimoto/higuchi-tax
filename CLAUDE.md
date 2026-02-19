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

### 🔄 進行中
- **キャラクターUI検討**: 黒背景+光る目のペットのようなUIを検討
  - Canvas実装で試したが、デザインが要件に合わず
  - 全て破棄して元の状態に戻した（TaskInputView維持）
  - 次回: 別のアプローチでUI改善を検討

**次のステップ**:
- Appleからの審査結果を待つ（通常24-48時間）
- 承認後、自動でApp Storeにリリース
- UI改善案の再検討（キャラクターベースのインタラクション）

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

### 2026-02-19 (3): freee仕分け作業 横浜口座の明細無視進行中
- **freee MasterCard 19件**: 全て完了（モバイルスイカ含む）
- **横浜（API）**: 3/33件「明細を無視」完了。残り30件あり。以下5件は樋口先生に任せるため保留:
  - +9,339,705 エンジェルブリッジユニコ（株式譲渡益）
  - +6,226,875 ガイタメ WILVENTURES（株式譲渡益）
  - +3,144,420 ミズホグロ（株式譲渡益）
  - +500,000 アキモト タイチ
  - -587,300 ジドウキ
- **楽天**: 21件未処理（全て事業関連、次回処理予定）
- **freee MasterCard**: 追加110件未処理（次回処理予定）
- **樋口先生への返信**: 未完了（次回）

### 2026-02-19 (2): freee仕分け作業 続き
- **ローソン -2,266** → 会議費/課対仕入8%（軽）で登録完了
- **ヒグチユウキ -165,000** → 支払手数料/課対仕入10%で登録完了
- **次**: TWILIO SENDGRID -3,234（通信費）、ノート -100（新聞図書費）など残りの未処理エントリを確認・一括登録
- freee操作tips → `~/.claude/projects/-Users-taichi-new-mendoi/memory/freee-tips.md`

### 2026-02-19: freee仕分け作業（税理士依頼分）
- **年度締め（2024年度）**: 完了 → 2025年度に移行
- **一括自動登録**: Claude AI/Adobe/RunPod等14件 → 通信費で登録
- **個別登録**: ブルーノート東京(交際費)、モバイルスイカ×2(旅費)
- 続き: 上記セッション(2)で処理

### 2026-02-02: キャラクターUI実装試行→Revert
- **目的**: 黒背景+光る目のペット風UIで音声入力を促進
- **実装内容**:
  - CharacterState.swift（4つの表情状態）
  - CharacterEyesView.swift（Canvas/Path実装、瞬き・パルスアニメーション）
  - CharacterInputView.swift（音声優先、テキストは代替手段）
  - AppStage/AppViewModel/ContentView修正
- **結果**: Xcode project.pbxprojへの手動ファイル追加でビルド成功
- **判断**: デザインが要件に合わず、全て破棄（git restore + ファイル削除）
- **学び**: Canvas実装は軽量だが、複雑なビジュアルデザインには向かない
- **次回**: 画像ベース、または別のアプローチでUI改善を検討

### 2026-01-31 (3): App Store審査提出成功 🎉
- **全必須項目完了**: サポートURL、著作権、連絡先、コンテンツ配信権、年齢制限、価格
- **年齢制限指定**: 7ステップの質問に回答（全て「なし」/「いいえ」）→ 4+評価
- **価格設定**: 無料、174カ国で配信
- **iPadスクリーンショット**: CLI（xcrun simctl）で13インチiPad Pro撮影
  - シミュレータ起動 → アプリビルド → 5枚撮影
  - `~/Desktop/mendoi-app-store-assets/ipad-screenshots/`
- **審査提出完了**: 全エラー解消、「審査用に追加」成功
- **次回**: 審査結果待ち（24-48時間）

### 2026-01-31 (2): App Store Connect審査提出作業中
- **アプリ登録**: Bundle ID `com.taichi.mendoi` を登録完了
- **基本情報入力**:
  - アプリ名、サブタイトル、カテゴリ（仕事効率化、ライフスタイル）
  - 説明文、キーワード入力完了
- **スクリーンショット**: iPhone 6.9" 5枚アップロード完了
- **プライバシー設定**: User ID（Firebase匿名認証）設定完了
  - 個人情報に関連付けなし
  - トラッキング使用なし
- **Xcodeアーカイブ作成**:
  - 問題: Info.plistに`UIInterfaceOrientationPortraitUpsideDown`欠落
  - 解決: Info.plistを修正してアーカイブ再作成成功
  - Team ID: N87AGP76YT (Distribution証明書使用)
- **ビルドアップロード**: IPA作成・アップロード成功（7.0MB）
- **輸出コンプライアンス**: 「上記のアルゴリズムのどちらでもない」選択
- **残タスク**: サポートURL、iPadスクリーンショット、連絡先、著作権、配信権、年齢制限
- **次回**: 残り5項目を入力して審査提出

---

**過去のセッション詳細**: [.claude/sessions/README.md](./.claude/sessions/README.md) を参照
