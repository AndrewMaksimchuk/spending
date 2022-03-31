<template>
	<v-app>
		<v-bottom-navigation dark>
			<v-btn
				class="btn"
				x-large
				v-for="(item, index) in menuButtons"
				:key="index"
				:value="item.label"
				@click="openModalWindow(item.componentName)"
			>
				<span>{{ item.label }}</span>
			</v-btn>
		</v-bottom-navigation>
		<v-main>
			<Chart :money="money" />
			<Table />
			<Modal
				v-model="dialog"
				@close="closeModalWindow"
				:component="component"
			/>
		</v-main>
	</v-app>
</template>

<script>
import Table from "@/components/Table.vue";
import Modal from "@/components/Modal.vue";
import Chart from "@/components/Chart.vue";

export default {
	name: "Dashboard",
	components: { Table, Modal, Chart },
	data() {
		return {
			dialog: false,
			menuButtons: [
				{ label: "Додати", componentName: "NewRecord" },
				{ label: "Зберегти", componentName: "SaveRecords" },
				{ label: "Очистити", componentName: "" },
			],
			component: "",
			money: [12, 19, 3, 5, 2, 3, 12, 19, 23, 145.25],
		};
	},
	methods: {
		openModalWindow(componentName) {
			if (componentName) {
				this.dialog = true;
				this.component = componentName;
			}
		},
		closeModalWindow() {
			this.component = "";
			this.dialog = false;
		},
	},
};
</script>

<style scoped>
.btn span {
	font-size: 1rem;
}
</style>
