import Chart from "../components/Chart.vue";

export default {
	title: "Chart",
	component: Chart,
};

const Template = (args, { argTypes }) => ({
	props: Object.keys(argTypes),
	components: { Chart },
	template: '<chart v-bind="$props" />',
});

const money = Array(31)
	.fill(0)
	.map(() => (Math.random() * 1000).toFixed(2));

export const Default = Template.bind({});
Default.args = {
	money,
};
