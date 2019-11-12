<script>
  /*
  */
  import AutoComplete from './CompAutoComplete.svelte'
  let value=""
  let id

  const testArr=["Audi","Chevrolet","Ford","Lada","ВАЗ","Suzuki","УАЗ","Jeep","BMW","Toyota","GMC","Lexus"]

  function searchFn(text){
    text=text.toLowerCase()

    return fetch("http://life:8529/_db/AutoParts/UI/manufacturers/qs/"+text)
    .then(x=>x.json()).then(x=>x.map(v=>{
      return {text:v.name,id:v.id}
    }))
/*
    return new Promise((resolve, reject) => {
      //simulate delayed response
      setTimeout(()=>{
        resolve(
          testArr.filter(val => {
            return val.toLowerCase().indexOf(text)>=0
          })
          .map((val,i)=>{return {label:val,value:i}})
        )
      },500)
    });
*/
  }
</script>

<AutoComplete
  placeholder="Brand name"
  bind:text={value}
  bind:id={id}
  lookupFn={searchFn}
  noresult="Nothing found."
  minlen=1
/>

<p>text: {value}</p>
<p>id: {id}</p>
