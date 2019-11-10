//compYesNo = Yes/No answer with button
<script>
	export let value

  	// export let step
  	// export let min
  	// export let max
</script>

<div id=yesno>
	<div class:yes={value===true} on:click={()=>value=true}>Yes</div>
	<div class:no={value===false} on:click={()=>value=false}>No</div>
</div>
 
<style>
	#yesno {
		width: 100%;
		display: flex;
	}	
	#yesno > * {
		flex-grow: 1;
		text-align: center;
		padding:3px;
		background: #aaa;
		border:2px outset;
	}
	.yes {
		background: #8f8 !important;
		font-weight: bold;
	}
	.no {
		background: #f88  !important;
		font-weight: bold;
	}
/*	.selected {
		outline: 2px solid #f00d;
	}*/
</style>