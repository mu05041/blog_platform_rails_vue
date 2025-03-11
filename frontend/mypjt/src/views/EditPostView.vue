<template>
    <div class="container py-4">
      <h2 class="text-center mb-4">게시물 수정</h2>
      
      <!-- 오류 메시지 -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      
      <!-- 로딩 상태 -->
      <div v-if="isLoading" class="text-center py-5">
        <div class="spinner-border text-primary"></div>
        <p class="mt-2">게시물을 불러오는 중입니다...</p>
      </div>
  
      <!-- 게시물 수정 폼 -->
      <div v-else class="row">
        <div class="col-lg-8 col-md-10 mx-auto">
          <form @submit.prevent="updatePost">
            <!-- 제목 입력 -->
            <div class="mb-3">
              <label for="title" class="form-label">제목</label>
              <input 
                type="text" 
                class="form-control" 
                id="title" 
                v-model="postForm.title" 
                required 
                placeholder="제목을 입력하세요"
              >
            </div>
            
            <!-- 내용 입력 -->
            <div class="mb-3">
              <label for="content" class="form-label">내용</label>
              <textarea 
                class="form-control" 
                id="content" 
                v-model="postForm.content" 
                rows="10" 
                required 
                placeholder="내용을 입력하세요"
              ></textarea>
            </div>
            
            <!-- 카테고리 선택 -->
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
            
            <!-- 태그 선택 -->
            <div class="mb-4">
              <label class="form-label">태그</label>
              <div class="d-flex flex-wrap">
                <div v-for="tag in tags" :key="tag.id" class="form-check me-3">
                  <input 
                    class="form-check-input" 
                    type="checkbox" 
                    :id="`tag-${tag.id}`" 
                    :value="tag.id" 
                    v-model="postForm.tag_ids"
                  >
                  <label class="form-check-label" :for="`tag-${tag.id}`">
                    {{ tag.name }}
                  </label>
                </div>
              </div>
            </div>
            
            <!-- 버튼 그룹 -->
            <div class="d-flex justify-content-between">
              <RouterLink :to="`/${username}/posts/${postId}`" class="btn btn-secondary">
                취소
              </RouterLink>
              <button type="submit" class="btn btn-primary" :disabled="isSubmitting">
                <span v-if="isSubmitting" class="spinner-border spinner-border-sm me-1"></span>
                수정
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  import axios from 'axios';
  import { useAuthStore } from '@/stores/auth';
  
  const router = useRouter();
  const route = useRoute();
  const authStore = useAuthStore();
  const API_URL = 'http://localhost:3000/api/v1';
  
  // URL에서 id 가져오기
  const postId = ref(route.params.id || '');
  const username = ref(authStore.user?.username || '');
  
  // 게시물 폼 데이터
  const postForm = ref({
    title: '',
    content: '',
    category_ids: [],
    tag_ids: []
  });
  
  // 상태 관리
  const isLoading = ref(true);
  const isSubmitting = ref(false);
  const error = ref('');
  
  // 카테고리 및 태그 목록 (고정 데이터)
  const categories = ref([
    { id: 1, name: 'Travel' },
    { id: 2, name: 'Food' },
    { id: 3, name: 'Lifestyle' },
    { id: 4, name: 'Technology' },
    { id: 5, name: 'Sports' },
    { id: 6, name: 'Music' }
  ]);
  
  const tags = ref([
    { id: 1, name: 'Sunny' },
    { id: 2, name: 'Cloudy' },
    { id: 3, name: 'Rainy' },
    { id: 4, name: 'Snowy' },
    { id: 5, name: 'Windy' },
    { id: 6, name: 'Stormy' }
  ]);
  
  // 게시물 정보 가져오기
  const fetchPost = () => {
    isLoading.value = true;
    error.value = '';
    
    // API 엔드포인트 설정 - 명세서에 맞게 수정
    const endpoint = `${API_URL}/${username.value}/posts/${postId.value}`;
    
    // 세션 기반 인증이므로 별도 헤더 불필요
    axios.defaults.withCredentials = true;
    
    axios({
      method: 'get',
      url: endpoint
    })
    .then(res => {
      const post = res.data;
      postForm.value.title = post.title;
      postForm.value.content = post.content;
      
      // 카테고리와 태그 ID 설정
      if (post.categories) {
        postForm.value.category_ids = post.categories.map(cat => cat.id);
      }
      
      if (post.tags) {
        postForm.value.tag_ids = post.tags.map(tag => tag.id);
      }
      
      isLoading.value = false;
    })
    .catch(err => {
      console.error('게시물 로딩 오류:', err);
      error.value = err.response?.data?.error || '게시물을 불러오는 중 오류가 발생했습니다.';
      isLoading.value = false;
    });
  };
  
  // 게시물 수정 요청
  const updatePost = () => {
    isSubmitting.value = true;
    error.value = '';
    
    // 게시물 데이터 준비
    const postData = {
      post: {
        title: postForm.value.title,
        content: postForm.value.content,
        published: true,
        category_ids: postForm.value.category_ids,
        tag_ids: postForm.value.tag_ids
      }
    };
    
    // API 요청
    axios({
      method: 'put',
      url: `${API_URL}/posts/${postId.value}`,
      data: postData
    })
    .then(() => {
      router.push(`/${username.value}/posts/${postId.value}`);
    })
    .catch(err => {
      console.error('게시물 수정 오류:', err);
      error.value = err.response?.data?.error || '게시물 수정에 실패했습니다';
      isSubmitting.value = false;
    });
  };
  
  onMounted(() => {
    fetchPost();
  });
  </script>
  
  <style scoped>
  @media (max-width: 576px) {
    .form-check {
      width: 50%;
      margin-bottom: 0.5rem;
    }
  }
  </style>