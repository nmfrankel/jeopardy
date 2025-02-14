<script lang="ts">
	import { app } from "../state.svelte";

	const authorize = (authCode: string) => {
		let date = new Date();
		let auth = Math.floor((date.getFullYear() / date.getMonth()) * date.getUTCFullYear())
			.toString()
			.substring(0, 4);
		if (auth === authCode && app.screen === 'login') {
			app.screen = 'Topics';
		} else if (authCode === 'nossonmfrankel@gmail.com') {
			return auth;
		} else {
			return false;
		}
	};
</script>


<main>
	<div>Enter access code to play</div>
	{authorize('nossonmfrankel@gmail.com')}
	<!-- <input type='text' bind:value={input} on:keyup={attemptLogin} /> -->
</main>
