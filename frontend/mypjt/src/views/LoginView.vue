<template>
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-md-6 col-lg-5 col-sm-10">
        <div class="card shadow-sm">
          <div class="card-body p-4">
            <h2 class="text-center mb-4 text-primary">Login</h2>
            <form @submit.prevent="logIn">
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
              
              <div v-if="errorMessage" class="alert alert-danger mb-3">
                {{ errorMessage }}
              </div>


              <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary py-2">Login</button>
              </div>
            </form>
            <div class="signup-section text-center mt-4">
              <p class="mb-1">まだ会員登録がお済みでしょうか？</p>
              <router-link to="/signup" class="btn btn-outline-primary btn-sm">Sign Up</router-link>
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

const email = ref('')
const password = ref('')
const errorMessage = ref('')
const router = useRouter()
const authStore = useAuthStore()

const logIn = () => {
  console.log('Login Success')  
  authStore.login(email.value, password.value)
    .then(() => router.push({ name:'UserPosts', params:{username: authStore.user.username}}))
    .catch(error =>{
      if (error.response && error.response.data && error.response.data.error) {
        errorMessage.value = error.response.data.error
      } else if (error.message) {
        errorMessage.value = error.message
      } else {
        errorMessage.value = 'メールアドレスまたはパスワードが一致しません'
      }

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
