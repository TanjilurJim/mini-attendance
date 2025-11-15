import '../css/app.css';
import { createApp } from 'vue';
import router from './router';
import App from './App.vue';
import { setToken } from './utils/api';

// Preload token if exists
const savedToken = localStorage.getItem('api_token');
if (savedToken) {
  setToken(savedToken);
}

const app = createApp(App);

app.use(router);

app.mount('#app');