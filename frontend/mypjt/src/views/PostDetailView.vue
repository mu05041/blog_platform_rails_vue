<template>
    <div class="container py-4">
      <!-- 오류 -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      
      <!-- 로딩 상태 -->
      <div v-if="isLoading && !error" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">로딩 중...</span>
        </div>
        <p class="mt-2">게시물을 불러오는 중입니다...</p>
      </div>
      
      <!-- 게시물 내용 -->
      <div v-else-if="post.id" class="row">
        <div class="col-lg-10 col-md-12 mx-auto">
          <h1 class="mb-3">{{ post.title }}</h1>
          
          <div class="text-muted mb-4">
            {{ formatDate(post.created_at) }}
          </div>
          
          <!-- 카테고리 및 태그 -->
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
          
          <!-- 내 블로그일 경우 편집/삭제 버튼 표시 -->
          <div v-if="isMyBlog" class="mt-4">
            <RouterLink :to="`/posts/${post.id}/edit`" class="btn btn-primary me-2">
              수정
            </RouterLink>
            <button @click="deletePost" class="btn btn-danger">삭제</button>
          </div>
          
          <div class="mt-4">
            <RouterLink :to="`/${username}/posts`" class="btn btn-secondary">
              목록으로
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
  
  // URL에서 username과 id 가져오기
  const username = ref(route.params.username || '');
  const postId = ref(route.params.id || '');
  
  // 내 블로그인지 확인
  const isMyBlog = ref(false);
  
  // 로그인 상태 확인 후 내 블로그 여부 설정
  if (authStore.user && username.value === authStore.user.username) {
    isMyBlog.value = true;
  }
  
  // 게시물 로드
  const fetchPost = () => {
    isLoading.value = true;
    error.value = '';
    
    // API 엔드포인트 설정
    const endpoint = `${API_URL}/${username.value}/posts/${postId.value}`;
    
    // 세션 기반 인증이므로 별도 헤더 불필요
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
      error.value = err.response?.data?.error || '게시물을 불러오는 중 오류가 발생했습니다.';
      isLoading.value = false;
    });
  }
  
  // 게시물 삭제
  const deletePost = () => {
    if (!confirm('정말 이 게시물을 삭제하시겠습니까?')) return;
    
    axios.delete(`${API_URL}/posts/${post.value.id}`)
      .then(() => {
        router.push(`/${username.value}/posts`);
      })
      .catch(err => {
        console.error('삭제 오류:', err);
        alert('게시물 삭제에 실패했습니다.');
      });
  }
  
  // 날짜 포맷
  const formatDate = (dateString) => {
    if (!dateString) return '';
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('ko-KR', options);
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
  
  /* 모바일 반응형 스타일 */
  @media (max-width: 576px) {
    h1 {
      font-size: 1.8rem;
    }
    
    .post-content {
      font-size: 1rem;
    }
  }
  </style>