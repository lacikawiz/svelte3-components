<script>
	import {slide} from 'svelte/transition'
	import Icon from './CompIcon.svelte'
	export let control  //the control object that is bound to this instance
	let messages=[]

	control = {
		add: (msg)=>{
			let x=messages
			x.push(msg)
			messages=x
		},
		clear: ()=> messages = []
	}

  	let close = (idx)=>{
  		let x=messages
  		x.splice(idx,1)
  		messages=x 
  	}

</script>

<section id="messages">
	{#each messages as message,idx (message)}
		<div class="message" transition:slide={{duration:500}}>
			<span>{message}</span>
			<Icon on:click={()=>{close(idx)}} icon="icon-close" size="1em" />
		</div>
	{/each}
</section>

<style>
	#messages {
		position: fixed;
		bottom:0;
		left:0;
		right:0;
		background:#0f0;
	}
	.message {
		display:flex;
		padding:2px;
	}
	.message span {
		flex-grow: 1;
	}
</style>