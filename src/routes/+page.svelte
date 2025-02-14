<script lang="ts">
	import Question from './screens/Question.svelte';
	import Leaderboard from './screens/Leaderboard.svelte';
	import { app } from './state.svelte'
	import { supabase } from '$lib/supabase/realtime';
	
	const screens = {
		question: Question,
		leaderboard: Leaderboard
	};

	supabase.channel('votes').on(
		'broadcast',
		{ event: 'incoming_vote' },
		(payload: any) => {
			const { body, endpoint} = payload.payload

			app.votes.push({
				value: body,
				name: endpoint,
				questionNumber: app.questionIndex
			})
		}
	).subscribe()
	
	// const handleInserts = (payload: any) => {
	// 	const { body, endpoint} = payload.payload

	// 	app.votes.push({
	// 		value: body,
	// 		name: endpoint,
	// 		questionNumber: app.questionIndex
	// 	})
	// }

	supabase
	.channel('vote')
	.on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'vote' }, async (payload: any) => {
		console.log('Change received!', payload)
		const { user, id, value } = payload.new

		await supabase.from('vote').update({ question_number: app.questionIndex, is_correct: value.trim() === (app.questions_list[app.questionIndex].answer + 1).toString(10) }).eq('id', id);

		app.votes.push({
			value,
			name: user,
			questionNumber: app.questionIndex
		})

		console.log('Vote added!', app.votes)
	})
	.subscribe()

	let activeScreen = $state<keyof typeof screens>('question');
	let Component = $derived(screens[activeScreen]);

	function changeState (event: KeyboardEvent) {

		switch (event.code) {
			case 'KeyR':
				app.reveal = !app.reveal;
				break;
			case 'KeyL':
				activeScreen = activeScreen === 'leaderboard' ? 'question' : 'leaderboard';
				break;
			case 'ArrowLeft':
				app.reveal = false;
				app.questionIndex--;
				break;
			case 'ArrowRight':
				app.reveal = false;
				app.questionIndex++;
				break;
		}
	}
</script>

<svelte:body on:keydown={changeState} />

<main class="w-screen h-screen bg-[url(/background2.jpg)] bg-cover bg-center">
	<Component />
</main>
