<template>
  <div class="container py-4">
    <!-- ブログヘッダー -->
    <div class="row mb-4">
      <div class="col-12">
        <h2 class="text-center fw-bold blog-title">{{ `${username}のブログ` }}</h2>
        <p class="text-center text-muted">{{ isMyBlog ? 'マイブログ' : '公開ブログ投稿リスト' }}</p>
        
        <!-- 自分のブログの場合のみ表示される投稿ボタン -->
        <div v-if="isMyBlog" class="text-center mt-3">
          <RouterLink to="/posts/create" class="btn btn-success">
            新規投稿
          </RouterLink>
        </div>
      </div>
    </div>

      <!-- 検索とフィルタリングUI -->
        <div class="row mb-4">
      <div class="col-md-6 mb-3 mb-md-0">
        <div class="input-group">
          <input 
            type="text" 
            class="form-control" 
            placeholder="記事を検索..." 
            v-model="searchQuery"
            @input="filterPosts"
          >
          <button class="btn btn-outline-secondary" type="button" @click="filterPosts">
            <i class="bi bi-search"></i> 検索
          </button>
        </div>
      </div>
      <div class="col-md-6">
        <select class="form-select" v-model="selectedCategory" @change="filterPosts">
          <option value="">全てのカテゴリ</option>
          <option v-for="category in categories" :key="category.id" :value="category.id">
            {{ category.name }}
          </option>
        </select>
      </div>
    </div>
    
  
    <!-- ローディング状態 -->
    <div v-if="isLoading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">読み込み中...</span>
      </div>
      <p class="mt-2">記事をロード中....</p>
    </div>

    <!-- エラーメッセージ -->
    <div v-else-if="error" class="alert alert-danger" role="alert">
      {{ error }}
    </div>

    <!-- 記事がない場合 -->
    <div v-else-if="posts.length === 0" class="text-center py-5">
      <p>まだ投稿がありません。</p>
    </div>

    <!-- ブログ投稿リスト -->
    <div v-else class="row">
      <div v-for="post in filteredPosts" :key="post.id" class="col-md-6 mb-4">
        <div class="card w-100 h-100 shadow-sm">
          <div class="card-body">
            <h5 class="card-title">{{ post.title }}</h5>
            <p class="card-text">{{ createExcerpt(post.content) }}</p>
            
            <div v-if="post.categories && post.categories.length > 0" class="mb-2">
              <span v-for="category in post.categories" :key="category.id" 
                    class="badge bg-light text-dark me-1">
                {{ category.name }}
              </span>
            </div>
            
            <div v-if="post.tags && post.tags.length > 0" class="mb-3">
              <span v-for="tag in post.tags" :key="tag.id" 
                    class="badge bg-primary me-1">
                {{ tag.name }}
              </span>
            </div>
            
            <div class="d-flex justify-content-between align-items-center">
              <small class="text-muted">{{ formatDate(post.created_at) }}</small>
              <RouterLink :to="`/${username}/posts/${post.id}`" class="btn btn-primary">
                詳細を見る
              </RouterLink>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import axios from 'axios';
import { useAuthStore } from '@/stores/auth';

const route = useRoute();
const authStore = useAuthStore();
const API_URL = 'http://localhost:3000/api/v1';
// セッションクッキーによる認証管理のため、axiosリクエスト時に認証情報を含める
axios.defaults.withCredentials = true;
const posts = ref([]);
const isLoading = ref(true);
const error = ref('');

// URLからユーザー名を取得
const username = ref(route.params.username || '');

// 自分のブログかどうかを確認
const isMyBlog = ref(false);

// ログイン状態を確認し、自分のブログかどうかを設定
if (authStore.user && username.value === authStore.user.username) {
  isMyBlog.value = true;
}

// storeからカテゴリ取得
import { useBlogStore } from '@/stores/blog';
const blogStore = useBlogStore();
const categories = computed(() => blogStore.categories);
const tags = computed(() => blogStore.tags);

// フィルタリングと検索の状態
const selectedCategory = ref('');
const searchQuery = ref('')

// フィルタリングの有無を確認
const isFiltering = computed(() => {
  return selectedCategory.value !== ''
});

// フィルタリングを適用
const filterPosts = () => {
  console.log('フィルター適用: カテゴリー:', selectedCategory.value);
};


// フィルタリングされた投稿リスト
const filteredPosts = computed(() => {
  return posts.value.filter(post => {
    
    // 検索ワードのフィルタリング（タイトルと本文から検索）
    const searchMatch = searchQuery.value === '' || 
    post.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    post.content.toLowerCase().includes(searchQuery.value.toLowerCase());


    // カテゴリフィルターの確認
    const categoryMatch = selectedCategory.value === '' || 
      (post.categories && post.categories.some(cat => cat.id === selectedCategory.value));
    
    // 両方の条件を満たす必要がある
    return searchMatch && categoryMatch;
  });
});

// カテゴリの設定
const setCategory = (categoryId) => {
  selectedCategory.value = categoryId;
  console.log("selectedCategory =", selectedCategory)
};

// フィルターのリセット
const resetFilters = () => {
  selectedCategory.value = ''
};


// 記事情報の取得
const getBlogPosts = () => {
  isLoading.value = true;
  error.value = '';
  
  // APIエンドポイントの設定
  const endpoint = `${API_URL}/${username.value}/posts`;
  
  // セッションベースの認証のため、追加のヘッダーは不要
  const headers = {};
  
  axios({
    method: 'get',
    url: endpoint,
    headers
  })
  .then(res => {
    posts.value = res.data;
    console.log('posts=',posts.value)
    isLoading.value = false;
  })
  .catch(err => {
    console.error('Error fetching posts:', err);
    error.value = err.response?.data?.error || '記事を読み込む中にエラーが発生しました';
    isLoading.value = false;
  });
};

// date format
const formatDate = (dateString) => {
  if (!dateString) return '';
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('ja-JP', options);
};

// コンテンツの要約
const createExcerpt = (content, maxLength = 100) => {
  if (!content) return '';
  if (content.length <= maxLength) return content;
  return content.substring(0, maxLength) + '...';
};

onMounted(() => {
  getBlogPosts();
});
</script>

<style scoped>
.blog-title {
  color: #333;
}

.card {
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
}

/* モバイルレスポンシブ */
@media (max-width: 576px) {
  .card {
    margin-bottom: 1rem;
  }
}
</style>