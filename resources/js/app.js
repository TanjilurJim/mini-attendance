import '../css/app.css';
import { createApp } from 'vue';
import router from './router';
import App from './App.vue';
import { setToken } from './utils/api';
import Toast from 'vue-toastification';
import 'vue-toastification/dist/index.css';
import Swal from 'sweetalert2';

// Preload token if exists
const savedToken = localStorage.getItem('api_token');
if (savedToken) {
  setToken(savedToken);
}

const app = createApp(App);

app.use(router);
app.use(Toast, {
  position: 'top-right',
  timeout: 3000,
  closeButton: false,
  hideProgressBar: false,
  pauseOnHover: true,
  draggable: true,
});

// Make SweetAlert2 globally available
app.config.globalProperties.$swal = Swal;

app.mount('#app');