<template>
  <div class="container py-4">
    <h2 class="text-center mb-4">新規投稿</h2>
    
    <!-- エラーメッセージ -->
    <div v-if="error" class="alert alert-danger">{{ error }}</div>

    <!-- 投稿フォーム -->
    <div class="row">
      <div class="col-lg-8 col-md-10 mx-auto">
        <form @submit.prevent="createPost">
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
          
          <!-- コンテンツ入力 -->
          <div class="mb-3">
            <label for="content" class="form-label">コンテンツ</label>
            <textarea 
              class="form-control" 
              id="content" 
              v-model="postForm.content" 
              rows="10" 
              required 
              placeholder="内容を入力してください"
            ></textarea>
          </div>

          <!-- タグ入力 -->
          <div class="mb-3">
            <label class="form-label">タグ</label>
            <div class="d-flex align-items-center mb-2">
              <input 
                type="text" 
                class="form-control me-2" 
                v-model="newTag" 
                @keyup.enter="addTag"
                placeholder="タグを入力"
                style="max-width: 80%;"
              >
              <button type="button" class="btn btn-primary" @click="addTag" >
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
            <label class="form-label">カテゴリ</label>
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
            <RouterLink :to="`/${username}/posts`" class="btn btn-secondary">
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
import { ref, onMounted, computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import axios from 'axios';
import { useAuthStore } from '@/stores/auth';

const router = useRouter();
const route = useRoute();
const authStore = useAuthStore();
const API_URL = 'http://localhost:3000/api/v1';

// ユーザー名
const username = ref(authStore.user?.username || '');

// 投稿フォームのデータ
const postForm = ref({
  title: '',
  content: '',
  category_ids: [],
  tags: []
});

// 新しいタグの入力
const newTag = ref('');

// タグを追加するメソッド
const addTag = () => {
  if (newTag.value.trim()) {
    // 重複防止および空白削除
    const cleanedTag = newTag.value.trim().replace(/^#/, '');
    
    // すでに存在しないタグのみ追加
    if (!postForm.value.tags.includes(cleanedTag)) {
      postForm.value.tags.push(cleanedTag);
      newTag.value = ''; // 입력 필드 초기화
    }
  }
};

// タグを削除するメソッド
const removeTag = (index) => {
  postForm.value.tags.splice(index, 1);
};

// 投稿の状態管理
const isSubmitting = ref(false);
const error = ref('');

// storeからカテゴリを取得
import { useBlogStore } from '@/stores/blog';
const blogStore = useBlogStore();
const categories = computed(() => blogStore.categories);
const tags = computed(() => blogStore.tags);


// 投稿を作成する処理
const createPost = () => {
  isSubmitting.value = true;
  error.value = '';
  
  // 本文からタグを削除
  const contentWithoutTags = postForm.value.content.replace(/\s*#\w+/g, '').trim();
  
  // 本文から抽出されたタグを取得
  const extractedTags = postForm.value.content.match(/#\w+/g)?.map(tag => tag.replace('#', '')) || [];
  
  // 入力フィールドのタグと本文のタグを統合（重複を除外）
  const allTags = [...new Set([...postForm.value.tags, ...extractedTags])];

  
  // APIへ送信するデータ
  const postData = {
    post: {
      title: postForm.value.title,
      content: contentWithoutTags,
      published: true,
      category_ids: postForm.value.category_ids,
      tag_ids: allTags
    }
  };
  
  // APIリクエスト
  axios.post(`${API_URL}/posts`, postData)
    .then(() => {
      router.push(`/${username.value}/posts`);
    })
    .catch(err => {
      console.error('投稿エラー:', err);
      error.value = err.response?.data?.error || '投稿に失敗しました';
      isSubmitting.value = false;
    });
};

onMounted(() => {
  // カテゴリはすでにローカルに定義済み
});
</script>

<style scoped>
.badge {
  position: relative;
  padding-right: 1.5rem;
}

.btn-close {
  position: absolute;
  top: -0.25rem;
  right: -0.25rem;
}

@media (max-width: 576px) {
  .form-check {
    width: 50%;
    margin-bottom: 0.5rem;
  }
}
</style>