# Mendoi Backend - Terraform Infrastructure

TerraformでGCP Cloud Runにバックエンドをデプロイします。

## 前提条件

- Google Cloud SDK (`gcloud`) がインストール済み
- Terraform >= 1.0 がインストール済み
- Docker がインストール済み
- GCPプロジェクトが作成済み
- Gemini API キーが取得済み
- Firebase プロジェクトが作成済み（iOSアプリと同じプロジェクト）
- Firebase Service Account の秘密鍵が取得済み

## セットアップ

### 1. Firebase Service Account の秘密鍵を取得

1. [Firebase Console](https://console.firebase.google.com/) を開く
2. プロジェクト設定 → サービスアカウント
3. 「新しい秘密鍵の生成」をクリック
4. ダウンロードしたJSONファイルから以下を取得:
   - `project_id`
   - `client_email`
   - `private_key`

### 2. terraform.tfvars の作成

```bash
cd backend/terraform
cp terraform.tfvars.example terraform.tfvars
```

`terraform.tfvars` を編集して、以下の値を設定:

```hcl
project_id = "your-gcp-project-id"
region = "asia-northeast1"
gemini_api_key = "your-gemini-api-key"
firebase_project_id = "your-firebase-project-id"
firebase_client_email = "firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com"
firebase_private_key = "-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n"
image_tag = "latest"
```

**重要**: `firebase_private_key` は改行を `\n` に置き換えて1行にしてください。

### 3. GCPにログイン

```bash
gcloud auth login
gcloud auth application-default login
```

### 4. デプロイ

```bash
cd backend/terraform
./deploy.sh
```

デプロイスクリプトは以下を実行します:
1. 必要なGCP APIを有効化
2. Terraform初期化（初回のみ）
3. Terraformプラン作成
4. Terraformリソース作成（Secret Manager、Cloud Run、IAMなど）
5. Dockerイメージをビルド
6. Artifact Registryにプッシュ
7. Cloud Runサービスをデプロイ

### 5. デプロイ確認

```bash
# Cloud Run URLを取得
terraform output cloud_run_url

# ヘルスチェック
curl https://mendoi-api-xxxxx.run.app/health

# レスポンス例
{"status":"ok","timestamp":"2026-01-30T07:00:00.000Z"}
```

## 管理されるリソース

- **Cloud Run サービス**: `mendoi-api`
- **Artifact Registry リポジトリ**: `mendoi`
- **Secret Manager シークレット**:
  - `gemini-api-key`
  - `firebase-project-id`
  - `firebase-client-email`
  - `firebase-private-key`
- **Service Account**: `mendoi-cloud-run@PROJECT_ID.iam.gserviceaccount.com`
- **IAM ポリシー**: Secret Manager アクセス、Cloud Run Invoker

## 手動デプロイ（deploy.sh を使わない場合）

### Terraform のみ実行

```bash
terraform init
terraform plan
terraform apply
```

### Docker イメージのビルドとプッシュ

```bash
# 認証設定
gcloud auth configure-docker asia-northeast1-docker.pkg.dev

# ビルド
cd backend
docker build -t asia-northeast1-docker.pkg.dev/PROJECT_ID/mendoi/mendoi-backend:latest .

# プッシュ
docker push asia-northeast1-docker.pkg.dev/PROJECT_ID/mendoi/mendoi-backend:latest

# Cloud Run 更新
cd terraform
terraform apply -auto-approve
```

## 更新

コードを更新した場合:

```bash
cd backend/terraform
./deploy.sh
```

または、イメージタグを変更する場合:

```bash
# terraform.tfvars で image_tag を更新
image_tag = "v1.0.1"

# デプロイ
./deploy.sh
```

## トラブルシューティング

### エラー: "Permission denied"

```bash
# Service Account に必要な権限を付与
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:mendoi-cloud-run@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

### エラー: "API not enabled"

```bash
gcloud services enable run.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable secretmanager.googleapis.com
```

### ログの確認

```bash
gcloud run logs read mendoi-api --region=asia-northeast1 --limit=50
```

## クリーンアップ

リソースを削除する場合:

```bash
terraform destroy
```

**注意**: Secret Managerのシークレットは削除後30日間保持されます。

## セキュリティ

- `terraform.tfvars` は `.gitignore` に含まれており、Gitにコミットされません
- 秘密鍵はSecret Managerで暗号化されて保存されます
- Cloud RunサービスアカウントにはSecret Managerへの最小限のアクセス権のみ付与されます

## コスト

- Cloud Run: 使用量に応じた課金（最小インスタンス数: 0）
- Artifact Registry: ストレージ課金
- Secret Manager: シークレットバージョン課金

詳細: [Google Cloud Pricing](https://cloud.google.com/pricing)
