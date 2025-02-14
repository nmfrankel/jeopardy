import questions_list from './questions.json'

type GameState = {
	screen: 'login' | 'question' | 'result',
	questions_list: GameQuestion[]
	questionIndex: number
	votes: Vote[]
	reveal: boolean
	// status: ''
	// leaderBoard: {
	// 	name: string;
	// 	score: number;
	// }[]
}

type GameQuestion = {
	topic: string
	question: string;
	options: string[];
	answer: number;
	played: boolean;
}

type Vote = {
	id: number
	value: string
	user_id: string
	question_number: number
	is_correct: boolean
	created_at: Date
}

export let app = $state<GameState>({
	screen: 'login',
	questions_list,
	questionIndex: 0,
	votes: [],
	reveal: false,
	// status: '',
	// leaderBoard: []
})
