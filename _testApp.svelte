<script>
  /*
  */
  import AutoComplete from './CompAutoComplete.svelte'
  let value=""

  const testArr=["Audi","Chevrolet","Ford","Lada","ВАЗ"]

  function
</script>

<AutoComplete placeholder="Brand name" bind:value={value}/>
