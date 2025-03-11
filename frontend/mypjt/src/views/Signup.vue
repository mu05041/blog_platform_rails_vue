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
  
        <button type="submit">Sign Up</button>
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

// Stores and routing
const authStore = useAuthStore()
const router = useRouter()

// Signup method
async function signUp() {
  // Reset previous error
  errorMessage.value = ''

  // Basic validation
  if (!username.value || !email.value || !password.value || !passwordConfirmation.value) {
    errorMessage.value = '모든 필드를 채워주세요.'
    return
  }

  if (password.value !== passwordConfirmation.value) {
    errorMessage.value = '비밀번호가 일치하지 않습니다.'
    return
  }

  try {
    // Call signup method from auth store
    await authStore.signup({
      username: username.value,
      email: email.value,
      password: password.value,
      passwordConfirmation: passwordConfirmation.value
    })

    // Redirect to home or login page after successful signup
    router.push({ name: 'Home' })
  } catch (error) {
    // Set error message from backend or default message
    errorMessage.value = error.response?.data?.errors?.[0] || '회원가입에 실패했습니다.'
  }
}
</script>