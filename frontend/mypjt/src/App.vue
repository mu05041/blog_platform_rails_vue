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
  <nav class="navbar navbar-expand-md navbar-light bg-white shadow-sm py-2 mb-4 border-bottom">
    <div class="container">
      <!-- ロゴ -->
      <RouterLink to="/" class="navbar-brand">
        <span class="fs-3 fw-bold blog-title">Blog</span>
      </RouterLink>
      
      <!-- ハンバーガーボタン (モバイルでのみ表示)  -->
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
              data-bs-target="#navbarNav" aria-controls="navbarNav" 
              aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      
      <!-- メニューアイテム (モバイルでは折りたたまれ、mdサイズ以上では展開される)  -->
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <template v-if="!isLoggedIn">
            <li class="nav-item">
              <RouterLink to="/login" class="nav-link btn btn-outline-primary me-md-2 mb-2 mb-md-0">
                Log In
              </RouterLink>
            </li>
            <li class="nav-item">
              <RouterLink to="/signup" class="nav-link btn btn-primary">
                Sign Up
              </RouterLink>
            </li>
          </template>
          <template v-else>
            <li class="nav-item">
              <button @click="handleLogout" class="nav-link btn btn-outline-danger">
                Logout
              </button>
            </li>
          </template>
        </ul>
      </div>
    </div>
  </nav>

  <main>
    <RouterView />
  </main>
</template>

<style scoped>
.blog-title {
  color: #0d6efd; /* Bootstrap primary blue */
}
</style>