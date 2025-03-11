import { defineStore } from 'pinia';

export const useBlogStore = defineStore('blog', {
  state: () => ({
    categories: [
      { id: 1, name: 'Travel' },
      { id: 2, name: 'Food' },
      { id: 3, name: 'Lifestyle' },
      { id: 4, name: 'Technology' },
      { id: 5, name: 'Sports' },
      { id: 6, name: 'Music' }
    ],
    tags: [
      { id: 1, name: 'Sunny' },
      { id: 2, name: 'Cloudy' },
      { id: 3, name: 'Rainy' },
      { id: 4, name: 'Snowy' },
      { id: 5, name: 'Windy' },
      { id: 6, name: 'Stormy' }
    ]
  }),
  
  getters: {
    getCategoryById: (state) => (id) => {
      return state.categories.find(category => category.id === id);
    },
    getTagById: (state) => (id) => {
      return state.tags.find(tag => tag.id === id);
    },
    getCategoryName: (state) => (id) => {
      const category = state.categories.find(category => category.id === id);
      return category ? category.name : '';
    },
    getTagName: (state) => (id) => {
      const tag = state.tags.find(tag => tag.id === id);
      return tag ? tag.name : '';
    }
  },
  
  actions: {
    // 추후 API에서 카테고리와 태그를 가져오는 기능을 구현할 수 있음
    fetchCategoriesAndTags() {
      // API 호출 예시
      // axios.get('/api/categories').then(res => { this.categories = res.data });
      // axios.get('/api/tags').then(res => { this.tags = res.data });
    }
  }
});