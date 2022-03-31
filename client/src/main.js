import Vue from "vue";
import App from "./App.vue";
import vuetify from "./plugins/vuetify";
import router from "@/router";
import store from "./store";
import axios from "axios";
import { VueMaskDirective } from "v-mask";

axios.defaults.withCredentials = true;
// axios.defaults.baseURL = ""

Vue.directive("mask", VueMaskDirective);
Vue.config.productionTip = false;

new Vue({
	vuetify,
	router,
	store,
	render: (h) => h(App),
}).$mount("#app");
