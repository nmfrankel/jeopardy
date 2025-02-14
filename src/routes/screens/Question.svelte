<script lang="ts">
	import { supabase } from '$lib/supabase/realtime';
	import { app } from '../state.svelte';

	let question = $derived(app.questions_list[app.questionIndex]);
	let timer = $state(59);
	let counting = $state(false)
	let interval: NodeJS.Timeout

	function startTimer() {
		clearInterval(interval);
		counting = true

		interval = setInterval(() => {
			if (timer <= 1) {
				clearInterval(interval);
				counting = false
				timer = 0;
				app.reveal = true;
			} else {
				timer--;
			}
		}, 1000);
	}

	startTimer();

	supabase
	.channel('vote')
	.on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'vote' }, async (payload: any) => {
		console.log('Change received!', payload)
		const { user, id, value } = payload.new

		await supabase.from('vote').update({ question_number: app.questionIndex, is_correct: value.trim() === (app.questions_list[app.questionIndex].answer + 1).toString(10) }).eq('id', id);

		app.votes = [...app.votes, {
			value,
			name: user,
			questionNumber: app.questionIndex
		}]

		console.log('Vote added!', app.votes)
	})
	.subscribe()

	function pauseHandler(event: KeyboardEvent) {
		if (event.code === 'Space' && counting) {
			clearInterval(interval);
			counting = false
		} else if (event.code === 'Space') {
			startTimer();
		}
	}

	$effect(() => {
		if(app.questionIndex) {
			timer = 59
			startTimer()
		}
	})
</script>

<svelte:body on:keydown={pauseHandler} />

<div class="absolute top-8 w-full text-center text-5xl/16 font-bold text-white tracking-wide">
	0:{timer.toString().padStart(2, "0")}
</div>

<section class="w-screen h-screen bg-[url(/background.png)] bg-cover bg-center text-center">
	<div class="relative top-[25%] h-[60%] text-white flex flex-col justify-around">
		<div class="py-4 w-[50%] mx-auto text-5xl/16 font-bold">
			{question?.question}?
		</div>
		<div class="grid grid-flow-col grid-cols-2 grid-rows-2 gap-y-11 gap-x-10 mx-auto w-[80%] options">
			{#each question?.options ?? [] as option, i}
				{@const isAnswer = i === question.answer}
				{@const voteCount = app.votes.filter(v => v.value.trim() === (i+1).toString() && v.questionNumber === app.questionIndex).length}

				<div class="relative transition duration-700 ease-out {isAnswer && app.reveal? 'bg-green-600': 'bg-slate-700'} rounded-xl overflow-hidden grow-0">
					<div
						class="absolute h-full bg-slate-400" style="width: {(voteCount / (app.votes.length || 1)) * 100}%"
						class:hidden={app.reveal}
					></div>
					<div class="relative p-4 text-2xl font-bold tracking-wide option">
						{option}&nbsp;
					</div>
				</div>
			{/each}
		</div>
	</div>
</section>

<style>
	.options {
		counter-reset: option;
	}
	.option::before {
		position: absolute;
		top: .75rem;
		left: 1rem;
		padding: 0.15em 0.5rem;
		font-size: 1em;
		counter-increment: option;
		content: counter(option);
	}
</style>
