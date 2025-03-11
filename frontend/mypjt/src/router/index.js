import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'
import SignupView from '@/views/SignupView.vue'
import UserBlogView from '@/views/UserBlogView.vue'
import UserBlogPostDetailView from '@/views/UserBlogPostDetailView.vue'
import BlogPostEditorView from '@/views/BlogPostEditorView.vue'

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


      // 내 블로그 관리 라우트 (인증 필요)
      {
        path: '/my/blog',
        name: 'MyBlog',
        component: UserBlogView,
        props: { isMyBlog: true },
        meta: { requiresAuth: true }
      },
      {
        path: '/my/blog/posts/new',
        name: 'NewBlogPost',
        component: BlogPostEditorView,
        meta: { requiresAuth: true }
      },
      {
        path: '/my/blog/posts/:id/edit',
        name: 'EditBlogPost',
        component: BlogPostEditorView, 
        props: route => ({ 
          id: route.params.id,
          isEditing: true 
        }),
        meta: { requiresAuth: true }
      },
      {
        path: '/my/blog/posts/:id',
        name: 'MyBlogPostDetail',
        component: UserBlogPostDetailView,
        props: route => ({ 
          id: route.params.id,
          isMyBlog: true 
        }),
        meta: { requiresAuth: true }
      },
    ],
  })


  

export default router
