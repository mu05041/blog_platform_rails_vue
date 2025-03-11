import { ref } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
import { useRouter } from 'vue-router'

export const useAuthStore = defineStore('auth', () => {
  const API_URL = 'http://localhost:3000/api/v1'
  const user = ref(null)
  const router = useRouter()

  const login = function (email, password) {
    return axios({
      method: 'post',
      url: `${API_URL}/login`,
      data: { email, password }
    })
    .then(res => {
      user.value = res.data.user
      return res.data
    })
  }

  const logout = function () {
    axios({
      method: 'delete',
      url: `${API_URL}/logout`
    })
    .then(res => {
      console.log(res.data)
      user.value = null
      router.push({ name: 'Home' })
    })
    .catch(err => console.log(err))
  }

  const signup = function (userData) {
    return axios({
      method: 'post',
      url: `${API_URL}/signup`,
      data: { 
        user: {
          username: userData.username,
          email: userData.email,
          password: userData.password,
          password_confirmation: userData.passwordConfirmation
        }
      }
    })
    .then(res => {
      user.value = res.data.user
      return res.data
    })
  }

  return { 
    user, 
    login, 
    logout, 
    signup 
  }
})