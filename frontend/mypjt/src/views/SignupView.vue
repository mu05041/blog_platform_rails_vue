<template>
  <div>
    <h2>Sign Up</h2>
    <form @submit.prevent="signUp">
      <div>
        <label for="username">User Name</label>
        <input
           id="username"
           v-model="username"
           type="text"
           required
           placeholder="Put your name"
        >
      </div>
       
      <div>
        <label for="email">Email</label>
        <input
           id="email"
           v-model="email"
           type="email"
           required
           placeholder="Put your Email"
        >
      </div>
       
      <div>
        <label for="password">PassWord</label>
        <input
           id="password"
           v-model="password"
           type="password"
           required
           placeholder="Put PassWord"
        >
      </div>
       
      <div>
        <label for="password-confirmation">Confirm PassWord</label>
        <input
           id="password-confirmation"
           v-model="passwordConfirmation"
           type="password"
           required
           placeholder="비밀번호를 다시 입력하세요"
        >
      </div>
       
      <!-- Error Message -->
      <div v-if="errorMessage" style="color: red;">
        {{ errorMessage }}
      </div>
       
      <button type="submit" :disabled="isLoading">
        {{ isLoading ? '처리 중...' : 'Sign Up' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

// Form data refs
const username = ref('')
const email = ref('')
const password = ref('')
const passwordConfirmation = ref('')

// Error handling
const errorMessage = ref('')
const isLoading = ref(false)

// Stores and routing
const authStore = useAuthStore()
const router = useRouter()

// Signup method
function signUp() {
  // Reset previous error
  errorMessage.value = ''
  
  // Basic validation
  if (!username.value || !email.value || !password.value || !passwordConfirmation.value) {
    errorMessage.value = 'fill all field.'
    return
  }
 
  if (password.value !== passwordConfirmation.value) {
    errorMessage.value = 'Not match password'
    return
  }
 
  isLoading.value = true
  
  // Promise 방식으로 구현
  authStore.signup({
    username: username.value,
    email: email.value,
    password: password.value,
    passwordConfirmation: passwordConfirmation.value
  })
  .then(() => {
    console.log('signup success')
    router.push({ name:'UserPosts', params:{username: authStore.user.username} })
  })
  .catch(error => {
    console.error('회원가입 오류:', error)
    
    // 에러 메시지 처리
    if (error.response && error.response.data) {
      errorMessage.value = error.response.data.errors?.[0] || 'Sign Up failed.'
    } else {
      errorMessage.value = '회원가입 처리 중 오류가 발생했습니다.'
    }
  })
  .finally(() => {
    isLoading.value = false
  })
}
</script>