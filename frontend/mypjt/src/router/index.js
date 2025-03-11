import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'
import SignupView from '@/views/SignupView.vue'
import UserPostsView from '@/views/UserPostsView.vue'
import PostDetailView from '@/views/PostDetailView.vue'
import CreatePostView from '@/views/CreatePostView.vue'
import EditPostView from '@/views/EditPostView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    // 인증 관련련
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

    // 블로그 관련 라우트
    {
      path: '/:username/posts',
      name: 'UserPosts',
      component: UserPostsView
    },
    {
      path: '/:username/posts/:id',
      name: 'PostDetail',
      component: PostDetailView
    },
    {
      path: '/posts/create',
      name: 'CreatePost',
      component: CreatePostView,
      meta: { requiresAuth: true }
    },
    {
      path: '/posts/:id/edit',
      name: 'EditPost',
      component: EditPostView,
      meta: { requiresAuth: true }
    }

    ],
  })


  

export default router
