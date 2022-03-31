<template>
	<v-container class="white">
		<v-form>
			<v-row>
				<v-col cols="12" xs="12" sm="4">
					<v-combobox
						v-model="point"
						:items="points"
						label="Точка"
						placeholder="Сільпо"
					/>
				</v-col>
				<v-col cols="12" xs="12" sm="4">
					<v-text-field
						v-model="money"
						label="Кошти"
						placeholder="100.00"
						type="text"
						inputmode="decimal"
						prefix="₴"
						clearable
					/>
				</v-col>
				<v-col cols="12" xs="12" sm="4">
					<v-select
						label="Тип оплати"
						v-model="selectedPaymentType"
						:items="paymentType"
					></v-select>
				</v-col>
			</v-row>
			<v-row>
				<v-col>
					<v-file-input
						v-model="check"
						accept="image/*"
						label="Прикріпити фото чека"
					></v-file-input>
				</v-col>
			</v-row>
			<v-row>
				<v-col class="d-flex gap justify-space-between flex-wrap">
					<h2>Куплені товари</h2>
					<v-btn depressed color="primary" @click="addGoods"
						>Додати одиницю товару</v-btn
					>
				</v-col>
			</v-row>
			<v-row>
				<v-col>
					<v-divider />
					<small v-if="isGoodsExist" class="grey--text lighten-5"
						>Список куплених товарів пустий...</small
					>
					<component
						v-for="goodsComponent in goods"
						:key="goodsComponent.id"
						:is="goodsComponent.component"
						v-model="goodsComponent.data"
						@delete="deletedGoods(goodsComponent.id)"
					></component>
				</v-col>
			</v-row>
			<v-row>
				<v-col cols="12" xs="12" sm="6">
					<v-date-picker v-model="date" locale="uk-UA" full-width />
				</v-col>
				<v-col cols="12" xs="12" sm="6">
					<v-combobox
						v-model="dateFormatted"
						prepend-icon="mdi-calendar"
						label="Вибрана дата"
						full-width
					/>
				</v-col>
			</v-row>
			<v-row>
				<v-col cols="12" xs="12" sm="4">
					<v-btn
						large
						depressed
						width="100%"
						@click="save"
						color="success"
					>
						Зберегти
					</v-btn>
				</v-col>
				<v-col cols="12" xs="12" sm="4">
					<v-btn large depressed text width="100%" @click="clear">
						Очистити
					</v-btn>
				</v-col>
				<v-col cols="12" xs="12" sm="4">
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
		</v-form>
	</v-container>
</template>

<script>
import GoodsInput from "@/components/GoodsInput.vue";
import format from "date-fns/format";
import points from "@/const/points";
const today = format(Date.now(), "yyyy-M-d");

export default {
	name: "NewRecord",
	components: { GoodsInput },
	data() {
		return {
			point: "",
			points: [],
			money: null,
			selectedPaymentType: "безнал",
			paymentType: ["безнал", "нал"],
			check: null,
			goods: [],
			date: null,
			dateFormatted: null,
		};
	},
	created() {
		this.date = today;
		this.point = points[0];
		this.points = points;
	},
	watch: {
		date() {
			this.dateFormatted = this.formattedDate();
		},
	},
	computed: {
		isGoodsExist() {
			return !this.goods.length;
		},
	},
	methods: {
		formattedDate() {
			const [year, month, day] = this.date.split("-");
			return `${day}.${month}.${year}`;
		},
		addGoods() {
			this.goods.push({
				component: GoodsInput,
				id: Date.now(),
				data: {},
			});
		},
		deletedGoods(id) {
			this.goods = this.goods.filter((item) => item.id !== id);
		},
		getAllGoods() {
			return this.goods.map(({ data }) => {
				const { category, name, price, pieces } = data;
				return { category, name, price, pieces };
			});
		},
		save() {
			const { point, money, selectedPaymentType, check, dateFormatted } =
				this.$data;
			const goods = this.getAllGoods();
			console.log({
				point,
				money,
				selectedPaymentType,
				check,
				goods,
				dateFormatted,
			});
		},
		clear() {
			this.date = today;
			this.point = points[0];
			this.money = null;
			this.selectedPaymentType = "безнал";
			this.check = null;
			this.goods = [];
		},
		close() {
			this.$emit("close");
		},
	},
};
</script>
