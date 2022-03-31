import axios from "axios";
const state = {
	user: null,
};
const getters = {
    isAuthenticated: state => !!state.user,    
    StateUser: state => state.user,
};
const actions = {
	async Register({ dispatch }, form) {
		await axios.post("register", form);
		let UserForm = new FormData();
		UserForm.append("username", form.username);
		UserForm.append("password", form.password);
		await dispatch("LogIn", UserForm);
	},
	async LogIn({ commit }, User) {
		await axios.post("login", User);
		await commit("setUser", User.get("username"));
	},
	async LogOut({ commit }) {
		let user = null;
		commit("logout", user);
	},
};
const mutations = {
	setUser(state, username) {
		state.user = username;
	},

	LogOut(state) {
		state.user = null;
		state.posts = null;
	},
};
export default {
	state,
	getters,
	actions,
	mutations,
};
