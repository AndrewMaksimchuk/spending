<template>
	<v-container>
		<v-data-table dense :headers="headers" :items="desserts"></v-data-table>
	</v-container>
</template>

<script>
export default {
	name: "Table",
	data() {
		return {
			headers: [
				{
					text: "Точка",
					value: "point",
				},
				{ text: "Кошти (грн)", value: "funds" },
				{ text: "Тип оплати", value: "paymentType" },
				{ text: "Дата", value: "date" },
				{ text: "Товар", value: "goods" },
				{ text: "Чек", value: "check" },
			],
			desserts: [
				{
					point: "АТБ",
					funds: 159.0,
					paymentType: "безнал",
					date: 1646854022259,
					goods: [],
					check: "",
				},
				{
					point: "АТБ",
					funds: 159.0,
					paymentType: "безнал",
					date: 1646854022259,
					goods: [],
					check: "",
				},
				{
					point: "АТБ",
					funds: 159.0,
					paymentType: "безнал",
					date: 1646854022259,
					goods: [],
					check: "",
				},
			],
		};
	},
};
</script>
