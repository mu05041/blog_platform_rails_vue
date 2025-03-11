<template>
  <div class="login-container">
    <div class="card">
      <h1>Login</h1>
      <form @submit.prevent="logIn">
        <div class="form-group">
          <label for="email">Email</label>
          <input
            type="text"
            id="email"
            v-model="email"
            placeholder="Please put your email"
            required
          />
        </div>
        <div class="form-group">
          <label for="password">PassWord</label>
          <input
            type="password"
            id="password"
            v-model="password"
            placeholder="Please put password"
            required
          />
        </div>
        <button type="submit">login</button>
      </form>
      <div class="signup-section">
        <p>Are you not signed up yet?</p>
        <router-link to="/signup">Sign Up</router-link>
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
const router = useRouter()
const authStore = useAuthStore()

const logIn = () => {
  console.log('Login Success')  
  authStore.login(email.value, password.value)
    .then(() => router.push('/'))
    .catch(error => console.error('Login failed:', error))
}
</script>