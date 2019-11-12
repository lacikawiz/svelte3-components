<script>
  /*AutoComplete / QuickSelect component
  A textbox which shows the possible values as one types in part of a matching string and allows the user to select the offered options
  Version: 1.0
  Date: 2019-11-11
  */

//The component parameters
  export let name="input"+Math.floor(Math.random() * 1000)  //give it a random name
  export let placeholder=""
  export let required=false
  export let disabled=false
  export let text=""
  export let id=null   //the `id` of the selected item
  export let lookupFn  //the lookup function
  export let noresult="No match found."
  export let loadingmsg="Loading..."
  export let minlen=2  //mininum length of input before lookup function is called

//State variables
  let results=[]
  let isLoading=false  //true, when lookupFn is called but its promise is not resolved yet
  let isFocused=false
  let selectedRow=-1

//implement a delayed response to any change in the input.
  $: delayedResponse(text)

//Delayed response
//Executes the lookup function only when the input stopped changing for 200ms

  let toID=null
  function delayedResponse(newVal){
    if (!isFocused) return;  //if the change was not due to user input then do nothing
    if (toID!=null) { clearTimeout(toID) }
    //If the input is shorter then the minimum length specified, then simply empty out the `result` - no need to call the lookup function
    if (newVal.trim().length<parseInt(minlen)) {
      results=[]
      return
    }
    toID=setTimeout(function () {
      //when the search start invalidate the previous result and display the loading message

      toID=null
      id=null
      isLoading=true
      results=[]

      lookupFn(newVal)
        .then(res=>{
          results=res
        })
        .finally(()=>{
          //when the request finished switch the state
          isLoading=false
          selectedRow=-1   //reset the selection
        })
    }, 200);
  }

  //Handling the selection from the list, based on the `selectedRow` value
  //resultRec: {text:...,id:...}
  function selectValue(){
    let resultRec=null
    if (results.length==1) { //if there's only one result then accept that, whether it was selected or not
      resultRec=results[0]
    } else if (selectedRow>=0) { //if there's a selection then accept that one
      resultRec=results[selectedRow]
    }
    if (resultRec===null) return  //if no selection was made then simply exit

    //update the values with the selection
    text=resultRec.text
    id=resultRec.id
    results=[resultRec]  //reduce the results to the only one entry selected
    isFocused=false  //set the `isFocused` to false to prevent re-running of the lookup function
    selectedRow=-1  //invalidate the selection
  }

  //Handle the keystrokes received by the <INPUT> element
  function handleKeys(ev) {
    isFocused=true
    switch (ev.key) {
      case "ArrowUp":  //up arrow => moves the selection up, in a circle
        if (selectedRow<=0) {selectedRow=results.length-1}
          else {selectedRow--}
        ev.preventDefault()
        break
      case "ArrowDown": //down arrow => moves the selection down, in a circle
        if (selectedRow>=results.length) {selectedRow=0}
          else {selectedRow++}
        ev.preventDefault()
        break
      case "Enter":  //enter => accepts the selected value. Also form submission is prevented
        ev.preventDefault()
        selectValue()
        break
      case "Tab":  //tab => accept selected value. But doesn't prevent default action (moving the focus)
        selectValue()
        break
      case "Escape":  //escape => hide results, and clear the selection
        isFocused=false  //hide the result
        selectedRow=-1
        break

    }
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
    bind:value={text}
    on:focus={()=>{isFocused=true}}
    on:click={()=>{isFocused=true}}
    on:blur={()=>{isFocused=false}}
    on:keydown={handleKeys}
    class:valid={id}
  />
  <ul class:hide={!isFocused || id}>
  {#each results as result, i}
      <li
        class=result
        class:selected={i==selectedRow} on:click={()=>{selectedRow=i;selectValue()}}
        on:mousemove={()=>{selectedRow=i}}
      > {result.text} </li>
  {:else}
    {#if isLoading}
      <li>{loadingmsg}</li>
    {:else if text.trim().length>=parseInt(minlen) && toID==null}
      <li>{noresult}</li>
    {/if}
  {/each}
  </ul>
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
    width:100%;
  }

  .autocomplete {
    position: relative;
  }

  .autocomplete ul {
    list-style: none;
    text-align: left;
    position: absolute;
    background: #fff;
    margin: 0;
    padding: 0;
    left: 10px;
    right: 0;
    border:1px solid #000;
    border-bottom:none;
    border-top:none;
    transition: opacity 0.1s linear;
  }

  .autocomplete ul li {
    padding: 5px;
    border-bottom: 1px solid #000;
  }

  .autocomplete ul li.selected {
    background: #ff0;
    cursor: pointer;
  }

  .hide {
    opacity: 0;
  }

  .valid {
    background: #afa;
  }

</style>
