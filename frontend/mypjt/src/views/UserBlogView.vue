<template>
    <div class="container py-4">
    <!-- 블로그 헤더 -->
    <div class="row mb-4">
      <div class="col-12">
        <h2 class="text-center fw-bold blog-title">{{ isMyBlog ? '내 블로그' : `${username}의 블로그` }}</h2>
        <p class="text-center text-muted">{{ isMyBlog ? '내 블로그 관리' : '공개 블로그 게시물 목록' }}</p>
        
        <!-- 내 블로그일 경우에만 보이는 글쓰기 버튼 -->
        <div v-if="isMyBlog" class="text-center mt-3">
          <RouterLink to="/my/blog/posts/new" class="btn btn-success">
            새 게시물 작성
          </RouterLink>
        </div>
      </div>
    </div>
  
      <!-- 로딩 상태 -->
      <div v-if="isLoading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">로딩 중...</span>
        </div>
        <p class="mt-2">게시물을 불러오는 중입니다...</p>
      </div>
  
      <!-- 오류 메시지 -->
      <div v-else-if="error" class="alert alert-danger" role="alert">
        {{ error }}
      </div>
  
      <!-- 게시물 없음 -->
      <div v-else-if="posts.length === 0" class="text-center py-5">
        <p>등록된 게시물이 없습니다.</p>
      </div>
  
      <!-- 블로그 게시물 목록 -->
      <div v-else class="row">
        <div v-for="post in posts" :key="post.id" class="col-md-6 mb-4">
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
                <RouterLink :to="`/blogs/${username}/posts/${post.id}`" class="btn btn-primary">
                  더 보기
                </RouterLink>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, RouterLink } from 'vue-router';
import axios from 'axios'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const authStore = useAuthStore()
const API_URL = 'http://localhost:3000/api/v1'
const posts = ref([]);
const username = ref('');
const isLoading = ref(true);
const error = ref('')

const props = defineProps({
  isMyBlog: {
    type: Boolean,
    default: false
  }
});

// 게시물 정보 가져오기
const getBlogPosts = () => {
    isLoading.value = true
    error.value = null
  
  // 내 블로그가 아닐 경우 URL 파라미터에서 사용자 이름 가져오기
  if (!props.isMyBlog) {
    username.value = route.params.username;
    console.log('Username from params:', username.value);
    
    // username이 비어있으면 오류 처리
    if (!username.value) {
      error.value = '사용자 이름이 지정되지 않았습니다.';
      isLoading.value = false;
      return;
    }
  }
  
  // API 엔드포인트 결정
  const endpoint = props.isMyBlog 
    ? `${API_URL}/my/blog/posts`
    : `${API_URL}/blogs/${username.value}/posts`;
  
  console.log('API 요청 URL:', endpoint);
  
  // 인증 헤더 설정 (내 블로그일 경우)
  const headers = props.isMyBlog 
    ? { Authorization: `Bearer ${authStore.token}` }
    : {};
  

  axios({
    method: 'get',
    url: endpoint,  
    headers
  })
  .then(res => {
    console.log(res.data)
    posts.value = res.data;
    isLoading.value = false;

  })
  .catch(err => {
    console.log('error:', err.response)
  })
}


// 날짜 포맷
const formatDate = (dateString) => {
  const options = { year: 'numeric', month: 'long', day: 'numeric' }
  return new Date(dateString).toLocaleDateString('ko-KR', options)
}

// 내용 요약
const createExcerpt = (content, maxLength = 100) => {
  if (!content) return ''
  if (content.length <= maxLength) return content
  return content.substring(0, maxLength) + '...'
}

onMounted(() => {
  getBlogPosts();
})



</script>

<style lang="scss" scoped>

</style>