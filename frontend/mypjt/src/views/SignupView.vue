<template>
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-md-6 col-lg-5 col-sm-10">
        <div class="card shadow-sm">
          <div class="card-body p-4">
            <h2 class="text-center mb-4 text-primary">Sign Up</h2>
            <form @submit.prevent="signUp">
              <div class="mb-3">
                <label for="username" class="form-label">User Name</label>
                <input
                  type="text"
                  class="form-control"
                  id="username"
                  v-model="username"
                  placeholder="ユーザー名を入力してください"
                  required
                />
              </div>
              
              <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input
                  type="email"
                  class="form-control"
                  id="email"
                  v-model="email"
                  placeholder="メールアドレスを入力してください"
                  aria-describedby="emailHelp"
                  required
                />
              </div>
              
              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input
                  type="password"
                  class="form-control"
                  id="password"
                  v-model="password"
                  placeholder="パスワードを入力してください"
                  required
                />
              </div>
              
              <div class="mb-3">
                <label for="password-confirmation" class="form-label">Confirm Password</label>
                <input
                  type="password"
                  class="form-control"
                  id="password-confirmation"
                  v-model="passwordConfirmation"
                  placeholder="パスワードをもう一度入力してください"
                  required
                />
              </div>
              
              <!-- Error Message -->
              <div v-if="errorMessage" class="alert alert-danger mb-3">
                {{ errorMessage }}
              </div>
              
              <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary py-2" :disabled="isLoading">
                  {{ isLoading ? 'Processing...' : 'Sign Up' }}
                </button>
              </div>
            </form>
            <div class="login-section text-center mt-4">
              <p class="mb-1">Already have an account?</p>
              <router-link to="/login" class="btn btn-outline-primary btn-sm">Login</router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
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
    errorMessage.value = 'Please fill all fields.'
    return
  }
  
  if (password.value !== passwordConfirmation.value) {
    errorMessage.value = 'Passwords do not match'
    return
  }
  
  isLoading.value = true
  
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
    console.error('Sign Up Error:', error)
    
    // Error message handling
    if (error.response && error.response.data) {
      errorMessage.value = error.response.data.errors?.[0] || 'Sign Up failed.'
    } else {
      errorMessage.value = 'An error occurred during sign up process.'
    }
  })
  .finally(() => {
    isLoading.value = false
  })
}
</script>

<style scoped>
.card {
  border-radius: 10px;
  border: none;
}

/* mobile */
@media (max-width: 576px) {
  .card {
    border-radius: 8px;
  }
  
  .card-body {
    padding: 1.5rem;
  }
}
</style>