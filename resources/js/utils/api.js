// resources/js/utils/api.js
import axios from 'axios';

const api = axios.create({
  baseURL: '/api',
  headers: {
    Accept: 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('api_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export function setToken(token) {
  localStorage.setItem('api_token', token);
  api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
}

export function clearToken() {
  localStorage.removeItem('api_token');
  delete api.defaults.headers.common['Authorization'];
}

export default api;
