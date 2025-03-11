<template>
    <div class="container py-4">
      <!-- 로딩 상태 -->
      <div v-if="isLoading" class="text-center py-5">
        <p class="mt-2">게시물을 불러오는 중입니다...</p>
      </div>
  
      <!-- 오류 메시지 -->
      <div v-else-if="error" class="alert alert-danger" role="alert">
        {{ error }}
      </div>
  
      <!-- 게시물 상세 내용 -->
      <div v-else-if="post" class="card shadow">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center mb-2">
            <RouterLink :to="`/blogs/${username}`" class="text-decoration-none">
              <i class="bi bi-arrow-left"></i> {{ username }}의 블로그로 돌아가기
            </RouterLink>
            <small class="text-muted">{{ formatDate(post.created_at) }}</small>
          </div>
          
          <h2 class="card-title blog-title mb-4">{{ post.title }}</h2>
          
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
          
          <hr />
          
          <div class="post-content my-4">
            <p style="white-space: pre-line;">{{ post.content }}</p>
          </div>
          
          <div v-if="post.updated_at && post.updated_at !== post.created_at" class="text-end mt-4">
            <small class="text-muted">마지막 수정: {{ formatDate(post.updated_at) }}</small>
          </div>
        </div>
      </div>
      
      <!-- 게시물 없음 -->
      <div v-else class="alert alert-warning" role="alert">
        게시물을 찾을 수 없습니다.
      </div>
    </div>
  </template>
  

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, RouterLink } from 'vue-router';
import axios from 'axios'
import { useAuthStore } from '@/stores/auth'

const isLoading = ref(true);
const error = ref(null);
const route = useRoute()
const authStore = useAuthStore()
const API_URL = 'http://localhost:3000/api/v1'
const post = ref(null);
const username = ref('');

// 게시물 상세 정보 가져오기
const getBlogPostDetail = () => {
  // URL 파라미터에서 사용자 이름과 게시물 ID 가져오기
  
  username.value = route.params.username
  const postId = route.params.id
  console.log('postId:', postId)
  console.log('Route params:', route.params)

  axios({
    method: 'get',
    url: `${API_URL}/blogs/${username.value}/posts/${postId}`
  })
  .then(res => {
    console.log('게시물 상세:', res.data)
    post.value = res.data
    isLoading.value = false
  })
  .catch(err => {
    console.log('게시물 상세 불러오기 오류:', err.response)
    error.value = '게시물을 불러오는 중 오류가 발생했습니다.'
    isLoading.value = false;
  });
};

// 날짜 포맷 함수
const formatDate = (dateString) => {
  const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
  return new Date(dateString).toLocaleDateString('ko-KR', options)
}

onMounted(() => {
  getBlogPostDetail();
})


</script>

<style lang="scss" scoped>

</style>