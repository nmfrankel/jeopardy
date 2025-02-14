<script lang="ts">
	import { app } from '../state.svelte'

	// const selectQuestion = (number = 0) => {
	// 	$appState.currentQuestion = number;
	// 	$appState.activeScreen = 'Question';
	// 	questions[number].played = true;
	// };
</script>

<!-- <section class="w-screen h-screen bg-[url(/background2.jpg)] bg-cover bg-center">
&nbsp;
</section> -->

<div class="center">
	<h2 style="margin: 0 auto .5em">SELECT A TOPIC</h2>
	<div class="categories">
		{#each app.questions_list as question, i}
		<!-- {#each app.questions_list as { topic, played }, i} -->
			{question.question}
			<!-- <Button_ text={topic} on:click={() => selectQuestion(i)} /> -->
			<!-- <Button disabled={played} on:click={() => selectQuestion(i)}>
				{topic}
			</Button> -->
		{/each}
	</div>
</div>

<style>
	.categories {
		display: grid;
		width: 80%;
		grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
		gap: 1rem 1rem;
	}
	:global(.categories > button) {
		height: 3rem;
	}
	:global(button::first-letter) {
		text-transform: uppercase;
	}
	:global(button[disabled]) {
		background-color: #aaa;
		opacity: 0.65;
	}
</style>
