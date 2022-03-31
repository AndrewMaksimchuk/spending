<template>
	<v-app>
		<v-container class="d-flex justify-center align-center height">
			<v-form>
				<v-row>
					<v-col>
						<v-text-field
							autofocus
							v-model="phoneNumber"
							label="Номер телефона"
							placeholder="(067)253-47-54"
							clearable
							:rules="[required, phoneLength]"
							validate-on-blur
							type="tel"
							inputmode="tel"
							v-mask="'(###)###-##-##'"
						/>
					</v-col>
				</v-row>
				<v-row>
					<v-col>
						<v-text-field
							v-model="password"
							label="Пароль"
							clearable
							:rules="[required, passwordLength]"
							:append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
							:type="show ? 'text' : 'password'"
							@click:append="changePasswordIcon"
							placeholder="v$pxkPGG@R8"
							validate-on-blur
						/>
					</v-col>
				</v-row>
				<v-row>
					<v-col>
						<v-btn
							width="100%"
							depressed
							color="primary"
							@click="submit"
							:loading="isLoading"
							
						>
							Увійти
						</v-btn>
					</v-col>
				</v-row>
			</v-form>
		</v-container>
	</v-app>
</template>

<script>
export default {
	name: "Entry",
	data() {
		return {
			phoneNumber: "",
			password: "",
			show: false,
			isLoading: false,
		};
	},
	methods: {
		required(value = "") {
			return Boolean(value) || "Обов`язкове";
		},
		phoneLength(value = "") {
			return value?.length >= 14 || "Необхідно 10 цифр";
		},
		passwordLength(value = "") {
			return value?.length >= 6 || "Мінімально 6 символів";
		},
		changePasswordIcon() {
			this.show = !this.show;
		},
		submit() {
			this.isLoading = true;
			setTimeout(() => this.isLoading = false, 3000);
			const { phoneNumber, password } = this.$data;
			console.log(phoneNumber, password);
		},
	},
};
</script>

<style scoped>
.height {
	min-height: 80vh;
}
</style>
