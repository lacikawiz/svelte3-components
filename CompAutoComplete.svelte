<script>
  /*AutoComplete / QuickSelect component
  A textbox which shows the possible values as one types in part of a matching string

  */
  export let name
  export let placeholder
  export let required
  export let disabled
  export let value
  export let lookupFn  //the lookup function

  let results=[]
  let isLoading=false

  $: delayedResponse(value)

  let toID=null
  function delayedResponse(newVal){
    if (newVal.trim()=="") {
      results=[]
      return
    }
    if (toID!=null) { clearTimeout(toID) }
    toID=setTimeout(function () {
      toID=null
      results=lookupFn(newVal)
    }, 200);
  }

</script>

{#if typeof lookupFn!=="function"}
<p>Can't render the Autocomplete function. The lookup function is missing.</p>
{:else}
<div class="autocomplete">
  <input
    type="text"
    {name}
    {placeholder}
    {required}
    {disabled}
    bind:value={value}

  >
  <ul>
{#each results as result, i}
    <li> {@html result.label} </li>
{/each}
  </ul>
{#if isLoading}
  <slot>
    <p class="fallback">Loading data...</p>
  </slot>
{/if}
</div>

{/if}

<style>
  * {
    box-sizing: border-box;
  }

  input {
    height: 2rem;
    font-size: 1rem;
    padding: 0.25rem 0.5rem;
  }

  .autocomplete {
    position: relative;
  }

  .autocomplete ul {
    list-style: none;
    text-align: left;
    position: absolute;
    background: #34F;
  }

  .hide {
    display: none;
  }

</style>
