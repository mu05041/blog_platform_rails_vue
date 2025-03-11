const authStore = useAuthStore();<template>
    <div class="container py-4">
      <!-- 오류 -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      
      <!-- 게시물 내용 -->
      <div v-else>
        <h1>{{ post.title }}</h1>
        
        <div class="text-muted mb-4">
          {{ formatDate(post.created_at) }}
        </div>
        
        <div class="post-content">
          {{ post.content }}
        </div>
        
        <!-- 내 블로그일 경우 편집/삭제 버튼 표시 -->
        <div v-if="isMyBlog" class="mt-4">
          <RouterLink :to="`/my/blog/posts/${post.id}/edit`" class="btn btn-primary me-2">
            수정
          </RouterLink>
          <button @click="deletePost" class="btn btn-danger">삭제</button>
        </div>
        
        <div class="mt-4">
          <RouterLink :to="isMyBlog ? '/my/blog' : `/blogs/${username}`" class="btn btn-secondary">
            목록으로
          </RouterLink>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useRoute, useRouter, RouterLink } from 'vue-router';
  import axios from 'axios';
  import { useAuthStore } from '@/stores/auth';
  
  const props = defineProps({
    isMyBlog: {
      type: Boolean,
      default: false
    },
    id: String
  });
  
  const API_URL = 'http://localhost:3000/api/v1';
  const route = useRoute();
  const router = useRouter();
  
  const post = ref({});
  const error = ref(null);
  const username = ref('');
  
  // 게시물 로드
  function fetchPost() {
    const postId = props.id || route.params.id;
    username.value = route.params.username;
    
    const endpoint = props.isMyBlog
      ? `${API_URL}/my/blog/posts/${postId}`
      : `${API_URL}/blogs/${username.value}/posts/${postId}`;
    
    // 세션 인증 방식에서는 쿠키가 자동으로 전송되므로 별도의 헤더가 필요 없음
    const headers = {};
    
    axios.get(endpoint, { headers })
      .then(response => {
        post.value = response.data;
      })
      .catch(err => {
        console.error('에러:', err);
        error.value = '게시물을 불러오는데 실패했습니다.';
      });
  }
  
  // 게시물 삭제
  function deletePost() {
    if (!confirm('정말 이 게시물을 삭제하시겠습니까?')) return;
    
    // 세션 인증에서는 쿠키가 자동으로 전송됨
    axios.delete(`${API_URL}/my/blog/posts/${post.value.id}`)
      .then(() => {
        router.push('/my/blog');
      })
      .catch(err => {
        console.error('삭제 오류:', err);
        alert('게시물 삭제에 실패했습니다.');
      });
  }
  
  // 날짜 포맷
  function formatDate(dateString) {
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('ko-KR', options);
  }
  
  onMounted(fetchPost);
  </script>