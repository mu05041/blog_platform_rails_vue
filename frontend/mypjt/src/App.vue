<script setup>
import { RouterLink, RouterView } from 'vue-router'
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
        <div class="col-md-6 col-12 text-md-end text-center">
          <RouterLink to="/login" class="btn btn-outline-primary me-2">Log In</RouterLink>
          <RouterLink to="/signup" class="btn btn-primary">Sign Up</RouterLink>
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