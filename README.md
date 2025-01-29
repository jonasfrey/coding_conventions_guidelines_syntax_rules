// stick to the following coding conventions  
# variable names
all have prefixes
v_ => 'value' a variable with a 'unknown' type
n_ => numnbers , eg. a.map((n_idx, v)=>{...})
b_ => boolean 
o_ => object
a_ => array
f_ => functions, yes also functions are variables, like let f_test = ()=>{return 'test'}
define all functions with a variable declaration keyword for example 
let f_test = function(){return 'test'}
a_n_ => an array containing numbers eg. [1,2,3]
a_o_ => an array containing objects eg. [{},{},{}]
an exeption: if objects with same structure are needed ofen times classes are used, 
but instead of having classes we have functions in this style 
f_O_person = function(s_name, n_age){return {s_name, n_age}}
this would return an object that represents a person. the equivalent of a class would be 
  class O_person {
    constructor(s_name, n_age) {
      this.s_name = s_name;
      this.n_age = n_age;
    }
  }
but like i said a simple function is preferred!
if a function returns a certain type this prefix comes at second place for example
f_a_n_=> a function that returns an array of numbers like let f_a_n_test = () =>{return [1,2,3]}

# no plural
another important this is , the plural form of words has to be omitted completly
example: 'hans' would be the value, we could use 's_name' as a variable name
['hans', 'gretel', 'ueli', 'jasmin'] would be the value 
'a_s_name' would be the variable name, since this is an array of names, 
so 'a_s_names' is wrong, it is an array 'a_', containing 's_name' variables, so 'a_s_name'! 

# name 'grouping'
the last thing: try to always 'group' variable names, so if the values are similar but the variable names 
have to be distinguished always use the basic / more general variable name in front of it , for example 

let o_person__hans = new O_person('hans', 20);
let o_person__gretel = new O_person('gretel', '19'); 
more exmaples
for example an id is a very generic term so it comes first
n_timeout_id wrong, correct: n_id__timeout
n_frame_id wrong, correct: n_id__frame
n_start_index wrong, correct: n_idx__start, respectively n_idx__end 
n_timestamp_ms wrong, correct: n_ms__timestamp, or n_sec__timestamp or n_min__timestamp


# complete example 
```javascript

let f_O_person = function(
    s_name, 
    n_age
){
    return {
        s_name, 
        n_age
    }
}
let o_person__hans = new O_person('hans', 20)
let o_person__gretel = new O_person('gretel', 19)

let o_multidimensional = {
    n: 1, 
    b: true, 
    s: 'this is a string', 
    a_v: [1,'string', true, {n:1}], 
    a_n: [1,2,3],
    s_name: 'hans', 
    a_s_name: ['hans','gretel','jurg','olga'],
    o: {
        n: 2, 
        o: {
            n:2
        },
        a: [1,2,3], 
        b: true, 
    }
}
let f_a_n_idx = function(){
    return [0,1,2,3]
}
let f_add_numbers = function(n1, n2){return n1+n2}

let s_json__o_person = JSON.stringify(new O_person('hans', 20))

let s_f_test = `()=>{return 'test'}`

```