<template>
  <div class="container py-4">
    <h2 class="text-center mb-4">새 게시물 작성</h2>
    
    <!-- 오류 메시지 -->
    <div v-if="error" class="alert alert-danger">{{ error }}</div>

    <!-- 게시물 작성 폼 -->
    <div class="row">
      <div class="col-lg-8 col-md-10 mx-auto">
        <form @submit.prevent="createPost">
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
            <RouterLink :to="`/${username}/posts`" class="btn btn-secondary">
              취소
            </RouterLink>
            <button type="submit" class="btn btn-primary" :disabled="isSubmitting">
              <span v-if="isSubmitting" class="spinner-border spinner-border-sm me-1"></span>
              등록
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

// 사용자 이름
const username = ref(authStore.user?.username || '');

// 게시물 폼 데이터
const postForm = ref({
  title: '',
  content: '',
  category_ids: [],
  tags: []
});

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

// 상태 관리
const isSubmitting = ref(false);
const error = ref('');

// store에서 카테고리 가져오기
import { useBlogStore } from '@/stores/blog';
const blogStore = useBlogStore();
const categories = computed(() => blogStore.categories);
const tags = computed(() => blogStore.tags);


// 게시물 생성 요청
const createPost = () => {
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
  
  // API 요청
  axios.post(`${API_URL}/posts`, postData)
    .then(() => {
      router.push(`/${username.value}/posts`);
    })
    .catch(err => {
      console.error('게시물 등록 오류:', err);
      error.value = err.response?.data?.error || '게시물 등록에 실패했습니다';
      isSubmitting.value = false;
    });
};

onMounted(() => {
  // 카테고리는 이미 로컬에 정의되어 있음
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