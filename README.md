# 💡 blog_platform_rails_vue
Ruby on RailsとVue.jsを使用したシンプルなブログプラットフォームです。

## 🌐 プロジェクトの説明
このプロジェクトはdataXの課題テストとして開発されたブログプラットフォームです。ユーザーは記事の作成、編集、削除ができ、カテゴリーを通じて記事を分類することができます。記事にタグを付けることもできます。

## 💻 技術スタック
- バックエンド: Ruby on Rails
- フロントエンド: Vue.js
- 状態管理: Pinia
- データベース: SQLite
- その他ライブラリ:
   - Axios (HTTPクライアント)
   - Bootstrap (UIフレームワーク)




## ✨ 기능 설명
1. **ブログ記事の管理**
   - 글 작성, 편집, 삭제 기능
   - 카테고리 및 태그 관련 기능

2. **検索・フィルタリング機能**
   - Vue.js를 활용한 카테고리별 필터링
   - 검색 기능 구현

3. **ユーザー認証機能**
   - 로그인/로그아웃 기능
   - [추가 인증 관련 구현 사항]

4. **レスポンシブデザイン**
   - 모바일 환경 대응
   - bootstrap 사용

## 🚀 설치 및 실행 방법
### 📦 요구사항
- Ruby 3.3.0
- Rails 8.0.1
- Node.js 18.19.1

### 💎 주요 GEM
- sqlite3 2.6.0
- bcrypt 3.1.20

### 🔧 セットアップ手順
백엔드 설정
```bash
# 저장소 클론
git clone https://github.com/mu05041/blog_platform_rails_vue.git
cd backend/mypjt

# 백엔드 의존성 설치
bundle install

# 데이터베이스 설정
rails db:create
rails db:migrate
rails db:seed
```

프론트엔드 설정
``` bash
# 프론트엔드 의존성 설치
cd frontend/mypjt
npm install
npm install axios
npm i pinia-plugin-persistedstate
npm install bootstrap-vue-3


# 서버 실행
rails s  # 백엔드 서버
npm run dev  # 프론트엔드 서버
```

##  🧪 테스트
### 테스트 프레임워크
- Minitest (Ruby on Rails 기본 테스트 프레임워크)
### 테스트 실행 방법
```bash
# 모든 테스트 실행
rails test

# 특정 컨트롤러 테스트 실행행
rails test 
rails test test\controllers\api\v1\posts_controller_test.rb

```

## 任意で工夫したポイント
- ERD 정확성: 테이블간의 관계설정이 정확하게 되도록 확인. POST와 CATEGORIES, POST와 TAG가 M:N 관계를 맺게 연결함. 
- REST API 설계: 설계단계에서 작성한 API명세를 정확히 따르도록함. REST API 설계 원칙을 따르도록 노력함.
- 프론트엔드 상태관리: 로그인/회원등록과 카테고리 매핑정보는 Pinia를 통해 관리함.



## 📸 스크린샷


## 📑 시스템 문서
👉[API仕様およびERD](https://capricious-algebra-cf0.notion.site/DataX-1b2aaefa04e680d1a397c4a5243261a7)