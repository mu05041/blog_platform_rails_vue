<template>
  <div class="container py-4">
    <!-- 블로그 헤더 -->
    <div class="row mb-4">
      <div class="col-12">
        <h2 class="text-center fw-bold blog-title">{{ `${username}의 블로그` }}</h2>
        <p class="text-center text-muted">{{ isMyBlog ? '내 블로그 관리' : '공개 블로그 게시물 목록' }}</p>
        
        <!-- 내 블로그일 경우에만 보이는 글쓰기 버튼 -->
        <div v-if="isMyBlog" class="text-center mt-3">
          <RouterLink to="/posts/create" class="btn btn-success">
            새 게시물 작성
          </RouterLink>
        </div>
      </div>
    </div>

      <!-- 검색 및 필터링 UI -->
        <div class="row mb-4">
      <div class="col-md-6 mb-3 mb-md-0">
        <div class="input-group">
          <input 
            type="text" 
            class="form-control" 
            placeholder="게시물 검색..." 
            v-model="searchQuery"
            @input="filterPosts"
          >
          <button class="btn btn-outline-secondary" type="button" @click="filterPosts">
            <i class="bi bi-search"></i> 검색
          </button>
        </div>
      </div>
      <div class="col-md-6">
        <select class="form-select" v-model="selectedCategory" @change="filterPosts">
          <option value="">모든 카테고리</option>
          <option v-for="category in categories" :key="category.id" :value="category.id">
            {{ category.name }}
          </option>
        </select>
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
import { ref, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import axios from 'axios';
import { useAuthStore } from '@/stores/auth';

const route = useRoute();
const authStore = useAuthStore();
const API_URL = 'http://localhost:3000/api/v1';
// 세션 쿠키로 인증을 관리하므로 axios 요청 시 credentials 포함
axios.defaults.withCredentials = true;
const posts = ref([]);
const isLoading = ref(true);
const error = ref('');

// URL에서 username 가져오기
const username = ref(route.params.username || '');

// 내 블로그인지 확인
const isMyBlog = ref(false);

// 로그인 상태 확인 후 내 블로그 여부 설정
if (authStore.user && username.value === authStore.user.username) {
  isMyBlog.value = true;
}

// store에서 카테고리 가져오기
import { useBlogStore } from '@/stores/blog';
const blogStore = useBlogStore();
const categories = computed(() => blogStore.categories);
const tags = computed(() => blogStore.tags);

// 필터링 및 검색 상태
const selectedCategory = ref('');
const searchQuery = ref('')

// 필터링 여부 확인
const isFiltering = computed(() => {
  return selectedCategory.value !== ''
});

// 필터링 적용
const filterPosts = () => {
  console.log('필터링 적용: 카테고리:', selectedCategory.value);
};


// 필터링된 게시물 목록
const filteredPosts = computed(() => {
  return posts.value.filter(post => {
    
    // 검색어 필터링 (제목과 내용에서 검색)
    const searchMatch = searchQuery.value === '' || 
    post.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    post.content.toLowerCase().includes(searchQuery.value.toLowerCase());


    // 카테고리 필터 확인
    const categoryMatch = selectedCategory.value === '' || 
      (post.categories && post.categories.some(cat => cat.id === selectedCategory.value));
    
    // 두 조건 모두 만족해야 함
    return searchMatch && categoryMatch;
  });
});

// 카테고리 설정
const setCategory = (categoryId) => {
  selectedCategory.value = categoryId;
  console.log("selectedCategory =", selectedCategory)
};

// 필터 초기화
const resetFilters = () => {
  selectedCategory.value = ''
};


// 게시물 정보 가져오기
const getBlogPosts = () => {
  isLoading.value = true;
  error.value = '';
  
  // API 엔드포인트 설정
  const endpoint = `${API_URL}/${username.value}/posts`;
  
  // 세션 기반 인증이므로 별도 헤더 불필요
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
    error.value = err.response?.data?.error || '게시물을 불러오는 중 오류가 발생했습니다.';
    isLoading.value = false;
  });
};

// 날짜 포맷
const formatDate = (dateString) => {
  if (!dateString) return '';
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('ko-KR', options);
};

// 내용 요약
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
/* Bootstrap이 포함되어 있으므로 필요한 스타일만 추가 */
.blog-title {
  color: #333;
}

.card {
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
}

/* 모바일 반응형 스타일 */
@media (max-width: 576px) {
  .card {
    margin-bottom: 1rem;
  }
}
</style>