<template>
    <div class="container py-4">
      <h2 class="text-center mb-4">게시물 수정</h2>
      
      <!-- エラーメッセージ -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      
      <!-- ローディング状態 -->
      <div v-if="isLoading" class="text-center py-5">
        <div class="spinner-border text-primary"></div>
        <p class="mt-2">記事を読み込む中</p>
      </div>
  
      <!-- 投稿修正フォーム -->
      <div v-else class="row">
        <div class="col-lg-8 col-md-10 mx-auto">
          <form @submit.prevent="updatePost">
            <!-- タイトル入力 -->
            <div class="mb-3">
              <label for="title" class="form-label">タイトル</label>
              <input 
                type="text" 
                class="form-control" 
                id="title" 
                v-model="postForm.title" 
                required 
                placeholder="タイトルを入力してください"
              >
            </div>
            
            <!-- 内容入力 -->
            <div class="mb-3">
              <label for="content" class="form-label">내용</label>
              <textarea 
                class="form-control" 
                id="content" 
                v-model="postForm.content" 
                rows="10" 
                required 
                placeholder="内容を入力してください"
              ></textarea>
            </div>

          <!-- タグ入力エリア -->
          <div class="mb-3">
            <label class="form-label">해시태그</label>
            <div class="d-flex align-items-center mb-2">
              <input 
                type="text" 
                class="form-control me-2" 
                v-model="newTag" 
                @keyup.enter="addTag"
                placeholder="タグを入力"
              >
              <button type="button" class="btn btn-primary" @click="addTag">
                タグを追加
              </button>
            </div>
            
            <!-- タグ一覧 -->
            <div class="d-flex flex-wrap gap-2 mt-2">
              <span 
                v-for="(tag, index) in postForm.tags" 
                :key="index" 
                class="badge bg-primary position-relative"
              >
                #{{ tag }}
                <button 
                  type="button" 
                  class="btn-close btn-close-white position-absolute top-0 end-0" 
                  style="font-size: 0.5rem; padding: 0.2rem;"
                  @click="removeTag(index)"
                ></button>
              </span>
            </div>
          </div>
            
            <!-- カテゴリ選択 -->
            <div class="mb-3">
              <label class="form-label">카테고리</label>
              <div class="d-flex flex-wrap">
                <div v-for="category in categories" :key="category.id" class="form-check me-3">
                  <input 
                    class="form-check-input" 
                    type="checkbox" 
                    :id="`category-${category.id}`" 
                    :value="category.id" 
                    v-model="postForm.category_ids"
                  >
                  <label class="form-check-label" :for="`category-${category.id}`">
                    {{ category.name }}
                  </label>
                </div>
              </div>
            </div>
          

            <!-- ボタン -->
            <div class="d-flex justify-content-between">
              <RouterLink :to="`/${username}/posts/${postId}`" class="btn btn-secondary">
                キャンセル
              </RouterLink>
              <button type="submit" class="btn btn-primary" :disabled="isSubmitting">
                <span v-if="isSubmitting" class="spinner-border spinner-border-sm me-1"></span>
                投稿する
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted,computed } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  import axios from 'axios';
  import { useAuthStore } from '@/stores/auth';
  
  const router = useRouter();
  const route = useRoute();
  const authStore = useAuthStore();
  const API_URL = 'http://localhost:3000/api/v1';
  
  // URLからID取得
  const postId = ref(route.params.id || '');
  const username = ref(authStore.user?.username || '');
  
  // 投稿フォームデータ
  const postForm = ref({
    title: '',
    content: '',
    category_ids: [],
    tags: [],
  });
  
  // 状態管理
  const isLoading = ref(true);
  const isSubmitting = ref(false);
  const error = ref('');
  
  // storeからカテゴリ取得
  import { useBlogStore } from '@/stores/blog';
  const blogStore = useBlogStore();
  const categories = computed(() => blogStore.categories);

    // 新タグ入力
  const newTag = ref('');

  //タグ追加メソッド
  const addTag = () => {
    if (newTag.value.trim()) {
      // 重複タグの防止と空白の除去
      const cleanedTag = newTag.value.trim().replace(/^#/, '');
      
      // 既に存在しないタグのみ追加
      if (!postForm.value.tags.includes(cleanedTag)) {
        postForm.value.tags.push(cleanedTag);
        newTag.value = ''; // 入力フィールド初期化
      }
    }
  };

  // タグ削除メソッド
  const removeTag = (index) => {
    postForm.value.tags.splice(index, 1);
  };
  
  // 記事情報取得
  const fetchPost = () => {
    isLoading.value = true;
    error.value = '';
    
    // API エンドポイント設定 
    const endpoint = `${API_URL}/${username.value}/posts/${postId.value}`;
    
    // セッションベース認証のため別途ヘッダー不要
    axios.defaults.withCredentials = true;
    
    axios({
      method: 'get',
      url: endpoint
    })
    .then(res => {
      const post = res.data;
      postForm.value.title = post.title;
      postForm.value.content = post.content;
      
      // カテゴリとタグID設定
      if (post.categories) {
        postForm.value.category_ids = post.categories.map(cat => cat.id);
      }
      
      if (post.tags) {
        postForm.value.tags = post.tags.map(tag => tag.name);
      }
      
      isLoading.value = false;
    })
    .catch(err => {
      console.error('記事ロードエーラー:', err);
      error.value = err.response?.data?.error || '投稿を読み込み中にエラーが発生しました。';
      isLoading.value = false;
    });
  };
  
  //  投稿修正リクエスト
  const updatePost = () => {
    isSubmitting.value = true;
    error.value = '';

    // 本文からハッシュタグ削除
    const contentWithoutTags = postForm.value.content.replace(/\s*#\w+/g, '').trim();
    
    //　本文から抽出されたタグ
    const extractedTags = postForm.value.content.match(/#\w+/g)?.map(tag => tag.replace('#', '')) || [];
    
    // タグ入力フィールドのタグと本文ハッシュタグ統合（重複除去）
    const allTags = [...new Set([...postForm.value.tags, ...extractedTags])];

    
    // 投稿データ準備
    const postData = {
      post: {
        title: postForm.value.title,
        content: contentWithoutTags,
        published: true,
        category_ids: postForm.value.category_ids,
        tag_ids: allTags
      }
    };
    
    console.log("postData = ", postData)
    // APIリクエスト
    axios({
      method: 'put',
      url: `${API_URL}/posts/${postId.value}`,
      data: postData
    })
    .then(() => {
      router.push(`/${username.value}/posts/${postId.value}`);
    })
    .catch(err => {
      console.error('記事修正エラー:', err);
      error.value = err.response?.data?.error || '記事の修正に失敗しました。';
      isSubmitting.value = false;
    });
  };
  
  onMounted(() => {
    fetchPost();
  });
  </script>
  
  <style scoped>
  /* モバイルレスポンシブ */
  @media (max-width: 576px) {
    .form-check {
      width: 50%;
      margin-bottom: 0.5rem;
    }
  }
  </style>