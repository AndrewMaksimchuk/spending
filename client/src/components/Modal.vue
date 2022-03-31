<template>
	<v-dialog v-model="value" max-width="900px" v-on:click:outside="close">
		<component :is="component" @close="close"></component>
	</v-dialog>
</template>

<script>
import NewRecord from "@/components/NewRecord.vue";
import SaveRecords from "@/components/SaveRecords.vue";

export default {
	components: { NewRecord, SaveRecords },
	props: {
		value: {
			type: Boolean,
			require: true,
		},
		component: {
			type: String,
			require: true,
		},
	},
	methods: {
		close() {
			this.$emit("close");
		},
	},
};
</script>
