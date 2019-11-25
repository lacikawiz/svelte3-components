<script context=module>
/*
Example
First one doesn't create an icon, only loads in the iconset file
<Icon src="sprites.svg" />
<Icon on:click={()=>{close()}} icon="icon-close" size="1em" />

-------------------
Format of SVG file should be:

<svg>
	<symbol id="icon-close" viewbox="0 0 512 512">
	  The actual SVG code for the icon (<path>, etc)
	</symbol>
</svg>

Notes: `viewbox` needs to be specified on each <symbol> otherwise they won't get displayed properly

*/

function handleFetchErrors(response) {
	if (!response.ok) {
		throw Error(response.statusText);
	}
	return response;
}

</script>

<script>
	export let id=""
	export let size="100px"
	export let src=""

	$: load(src)

	function load(src){
		if (!src) return
		//load in the SVG icons
		fetch(src,{method:"get"}).then(handleFetchErrors)
			.then(r=>r.text()).then(r=>{
				document.body.insertAdjacentHTML('afterbegin',r)
				document.querySelector("body > svg:first-child").style.display="none"
			})
			.catch((err)=>{
				console.log(`Could not load the SVG icon's file: "${src}". ${err}`)
			})
	}

</script>

{#if id}
<svg style="width:{size};height:{size}" on:click><use xlink:href="#{id}"></use></svg>
{/if}
