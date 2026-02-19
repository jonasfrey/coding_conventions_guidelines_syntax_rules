# APN Abstract Prefix Notation

the problem: programmers are good and fast while coding, their shor-term memory brain has all information. after some time of break when reading the same code they have a hard time to understand things. 
the old solution: comments
my solution: APN abstract prefix notation , embedding crucial code into the variable names. 


advantages: 
- a global standard is formed
    - programmers can more easily read back their code and be more efficient
    - programmers can understand more easily code from other authors
- no need to maintain comments (but backward compatibility )
    - comments do not have to be maintained since comments become obsolete (almost)
    - comments are still possible but are use the way they have to be used, to give meta information that is not crucial for the programm to work

- brain re-shaping
    - programmers brains are re-shaped every almost like pictograms the prefixes show what variables contain (on an abstract layer only of course)

# abstract data types
there are only 5 types
numbers   n_: 0, 1, 6.2831, -1234
strings   s_: "c", "veryOS"
booleans  b_: true, false
objects   o_: {n: 6.2831, s: "Tau", b:true}
arrays    a_: [-1234, 1, "Tau" , 6.2831, [true]]

functions f_: (a,b)=>{return a+b}
variable  v_: 0, "c" or {n:6.28}, [true, false, false] //can be any abstract type

those types occur in almost every programming language in an abstract way. of course compoiled languages have much more precise types like rust u32, i8, f32, Vec<u8> etc. but APN is not there to embed the exact type into the variable name but only to say what abstract type a variable is about.

# packing and unwrapping 
there are types that wrap some stuff, and those can logically be unwrappe in an abstract way. 
a_n => [1,2,3]
n = a_n[0] // 1

a_s => ["pi", "<", "tau"]
s = s[2] // "tau"

s_o_person__json = `{"s_name" : "JSON"}
s_f = `(a,b)=>{return a+b}`
o_person = f_v_parsed(s_o_person__json)
f = eval(s_f)

following this principle , multidimensional arrays can be beautifully represented

a_a_n__image = [[0,1,0], [1,0,1], [0,1,0]]
a_o = [{n: 2}, {n:3}]

the second prefix in function names represents its return value

f_generate_file = ()=>{ writeFile('asfd', 'asdf.txt')}
f_n_sum = (a,b)=>{return a+b}
f_o_person = (s_name)=>{return {s_name}}

n_sum = f_n_sum(20,30)

# qualifiers 
double undescore seperates base name from qualifier 

a_o_user__filtered 
n_idx__start 
n_idx__end 

NAMING ORDER
  Generic → Specific
  n_id__frame      (not: frame_id)
  n_ms__timestamp  (not: timestamp_ms)

# database and relations 

DATABASE
  Table name:   a_o_{entity}
  Primary key:  n_id  (integer)  or  s_id  (UUID)
  Foreign key:  n_o_{entity}_n_id

NO PLURAL WORDS
  a_o_user   (not: users)
  a_n_score  (not: scores)


# no plural names



# optional extension
APN is not a statical fixed rule set but more a logical approach to a problem. special types could be introduced, for example in javascript there is the byte array Uint8Array, the could be named a_n_u8__image , for example for a function that saves an image 
f_save_image__from_a_n_u8_image or if a file is loaded f_a_n_u8__file, would return that byte array. 


# synoyms
synonym do have the right to exist but only if they really have a profound value. when forming a standard it is important to use as less synonym's as possible to avoid confusion. therefore here is a list of synonyms , the first word is always the one that is used
array <=> list 
function <=> method
object <=> dictionary <=> instance


