# ポジティブ日記アプリ

ネガティブな文章を、AIを使って前向きでポジティブな表現に変換するウェブアプリケーションです。

## 機能

- 日記の投稿
- OpenAI API（GPT-3.5-turbo）を使用したポジティブな表現への変換
- 変換前と変換後の日記の表示
- 日記一覧表示

## 技術スタック

- Ruby 3.2.2
- Ruby on Rails 7.2
- Bootstrap 5.3
- OpenAI API
- SQLite（開発環境）／PostgreSQL（本番環境）

## セットアップ方法

### 前提条件

- Ruby 3.2.2
- Bundler
- SQLite3（開発用）
- OpenAI APIキー

### インストール手順

1. リポジトリのクローン：
```bash
git clone https://github.com/yourusername/positive_diary.git
cd positive_diary
```

2. 依存関係のインストール：
```bash
bundle install
```

3. データベースのセットアップ：
```bash
rails db:create
rails db:migrate
```

4. 環境変数の設定（.envファイル）：
```
OPENAI_API_KEY=your_openai_api_key_here
```

5. アプリケーションの起動：
```bash
rails server
```

## AWSへのデプロイ方法

### GitHub Actionsを使ったElastic Beanstalkへのデプロイ

1. AWSアカウントで以下の設定を行います：
   - Elastic Beanstalkアプリケーション「positive-diary」を作成
   - 環境「positive-diary-prod」を作成（プラットフォームはRuby）
   - RDSでPostgreSQLデータベースを作成（オプション）

2. GitHubリポジトリの「Settings」>「Secrets」>「Actions」で以下のシークレットを設定します：
   - `AWS_ACCESS_KEY_ID`: AWSのアクセスキーID
   - `AWS_SECRET_ACCESS_KEY`: AWSのシークレットアクセスキー
   - `OPENAI_API_KEY`: OpenAI APIのキー

3. メインブランチへプッシュすると、自動的にデプロイが開始されます。

### 手動デプロイ方法

1. Elastic Beanstalk CLIをインストール：
```bash
pip install awsebcli
```

2. Elastic Beanstalkの初期化：
```bash
eb init
```

3. アプリケーションのデプロイ：
```bash
eb deploy
```

## 注意事項

- OpenAI APIの使用には課金が発生する場合があります。
- 本番環境ではSQLiteではなくPostgreSQLなどのRDBMSを使用してください。

## ライセンス

MIT
