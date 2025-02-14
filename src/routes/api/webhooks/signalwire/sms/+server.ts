import { supabase } from '$lib/supabase/realtime.js';


export async function POST ({ request }) {
	const { From: endpoint, To: systemEndpoint, Body: body } = await request.json();
	
	supabase.channel('votes').send({
		type: 'broadcast',
		event: 'incoming_vote',
		payload: {
			endpoint,
			body
		}
	});

	return new Response(`<?xml version="1.0" encoding="UTF-8"?><Response></Response>`, { 
		headers: {
			'Content-Type': 'application/json'
		}
	});
}
