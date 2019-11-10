<script context="module">
// ---------------------------------------------
// compTooltip = creates a "?" with popup tooltip (information box) 
// when the content is open container is scrolled to bring it into view automatically, if needed
// 
// USE example:
// <ToolTip>This is an example <b> of </b> a list <ul>
// 			<li>One</li>
// 			<li>Two</li>
// 		</ul>
// </ToolTip> 
// ---------------------------------------------

	let boxes={} // an object containing the close functions for the info boxes

	// calls the close procedure on all boxes except for the one specified by the ID
	function clearBoxes(ID){
		for (const key in boxes) {
			if (key!=ID) boxes[key]()
		}
	}

	let nextID=0
</script>

<script>
	import calcScrollIntoView from 'compute-scroll-into-view'
	import {onMount} from 'svelte'
	let contentBox
	let width="auto"
	let ID
	let show=false

	onMount(()=>{
		//doing some initial sizing based on the text content
		let w=contentBox.textContent.length/6
		width=w
		if (w<20) w=20
		if (w<5) w=5
		width+="em"
		ID=nextID++
		boxes[ID] = ()=> {show=false }
		return ()=>{delete boxes[ID] }  //if the module gets unmounted remove it from the list
	})


	$: {if(show){
		clearBoxes(ID)
		setTimeout(()=>{
			let actions=calcScrollIntoView(contentBox,{block:"end",inline:"end",scrollMode:"if-needed"})
			actions.forEach(({ el, top, left }) => {el.scrollTop = top; el.scrollLeft = left })			
		},100)
	}}

</script>

<div id=mod class:hover={show} on:click={()=>{show=!show}}  >
	<svg viewBox="0 0 24 24" id=q-mark><circle cx=12 cy=12 r=10 /><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3" /><line x1=12 y1=17 x2=12 y2=17/></svg>	
	<div id=inside style="width:{width}" bind:this={contentBox}>
		<svg viewBox="0 0 24 24" id=close><circle cx=12 cy=12 r=10 /><line x1=15 y1=9 x2=9 y2=15 /><line x1=9 y1=9 x2=15 y2=15 /></svg> 
		<slot />
	</div>
</div>

<style>

svg {
	width:1em;
	height:1em;
	fill: none;
	stroke: currentColor;
	stroke-width:2;
	stroke-linecap:round;
    stroke-linejoin:round;
}

svg#q-mark:hover {
}

svg#close {
	position: absolute;
	top:0;
	right:0;
}

#mod { 
  position: relative;
  display: inline-block;
}


#mod.hover #inside {
  display: block;
}

#inside {
    display: none;
    background-color: black;
    color: #fff;
    padding: 0.5em;
    border-radius: 0.5em;
    position: absolute;
    top: -0.5em;
    left: 120%;
    z-index: 1999;
    font-style: sans-serif;
}

#inside::after {
    content: " ";
    position: absolute;
    top: 1em;
    right: 100%;
    margin-top: -5px;
    border: 5px solid;
    border-color: transparent black transparent transparent;
}


</style>