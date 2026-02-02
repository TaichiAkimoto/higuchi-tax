# めんどいアプリ - 2026年1月のセッション詳細

## 2026-01-31 (1): App Store提出準備完了

### UI改善
- **TextField → TextEditor**: 多行入力対応、ZStackでカスタムプレースホルダー
- **権限最適化**: 音声入力権限を初回タップ時に要求（onAppear削除）

### Lottieアニメーション統合
- After Effects MCPで5段階グラデーションステップを作成
- `loading-animation.json` (5.9KB) をプロジェクトに追加
- `lottie-ios` podを追加
- TaskInputView.swiftに統合（200x200、ループ再生）

### アプリアイコン
- PiAPI/Midjourneyでグラデーション階段デザイン生成

### スクリーンショット
iPhone 16 Pro Maxシミュレーターで5枚撮影:
1. スタート画面
2. タスク入力画面（空）
3. タスク入力画面（入力済み「確定申告の書類を整理する」）
4. Lottieローディング画面
5. 生成されたステップ画面

### プライバシーポリシー
- HTML作成→Gistで公開
- URL: https://gist.github.com/TaichiAkimoto/8351aeedfb5e5d875b79a982d64b6a0b

### 全素材整理
`~/Desktop/mendoi-app-store-assets/` にまとめ

---

## 2026-01-30: Firebase認証問題の解決

### 問題
GoogleService-Info.plistに誤ったAPI_KEY（Gemini APIキー）が設定

### 解決
- Claude in Chromeを使用してFirebase Consoleから正しいファイルをダウンロード
- API_KEY: `AIzaSyCUQCkwhz7Sz7wi_2j3wdtH9Cva2Ruyo04`（Firebase用）
- 匿名認証成功を確認
