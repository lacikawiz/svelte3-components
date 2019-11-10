<script>
/*
	intelligent image displayer
	- implements lazy loading of images
	- applies all the filters and transformations defined in the data attribute


<ShowImg data={obj} [format= jpg|png|thm ] />
	- data: the object containing the JPG, PNG urls and the adjustment parameters
	- [jpg|png]: optional parameter to force displaying the JPG or PNG image, otherwise, it will try to display the PNG, and if not given then the JPG image
	Display and image with all the adjustmentst applied

data object:
	- jpgurl:
	- pngurl:
	- thmurl:
	- rotate: rotation in degrees
	- brightness: 100=original, <100 darker, >100 lighter
	- contrast: 100=original, <100 less contrast, >100 more contrast
	- saturate: 100=original, <100 less colors
	- gR,gG,gB: gamma correction for Red, Green and Blue (1=original, <1=darker, >1=lighter)

*/
	import {onMount,tick} from 'svelte'

	export let data
	export let format
	export let style
	export let disableRC
	export let DBG

	let visible=false
	let image
	
	let url
	$: { url=data.jpgurl
		if (!format){
			if (data.pngurl) url=data.pngurl
		} else {
			if (format.toLowerCase()=="png") url=data.pngurl
			if (format.toLowerCase()=="thm") url=data.thmurl
		}
		// console.log(format,url)
	}

	let css
	$: {
		css=""
		if (data.rotate !== 0 ) {css+="transform: rotate("+data.rotate+"deg);"}
		css+="filter:"
		if (data.brightness) {css+="brightness("+data.brightness+"%) "}
		if (data.contrast) {css+="contrast("+data.contrast+"%) "}
		if (data.saturate) {css+="saturate("+data.saturate+"%) "}
		if (svgFilter) {css+='url("#'+svgFilter+'")'}
		css+=";"
	}

	let svgFilter
	$: {
		svgFilter=""
		if(data.gR!=undefined && data.gR!=1) svgFilter+=data.gR
		if(data.gG!=undefined && data.gG!=1) svgFilter+=data.gG
		if(data.gB!=undefined && data.gB!=1) svgFilter+=data.gB
	}

//implementing the lazy loading using IntersectionObserver
	onMount(()=>{
		if (DBG!==undefined) {
			console.log("ShowImg mounted",data)
		}
		//console.log(image)
		let tmout=null
		let obs=new IntersectionObserver(function(entries, self) {
			// iterate over each entry
			let e=entries[0]
			// console.log(e)
			if (e.isIntersecting){
				tmout=setTimeout(()=>{
					visible=true
					self.unobserve(e.target);
				},300)
			} else {
				if (tmout) clearTimeout(tmout)
			}
		}, {rootMargin: "10%"})
		obs.observe(image)					
		return ()=>{
			obs.unobserve(image)
			if (tmout) clearTimeout(tmout) 
		}
	})

</script>

{#if url}
	<div on:mousedown on:mouseup on:mousemove on:click class=picture {style}
	oncontextmenu={disableRC ? "return false;" : ""}>
		<img bind:this={image} src={visible ? url: ''} alt="Coin Image" style={css} />
		{#if svgFilter}
		<svg>
		<filter id={svgFilter} >
		  <feComponentTransfer>
		    <feFuncR type="gamma" exponent={data.gR!=undefined ? 2-data.gR :" 1"} />
		    <feFuncG type="gamma" exponent={data.gG!=undefined ? 2-data.gG :" 1"} />
		    <feFuncB type="gamma" exponent={data.gB!=undefined ? 2-data.gB :" 1"} />
		  </feComponentTransfer>
		</filter>	
		</svg>	
		{/if}	
	</div>
{/if}


<style>
	.picture {
		position:relative;
		/*width:100%;*/
		overflow:hidden;
	}
	svg {
		display:none;
	}
/*Trick to make 1:1 aspect ratio based on: http://www.mademyday.de/css-height-equals-width-with-pure-css.html*/	
	.picture:before {
		content:"";
		display:block;
		padding-top:100%;
	}
	img {
		position:absolute;
		top:0;
		left:0;
		bottom:0;
		right:0;
		width:100%;
	}
</style>



