<script setup>
import { RouterLink, RouterView } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { computed } from 'vue'

// Use the auth store
const authStore = useAuthStore()

// Computed property to check if user is logged in
const isLoggedIn = computed(() => authStore.user !== null)

// Logout handler
const handleLogout = () => {
  authStore.logout()
}

</script>

<template>
  <header class="py-3 mb-4 border-bottom shadow-sm">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-md-6 col-12 mb-md-0 mb-3 text-md-start text-center">
          <RouterLink to="/" class="text-decoration-none">
            <span class="fs-3 fw-bold blog-title">Blog</span>
          </RouterLink>
        </div>
        <!-- 여기가 수정된 부분: col-md-6 div 안에 조건부 렌더링을 넣음 -->
        <div class="col-md-6 col-12 text-md-end text-center">
          <template v-if="!isLoggedIn">
            <RouterLink to="/login" class="btn btn-outline-primary me-2">Log In</RouterLink>
            <RouterLink to="/signup" class="btn btn-primary">Sign Up</RouterLink>
          </template>
          <template v-else>
            <button @click="handleLogout" class="btn btn-outline-danger">Logout</button>
          </template>
        </div>
      </div>
    </div>
  </header>


  <main>
    <RouterView />
  </main>
</template>

<style scoped>
.blog-title {
  color: #0d6efd; /* Bootstrap primary blue */
}
</style>