<script>
  /*
  */
  import AutoComplete from './CompAutoComplete.svelte'
  let value=""

  const testArr=["Audi","Chevrolet","Ford","Lada","ВАЗ"]

  function searchFn(text){
    text=text.toLowerCase()
    return testArr.filter(val => {
      return val.toLowerCase().indexOf(text)>=0
    }).map((val,i)=>{return {label:val,value:i}})
  }
</script>

<AutoComplete placeholder="Brand name" bind:value={value} lookupFn={searchFn}/>
