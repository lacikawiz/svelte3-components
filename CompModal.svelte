<!-- Svelte Modal component by Laszlo Szenes https://github.com/lacikawiz 
Converted for Svelte 3

Example:
<script>
	import Modal from './CompModal.svelte'

	function openModal(ev){
		console.log("event received:",ev.target)
		bigQ.open({noExit:!!ev.target.attributes.noexit})
			.then((res)=>{
				console.log("The selection was:",res)
			})
			.catch(()=>{
				console.log("The action was cancelled")
			})
	}
</script>

<Modal bind:control={bigQ}>
	<h1>This is a test</h1>
	<button on:click="{()=>{bigQ.close('Yes')}}">Yes</button>
	<button on:click="{()=>{bigQ.close('No')}}">No</button>
</Modal>
<button on:click={openModal}>Open Modal Without noExit</button>
<button noExit on:click={openModal}>Open Modal With noExit</button>
-->
<script>
	import {onMount} from 'svelte'
    let visible=false
    let result=null
    let contentEl  //content element 

//keep it for the promise    
    let resolve,reject

    let noExit

    export let width
//control object for 
	export let control={
		open: (options)=> {
			noExit=false
			if (options) {
				noExit=options.noExit
			}
			visible=true
			result=null
			contentEl.scrollTo(0,0)

			return (new Promise((succ,fail)=>{
				resolve=succ
				reject=fail
			})) 
		},
		close: (res)=> {
			visible=false
			result=res
		},
		getResult: ()=> {return result}
	}

	$: if (visible) {
		//when the modal gets active then we watch the keys
		window.addEventListener("keydown",keyPress)
		document.body.style.overflow="hidden" //this prevents scrolling of the main window
	} else {
		//when the modal is closed then we stop watching keys
		window.removeEventListener("keydown",keyPress)
		document.body.style.overflow=""
		if (result===null) {
			reject ? reject(): 0
		} else {
			resolve ? resolve(result) :0 
		}
	}

	function keyPress(ev){
		if(ev.keyCode==27) closeIt() //ESC
	}

	function closeIt(){  //attempted close
		if(noExit) return
		visible=false
	}

	//moving the DIV to the top level to make sure it's able to be a modal popup and cover everything
	let topDiv
	onMount(()=>{
		document.body.appendChild(topDiv);
	})

</script>


<div id=top class:visible bind:this={topDiv}>
	<div class='modal-background' on:click={closeIt}></div>

	<div class='modal' style="width:{width};" >
		{#if !noExit}
		<svg id="close" on:click={closeIt} viewBox="0 0 12 12"> <circle cx=6 cy=6 r=6 /> <line x1=3 y1=3 x2=9 y2=9 /> <line x1=9 y1=3 x2=3 y2=9 /> </svg>
		{/if}
		<div id=modal-content bind:this={contentEl}> <slot /> </div>
	</div>
</div>


<style>
	.modal-background {
		position: fixed;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background: #0003;
		/*cursor: pointer;*/
		z-index: 100000;
	}

	.modal {
		position: fixed;
		left: 50%;
		top: 50%;
		transform: translate(-50%,-50%);
		padding: 1em;
		border-radius: 6px;
		background: white;
	    border: 3px outset #ddd;
	    box-shadow: 10px 10px 5px #00000080;	
		z-index: 100000;
		height: 90vh;
	}

	#top {
		visibility: hidden;
	}

	.visible {
		visibility: visible !important;
	}

	#close {
		position: absolute;
		top:2px;
		right:2px;
		width:16px;
		height:16px;
		cursor: pointer;
		fill:#F44;
	}
	#close line {
		stroke:#FFF;
		stroke-width:2;
	}

	#modal-content {
		width:100%;
		height:100%;
		overflow: auto;
	}
</style>
