<template>
	<!-- Категорія \ Назва \ Ціна \ Обєм/Вага/Кілкьість -->
	<v-row class="d-flex flex-wrap">
		<v-col cols="12" xs="12" sm="3">
			<v-select
				label="Категорія"
				v-model="value.category"
				:items="categories"
			>
			</v-select>
		</v-col>
		<v-col cols="12" xs="12" sm="3">
			<v-text-field
				v-model="value.name"
				label="Назва"
				placeholder="Апельсин"
				type="text"
				clearable
			/>
		</v-col>
		<v-col cols="12" xs="12" sm="2">
			<v-text-field
				v-model="value.price"
				label="Ціна"
				placeholder="100.00"
				prefix="₴"
				clearable
			/>
		</v-col>
		<v-col cols="12" xs="12" sm="3">
			<v-text-field
				v-model="value.pieces"
				label="Кількість/Вага/Обєм"
				placeholder="10 шт."
				type="text"
				clearable
			/>
		</v-col>
		<v-col  cols="12" xs="12" sm="1">
			<v-btn fab icon @click="deleted">
				<v-icon color="red"> mdi-minus-circle </v-icon>
			</v-btn>
		</v-col>
	</v-row>
</template>

<script>
import goodsCategories from "@/const/goodsCategories";

export default {
	name: "GoodsInput",
	props: {
		value: {
			type: Object,
			required: true,
		},
	},
	data() {
		return {
			categories: [],
		};
	},
	created() {
		this.categories = goodsCategories;
		this.value.category = goodsCategories[0];
	},
	methods: {
		deleted() {
			this.$emit("delete");
		},
	},
};
</script>
