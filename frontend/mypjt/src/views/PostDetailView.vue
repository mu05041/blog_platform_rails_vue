<template>
    <div class="container py-4">
      <!-- エラー -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      
      <!-- ローディング状況 -->
      <div v-if="isLoading && !error" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">now loading...</span>
        </div>
        <p class="mt-2">記事を読み込み中です...</p>
      </div>
      
      <!--記事コンテンツ -->
      <div v-else-if="post.id" class="row">
        <div class="col-lg-10 col-md-12 mx-auto">
          <h1 class="mb-3">{{ post.title }}</h1>
          
          <div class="text-muted mb-4">
            {{ formatDate(post.created_at) }}
          </div>
          
          <!-- カテゴリとタグ -->
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
          
          <hr class="mb-4">
          
          <div class="post-content mb-5">
            {{ post.content }}
          </div>
          
          <!-- 自分のブログの場合、編集・ 削除ボタンを表示-->
          <div v-if="isMyBlog" class="mt-4">
            <RouterLink :to="`/posts/${post.id}/edit`" class="btn btn-primary me-2">
              修正
            </RouterLink>
            <button @click="deletePost" class="btn btn-danger">削除</button>
          </div>
          
          <div class="mt-4">
            <RouterLink :to="`/${username}/posts`" class="btn btn-secondary">
              リストへ
            </RouterLink>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useRoute, useRouter } from 'vue-router';
  import axios from 'axios';
  import { useAuthStore } from '@/stores/auth';
  
  const route = useRoute();
  const router = useRouter();
  const authStore = useAuthStore();
  const API_URL = 'http://localhost:3000/api/v1';
  const post = ref({});
  const error = ref(null);
  const isLoading = ref(true);
  
  // URLからユーザー名とIDを取得
  const username = ref(route.params.username || '');
  const postId = ref(route.params.id || '');
  
  // 自分のブログかどうかを確認
  const isMyBlog = ref(false);
  
  // ログイン状態を確認して自分のブログかどうかを設定
  if (authStore.user && username.value === authStore.user.username) {
    isMyBlog.value = true;
  }
  
  // 記事を読み込む読み込む
  const fetchPost = () => {
    isLoading.value = true;
    error.value = '';
    
    // APIエンドポイントを設定
    const endpoint = `${API_URL}/${username.value}/posts/${postId.value}`;
    
    // セッションベースの認証なので別途ヘッダーは不要
    const headers = {};
    
    axios({
      method: 'get',
      url: endpoint,
      headers
    })
    .then(res => {
      post.value = res.data;
      isLoading.value = false;
    })
    .catch(err => {
      console.error('Error fetching post:', err);
      error.value = err.response?.data?.error || '記事の読み込む中にエラーが発生しました。';
      isLoading.value = false;
    });
  }
  
  // 記事削除
  const deletePost = () => {
    if (!confirm('本当にこの記事を削除しますか?')) return;
    
    axios.delete(`${API_URL}/posts/${post.value.id}`)
      .then(() => {
        router.push(`/${username.value}/posts`);
      })
      .catch(err => {
        console.error('削除エラー:', err);
        alert('記事の削除に失敗しました。');
      });
  }
  
  // date format
  const formatDate = (dateString) => {
    if (!dateString) return '';
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('ja-JP', options);
  }
  
  onMounted(() => {
    fetchPost();
  });
  </script>
  
  <style scoped>
  .post-content {
    line-height: 1.8;
    font-size: 1.1rem;
  }
  
  /* モバイルレスポンシブスタイル */
  @media (max-width: 576px) {
    h1 {
      font-size: 1.8rem;
    }
    
    .post-content {
      font-size: 1rem;
    }
  }
  </style>