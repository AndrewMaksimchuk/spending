import Vue from "vue";
import Vuetify from "vuetify"; // loads all components
import "vuetify/dist/vuetify.min.css"; // all the css for components
import uk from "vuetify/es5/locale/uk";

Vue.use(Vuetify);

export default new Vuetify({
	lang: {
		locales: { uk },
		current: "uk",
	},
});
