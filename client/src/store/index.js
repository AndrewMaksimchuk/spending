import Vue from "vue";
import Vuex from "vuex";
import auth from './modules/auth';

Vue.use(Vuex);

const vuexConfig = {
	modules: {
		auth,
	},
};

export default new Vuex.Store(vuexConfig);
