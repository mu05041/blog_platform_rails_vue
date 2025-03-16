# 💡 blog_platform_rails_vue
Ruby on RailsとVue.jsを使用したシンプルなブログプラットフォームです。

## 🌐 プロジェクトの説明
このプロジェクトは課題テストとして開発されたブログプラットフォームです。ユーザーは記事の作成、編集、削除ができ、カテゴリーを通じて記事を分類することができます。記事にタグを付けることもできます。

## 💻 技術スタック
- バックエンド: Ruby on Rails
- フロントエンド: Vue.js
- 状態管理: Pinia
- データベース: SQLite
- その他ライブラリ:
   - Axios (HTTPクライアント)
   - Bootstrap (UIフレームワーク)




## ✨ 機能仕様
1. **ブログ記事の管理**
   - 記事の投稿、編集、削除機能
   - カテゴリ選択機能
   - タグの追加、削除機能

2. **検索・フィルタリング機能**
   - Vue.jsを活用したカテゴリ別のフィルタリング
   - 記事検索機能の実装

3. **ユーザー認証機能**
   - ログイン・ログアウト機能
   - ユーザー登録機能

4. **レスポンシブデザイン**
   - モバイルデバイス対応
   - bootstrapフレームワークの利用

## 🚀 インストールと実行方法
### 📦 システム要件
- Ruby 3.3.0
- Rails 8.0.1
- Node.js 18.19.1

### 💎 主要ライブラリ（GEM）
- sqlite3 2.6.0
- bcrypt 3.1.20

### 🔧 セットアップ手順
バックエンド設定
```bash
# リポシトリをクローン
git clone https://github.com/mu05041/blog_platform_rails_vue.git
cd backend/mypjt

# バックエンド依存関係をインストール
bundle install

# データベース設定
rails db:create
rails db:migrate
rails db:seed
```

フロントエンド設定
``` bash
# フロントエンド依存関係をインストール
cd frontend/mypjt
npm install
npm install axios
npm i pinia-plugin-persistedstate
npm install bootstrap-vue-3


# サーバー起動
rails s  # バックエンド
npm run dev  # フロントエンドサーバ
```

##  🧪 テスト
### テストフレームワーク
- Minitest (Ruby on Railsデフォルトのテストフレームワーク)
### テスト実行方法
```bash
# 特定のコントローラーテストを実行
rails test

# Windows 環境の場合
rails test test\controllers\api\v1\posts_controller_test.rb

# Linux/Mac 環境の場合
rails test test/controllers/api/v1/posts_controller_test.rb
```

## 🔐 テストアカウント情報

### デフォルトログインアカウント
- メールアドレス: `admin@example.com`
- パスワード: `password123`


## 📖 任意で工夫したポイント
- **ERD設計**: M:N関係を適切に管理するため、中間テーブル（categories_posts, posts_tags）を設計しました。
- **REST API設計**: 設計段階で作成したAPI仕様を厳密に遵守し、一貫性のあるエンドポイントを実装しました。
- **フロントエンド状態管理**: ログイン情報の永続化のため、Piniaのpersisted stateを活用しました。


## 📸 スクリーンショット

### メインページ
- 記事リスト <br>
<img src="./images/postlist.png" width="70%"/>
- モバイル <br>
<img src="./images/mobile.png" height="50%"/>

### 記事作成画面
- 記事作成フォーム  <br>
<img src="./images/NewPost.png" width="70%"/>


### ユーザー認証画面
- ログインページ <br>
<img src="./images/login.png" width="50%"/>
- ユーザー登録ページ <br>
<img src="./images/signup.png" width="50%"/>

### 機能デモ
- レスポンシブレイアウト <br>
<img src="./images/responsive.gif"/>

## 📑 システムドキュメント
👉[API仕様およびERD](https://capricious-algebra-cf0.notion.site/DataX-1b2aaefa04e680d1a397c4a5243261a7)