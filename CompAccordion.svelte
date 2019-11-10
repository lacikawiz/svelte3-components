<!--
	Accordion element
	parameters:
		`group`: (one-way): the accordion group where this element belongs to
		`title`: (one-way): the text to display on the section header
		`control`: (two-way): the control object that will be returned to the parent element so that it can control the open and closed state

Usage example:

<script>
	import Accordion from './CompAccordion.svelte'
	import {onMount} from 'svelte';

	let skuSel
	let skuEdit
	let imgBucket

	onMount(()=> {skuSel.open() })  //making the first selection open at start (by default they would all be closed)

</script>

<Accordion group=IH title="SKU Selection" bind:control={skuSel}>
	...SKU selection 
</Accordion>
<Accordion group=IH title="SKU Being Edited" bind:control={skuEdit}>
	...Edit your product here
</Accordion>
<Accordion group=IH title="Image Bucket" bind:control={imgBucket}>
	...Select from the new images 
</Accordion>
--->
<script context="module">
	import {tick} from 'svelte'

	let groups={}
	window.G=groups  //DBG
</script>

<script>
	import {onMount} from "svelte"
	let myIdx
	let open   //true if the section is open
	let container

	export let title=""
	export let group=""
	export let control = {
		open: function(){
			if (groups[group]) groups[group].forEach((el,idx)=>{
				el.close()
			})						
			open=true
		},
		close: function(){
			open=false
		}
	}

	onMount(()=>{
		if (!groups[group]) groups[group]=[]     //first element is the index of the active one
		myIdx=groups[group].length
		groups[group].push(control)
		return ()=>{
			console.log("Accordion element",title,"was removed.")
			//TODO (?) remove itself from group
		}
	})

	function toggle(){
		if (open) {
			control.close()
		} else {
			control.open()
		}
	}

	let currHeight=0

	function handleOpen(){
		//when opening keep checking any size changes, until it settles
		let intV=setInterval(()=>{
			if (container) {
				let H=container.scrollHeight
				if (currHeight==H) {
					clearInterval(intV)
					currHeight=99999 //don't limit any future growth
				} else currHeight=H
			}
		},500)
		if (container) currHeight=container.scrollHeight		
	}

	function handleClose(){
		if(!container) return;
		//set the `max-height` to actual height without delay
		container.style.transition="none"
		currHeight=container.scrollHeight
		//Need a little wait before the values take effect
		setTimeout(()=>{
			container.style.transition=""
			currHeight=0
		},10)
	}

	$: {if (open) handleOpen(); else handleClose() }

</script>

<nav on:click={toggle} title={open ? "close" : "open"}>{title} {open ? "▲" :"▼"}</nav>
<div bind:this={container} class=accordion style='max-height:{currHeight+"px"};'>  <!-- transition:slide={{duration:250}} -->
	<slot/>
</div>

<style>
	.accordion {
		transition: max-height 0.5s;
		overflow: hidden;
	}
	nav {
		display:block;
		width:100%;
		background: #2f2;
		border:1px solid #0008;
		padding:5px;
		cursor: pointer;
	}
</style>
