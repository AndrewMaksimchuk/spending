import AddNewRecord from "../components/AddNewRecord.vue";

export default {
	title: "Modal/AddNewRecord",
	component: AddNewRecord,
	argTypes: {
		selectedPoint: {
			options: ["АТБ", "ЕКО"],
			control: { type: "select" },
		},
		selectedPaymentType: {
			options: ["безнал", "нал"],
			control: { type: "select" },
		},
		date: {
			control: "date",
		},
	},
};

const Template = (args, { argTypes }) => ({
	props: Object.keys(argTypes),
	components: { AddNewRecord },
	template: "<add-new-record />",
});

export const Default = Template.bind({});
// Default.args = {
// 	selectedPoint: "АТБ",
// 	moneyValue: 230.00,
// 	selectedPaymentType: "безнал",
// 	date: 1647020076005,
// };
