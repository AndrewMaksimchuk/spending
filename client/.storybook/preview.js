import { addDecorator } from "@storybook/vue";
import vuetify from "./vuetify_storybook";

addDecorator(() => ({
	vuetify,
	template: `
     <v-app>
     <v-main>
         <v-container>
         <story/>
         </v-container>
     </v-main>
     </v-app>
     `,
}));

// export const parameters = {
// 	actions: { argTypesRegex: "^on[A-Z].*" },
// 	controls: {
// 		matchers: {
// 			color: /(background|color)$/i,
// 			date: /Date$/,
// 		},
// 	},
// };
