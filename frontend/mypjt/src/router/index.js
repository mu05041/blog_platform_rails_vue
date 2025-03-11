import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'
import SignupView from '@/views/SignupView.vue'
import UserBlogView from '@/views/UserBlogView.vue'
import UserBlogPostDetailView from '@/views/UserBlogPostDetailView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: HomeView,
    },
    {
      path: '/login',
      name: 'Login',
      component: LoginView
    },
    {
      path: '/signup',
      name: 'Signup',
      component: SignupView
    },

    // 공개블로그 접근 라우트
    {
      path: '/blogs/:username',
      name: 'UserBlog',
      component: UserBlogView
    },
    {
      path: '/blogs/:username/posts/:id',
      name: 'UserBlogPostDetail',
      component: UserBlogPostDetailView
    },


    
  ],
})

export default router
