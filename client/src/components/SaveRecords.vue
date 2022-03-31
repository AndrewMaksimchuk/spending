<template>
	<v-container class="white save-records">
		<h2 class="pb-4">Зберегти дані в наступних форматах:</h2>
		<v-row>
			<v-col
				cols="12"
				xs="12"
				sm="4"
				v-for="btn in buttons"
				:key="btn.label"
			>
				<v-btn
					depressed
					elevation="1"
					width="100%"
					min-height="15vh"
					color="primary"
					v-bind="btn.attributes"
					v-on="btn.events"
					>{{ btn.label }}
				</v-btn>
			</v-col>
		</v-row>
		<v-row>
			<v-col>
				<v-btn
					large
					depressed
					text
					width="100%"
					@click="close"
					color="error"
				>
					Закрити
				</v-btn>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
export default {
	name: "SaveRecords",
	data() {
		return {
			buttons: [
				{
					label: "PDF",
					attributes: {},
					events: { click: this.toPdf },
				},
				{
					label: "EXEL",
					attributes: { disabled: true },
					events: { click: this.toExel },
				},
				{
					label: "CSV",
					attributes: { disabled: true },
					events: { click: this.toCsv },
				},
				{
					label: "JSON",
					attributes: { disabled: true },
					events: { click: this.toJson },
				},
			],
		};
	},
	methods: {
		toPdf() {
			console.log("to pdf");
		},
		toExel() {
			console.log("to exel");
		},
		toCsv() {
			console.log("to csv");
		},
		toJson() {
			console.log("to json");
		},
		close() {
			this.$emit("close");
		},
	},
};
</script>

<style scoped>
.save-records {
	max-width: 900px;
}
</style>
