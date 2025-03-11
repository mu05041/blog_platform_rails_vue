<script setup>
// 홈 페이지에 필요한 imports
</script>

<template>
  <main class="container">
    <div class="welcome-message">
      <h1><span class="blue-dot"></span> Welcome to Blog <span class="blue-dot"></span></h1>
      <p>A simple blog template with minimal design and blue accent points.</p>
    </div>
  </main>
</template>

<style scoped>
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

main {
  padding: 40px 0;
  min-height: 80vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.welcome-message {
  text-align: center;
}

.welcome-message h1 {
  color: #0066cc;
  margin-bottom: 20px;
  font-size: 36px;
}

.welcome-message p {
  font-size: 18px;
  color: #555;
  max-width: 600px;
  margin: 0 auto;
}

.blue-dot {
  width: 8px;
  height: 8px;
  background-color: #0066cc;
  border-radius: 50%;
  display: inline-block;
  margin: 0 10px;
}
</style>