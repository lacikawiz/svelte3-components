<script context=module>
/*
Example
<Icon on:click={()=>{close()}} icon="icon-close" size="1em" />

*/	

//load in the SVG icons
fetch("/sprites.svg",{method:"get"})
	.then(r=>r.text()).then(r=>{
		document.body.insertAdjacentHTML('afterbegin',r)
		document.querySelector("body > svg:first-child").style.display="none"
	})
</script>

<script>
	export let icon=""
	export let size="100px"
</script>

{#if icon}
<svg viewBox="0 0 512 512" style="width:{size};height:{size}" on:click><use xlink:href="#{icon}"></use></svg>
{/if}

<style>
</style>
