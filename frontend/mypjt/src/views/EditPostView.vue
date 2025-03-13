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

          <!-- 해시태그 입력 영역 -->
          <div class="mb-3">
            <label class="form-label">해시태그</label>
            <div class="d-flex align-items-center mb-2">
              <input 
                type="text" 
                class="form-control me-2" 
                v-model="newTag" 
                @keyup.enter="addTag"
                placeholder="해시태그 입력 (엔터로 추가)"
              >
              <button type="button" class="btn btn-primary" @click="addTag">
                추가
              </button>
            </div>
            
            <!-- 태그 목록 -->
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
    tags: [],
  });
  
  // 상태 관리
  const isLoading = ref(true);
  const isSubmitting = ref(false);
  const error = ref('');
  
  // store에서 카테고리 가져오기
  import { useBlogStore } from '@/stores/blog';
  const blogStore = useBlogStore();
  const categories = computed(() => blogStore.categories);

    // 새 태그 입력
  const newTag = ref('');

  // 태그 추가 메서드
  const addTag = () => {
    if (newTag.value.trim()) {
      // 중복 태그 방지 및 공백 제거
      const cleanedTag = newTag.value.trim().replace(/^#/, '');
      
      // 이미 존재하지 않는 태그만 추가
      if (!postForm.value.tags.includes(cleanedTag)) {
        postForm.value.tags.push(cleanedTag);
        newTag.value = ''; // 입력 필드 초기화
      }
    }
  };

  // 태그 제거 메서드
  const removeTag = (index) => {
    postForm.value.tags.splice(index, 1);
  };
  
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
        postForm.value.tags = post.tags.map(tag => tag.name);
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

    // 본문에서 해시태그 제거
    const contentWithoutTags = postForm.value.content.replace(/\s*#\w+/g, '').trim();
    
    // 본문에서 추출된 태그들
    const extractedTags = postForm.value.content.match(/#\w+/g)?.map(tag => tag.replace('#', '')) || [];
    
    // 태그 입력 필드의 태그와 본문 해시태그 병합 (중복 제거)
    const allTags = [...new Set([...postForm.value.tags, ...extractedTags])];

    
    // 게시물 데이터 준비
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