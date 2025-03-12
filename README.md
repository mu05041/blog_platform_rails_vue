# blog_platform_rails_vue
Ruby on Rails와 Vue.js를 사용한 간단한 블로그 플랫폼입니다.

## 프로젝트 설명
이 프로젝트는 dataX의 과제 테스트로 개발된 블로그 플랫폼입니다. 사용자는 글을 작성, 편집, 삭제할 수 있으며 카테고리와 태그를 통해 글을 분류할 수 있습니다.

## 기술 스택
- Backend: Ruby on Rails
- Frontend: Vue.js
- 상태 관리: Pinia
- 데이터베이스: SQLite
- 기타 라이브러리: 
    - Axios (HTTP 클라이언트)
    - Bootstrap (UI 프레임워크)


## 기능 설명
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

## 설치 및 실행 방법
### 요구사항
- Ruby 3.3.0
- Rails 8.0.1
- Node.js 18.19.1

### 주요 GEM
- sqlite3 2.6.0
- bcrypt 3.1.20

### セットアップ手順
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


## 任意で工夫したポイント
- ERD 정확성
- API 설계
- 프론트엔드 상태관리


## 스크린샷