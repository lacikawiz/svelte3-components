# Svelte3 `<AutoComplete>` component

Aka:
* quick search
* instant search
* quick select

## Function

Create a text input which is connected to a lookup function which provides suggestions/search results as the user types.

The user can select the search result by mouse/touch or keyboard, and the text field will get filled with that result and the `id` associated with it will also get stored. (similar to the `value` inside an `<option>` HTML tag)

## Basic operation

User types in a few characters, when the typing finished the lookup function is called and the results displayed.

<div class="example" style="height:24em;">
<div class="autocomplete "><input value="a" type="text" name="input506" placeholder="Brand name" class=""> <ul class=" "><li class="result ">AC </li><li class="result selected">Acura </li><li class="result ">Alfa Romeo </li><li class="result ">Alpina </li><li class="result ">AMC </li><li class="result ">Aston Martin </li><li class="result ">Audi </li><li class="result ">Ford Asia </li><li class="result ">Yema Auto </li></ul></div>
</div>

The user can use the UP and DOWN keys, or the mouse to navigate between the results.

A click on the list item, or Enter / Tab on the keyboard will select that item and that item will be copied into the textbox and its ID will be returned.

<div class="example" style="height:5em;">
<div class="autocomplete "><input value="Acura" type="text" name="input506" placeholder="Brand name" class=" valid"> <ul class=" hide"><li class="result ">Acura </li></ul></div>
</div>

The green background indicates, that it's a good value and was selected from the list.

Modifying the text from the accepted value will invalidate the selection and the list of options will again be displayed:

<div class="example" style="height:7em;">
<div class="autocomplete"><input value="Acur" type="text" name="input506" placeholder="Brand name" class=""> <ul class=""><li class="result">Acura </li></ul></div>
</div>

## How to use in Svelte3

A simple example:

`yourComponent.svelte`

```HTML
<script>
import AutoComplete from './CompAutoComplete.svelte'
let value=""
let id

//The lookup function needs to return the Promise that resolves to an array
//This one searches the Car manufacturers from the database via an API call
function searchFn(text){
  return fetch("http://life:8529/_db/AutoParts/UI/manufacturers/qs/"+text)
  .then(x=>x.json()).then(x=>x.map(v=>{
    return {text:v.name,id:v.id}
  }))
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
```

## Specification of attributes

| Attribute | Description | Default Value |
| :------------- | :------------- | :------------- |
| `lookupFn`* | A function that handles the lookups. See below for specifications. | no default |
| `text`* | The text value of the input box. Should be used with `bind:` for 2 way binding.  | "" |
| `id` | The `id` of the selected item. Should be used with `bind:` to receive the value | null |
| `minlen` | The minimum number of characters before the lookup function is called | 2|
| `name`       | The name attribute for the input box | "input"+random_number, eg: "input863" |
| `placeholder`       | The placeholder string that shows up when the input is empty       | "" (empty string) |
 | `required` | same the `required` attribute for the HTML `<INPUT>` element | false
 | `disabled` | If true the input box can't be changed | false
 | `noresult` | The message string to show when the lookup produced no results  | "No match found." |
 | `loadingmsg` | The message that shows up while the lookup is being run | "Loading..." |

## Lookup function specifications

The key part of this component is the lookup function, which provides the suggestions/search results based on the user input.

The signature of the function is:

```JS
function(search_text){
  ...
  return promise_that_resolves_to_a_JSON_array
}
```

The result JSON array should be in the following format:
```JSON
[
  {"text":"string that displays for the user",
   "id":"string that will be returned for the `id` attribute" },
  ...
]
```

If your API returns the results in a different format then simply use a `map` function on the array (as seen above in the example.)

<style>
  body {
    font-size: 1.2em;
    background: #000 !important;
  }

  h1 {
    border-bottom: 2px solid #f0f8;
  }

  h2 {
    border-bottom: 2px solid #ff08;
  }

  * {
    box-sizing: border-box;
  }

  .example {
    width: 100%;
    background:#ccc;
    padding: 1em;
    border: 2px solid #000;
  }

  input {
    height: 30px;
    font-size: 15px;
    padding: 5px 10px;
    width:100%;
  }

  .autocomplete {
    position: relative;
    color: #000;
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
    color: #000;
  }

  .hide {
    opacity: 0;
  }

  .valid {
    background: #afa;
  }

</style>
