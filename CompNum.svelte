//compNum = input that accepts only numbers
<script>
	export let value

	export let step
	export let min
	export let max
</script>

<input bind:value type="number" {step} {min} {max}/>

<style>
	input {
		width: 100%;
	}
</style>
