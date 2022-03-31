<template>
	<v-container>
		<canvas ref="canvas"></canvas>
	</v-container>
</template>

<script>
import Chart from "chart.js/auto";
import getMonth from "date-fns/getMonth";
import getDaysInMonth from "date-fns/getDaysInMonth";

const months = [
	"Січень",
	"Лютий",
	"Березень",
	"Квітень",
	"Травень",
	"Червень",
	"Липень",
	"Серпень",
	"Вересень",
	"Жовтень",
	"Листопад",
	"Грудень",
];
const currentDate = Date.now();
const currentMonth = getMonth(currentDate);

export default {
	name: "Chart",
    props: {
        money: {
            type: Array,
            required: true,
        }
    },
	data() {
		return {
			chart: {},
			canvas: {},
			graphData: [],
			chartSetup: {
				type: "bar",
				data: {
					labels: [],
					datasets: [
						{
							data: [],
							backgroundColor: [
								"rgba(255, 99, 132, 0.2)",
								"rgba(54, 162, 235, 0.2)",
								"rgba(255, 206, 86, 0.2)",
								"rgba(75, 192, 192, 0.2)",
								"rgba(153, 102, 255, 0.2)",
								"rgba(255, 159, 64, 0.2)",
							],
							borderColor: [
								"rgba(255, 99, 132, 1)",
								"rgba(54, 162, 235, 1)",
								"rgba(255, 206, 86, 1)",
								"rgba(75, 192, 192, 1)",
								"rgba(153, 102, 255, 1)",
								"rgba(255, 159, 64, 1)",
							],
							borderWidth: 1,
						},
					],
				},
				options: {
					plugins: {
						legend: {
							display: false,
						},
						tooltip: {
							enabled: true,
                            displayColors: false,
							callbacks: {
								title(context) {
									return `${months[currentMonth]}, ${context[0].label} число`;
								},
								label(context) {
									return new Intl.NumberFormat("uk-UA", {
										style: "currency",
										currency: "UAH",
									}).format(context.raw);
								},
							},
						},
					},
					scales: {
						y: {
							beginAtZero: true,
						},
					},
				},
			},
		};
	},
	mounted() {
		for (let day = 1; day <= getDaysInMonth(currentDate); day++) {
			this.chartSetup.data.labels.push(day);
		}
        this.chartSetup.data.datasets[0].data = this.money;
		this.canvas = this.$refs.canvas;
		this.chart = new Chart(this.canvas, this.chartSetup);
	},
};
</script>

<style scoped>
canvas {
	width: 100%;
	max-height: 50vh;
}
</style>
