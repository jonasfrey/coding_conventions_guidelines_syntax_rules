# Logical Prefix Notation (LPN): A Type-Encoding Naming Methodology for Dynamically Typed Languages

**Jonas Immanuel Frey**
Independent Researcher
Published: 2026
License: MIT

---

## Abstract

This paper introduces **Logical Prefix Notation (LPN)**, a systematic naming methodology for variables, functions, and data structures in all programming languages. LPN encodes logical type information, cardinality, return types, and semantic qualifiers directly into identifier names using a consistent, composable prefix grammar. Unlike Hungarian Notation, which has been widely criticized for encoding implementation details, SPN encodes structural and semantic type information that is stable across refactoring and is composable through a defined algebra. The methodology eliminates entire categories of runtime errors, reduces cognitive load during code review, and produces code that is self-documenting without requiring external tooling. SPN is demonstrated primarily in JavaScript but is applicable to any programming language. The full specification is available as open-source software.

**Keywords:** naming convention, coding style, dynamically typed languages, code readability, software engineering methodology, type annotation, variable naming, self-documenting code

---

## 1. Introduction

Programming languages such as JavaScript, Python, Ruby, and PHP enable rapid development by relaxing type constraints. However, this flexibility introduces a class of defects that statically typed languages prevent at compile time: operations on values of unexpected types. A function that expects a number receives a string; an array is passed where a single object is expected; a boolean is used as an array index. These errors are only discovered at runtime, often in production.

Static type systems (TypeScript, Flow) address this by adding a type layer on top of the language. They are powerful, but they require tooling, compilation steps, and significant adoption overhead. Many codebases — especially in scripting, data science, embedded systems, and rapid prototyping — use dynamically typed languages by choice or necessity.

The question addressed in this paper is: **Can systematic naming conventions alone provide meaningful type safety, without external tooling?**

We argue yes. This paper introduces **Structured Prefix Notation (SPN)**, a naming methodology in which every identifier carries its type, structure, and semantic qualifiers as a readable prefix. SPN is not a new type system — it is a discipline of naming that encodes type information that would otherwise be invisible or buried in documentation.

SPN consists of six core rules:

1. **Type prefix**: every variable name begins with a prefix encoding its runtime type
2. **Compound prefix**: container types encode the type of their contents
3. **Return type prefix**: function names encode their return type
4. **No plural words**: cardinality is expressed through the array prefix, not English pluralization
5. **Generic-first naming order**: qualifiers follow the base name, separated by double underscore
6. **Relational naming**: foreign keys and table names follow the same prefix grammar

These rules compose into a coherent system. A reader who knows SPN can determine the type, structure, and semantic role of any identifier at a glance, without hovering for tooltips, reading documentation, or running the code.


## snake_case is required.
without snake_case LPN won't work and get messy so it is highly recommended to use it. also when using it, the underline character ('_') can be used as a separator and the unwrapping logic can be dynamically encooperated into a software 

for example 
```javascript
let f_s_type = function(s_varname){
  return s_varname.split('_')?.at(0)
}
```
---



## 2. Related Work

### 2.1 Hungarian Notation

Hungarian Notation, introduced by Charles Simonyi at Microsoft in the 1970s [1], is the earliest systematic attempt to encode information in variable names. Simonyi's original "Apps Hungarian" encoded semantic intent (e.g., `us` for unsafe string, `s` for safe string). It was later misapplied at Microsoft as "Systems Hungarian," encoding raw data types (e.g., `lpszName` for "long pointer to null-terminated string"). Joel Spolsky's influential essay "Making Wrong Code Look Wrong" [2] rehabilitated Simonyi's original intent: encoding semantic invariants, not implementation types.

SPN differs from Hungarian Notation in several ways:

- SPN targets dynamically typed, high-level languages; Hungarian Notation was designed for C
- SPN's compound prefixes (`a_o_`, `a_n_`) encode nested structural types — a feature Hungarian Notation does not support
- SPN encodes return types in function names, which Hungarian Notation does not address
- SPN defines a naming order convention (generic-first, qualifier-last) that Hungarian Notation does not specify

### 2.2 TypeScript and Static Type Systems

TypeScript [3] provides optional static typing for JavaScript through a compiler layer. It solves the same problem as SPN, but requires tooling, a build step, and adoption of a superset language. SPN is tooling-free and applicable anywhere plain JavaScript runs. Both approaches are complementary: a team using TypeScript can still benefit from SPN's naming order and qualifier conventions.

### 2.3 JSDoc

JSDoc annotations [4] add type information to JavaScript as structured comments. They require external tooling (IDEs, documentation generators) to be useful and are invisible in a plain text editor or code review. SPN encodes the same information in the names themselves, making it visible everywhere without tooling. LPN does not require wasting time with maintaining comments. it enforces the programmer to code cleaner by design. 

### 2.4 Conventional Naming Guidelines

Existing naming guides (Google JavaScript Style Guide, Airbnb Style Guide, MDN) address case conventions (camelCase, SCREAMING_SNAKE_CASE) and prohibit single-letter variable names, but they do not provide a systematic grammar for encoding type information. SPN provides what these guides leave undefined.

---

## 3. The Structured Prefix Notation Specification

### 3.1 Type Prefixes

Every variable name begins with a type prefix, followed by an underscore. The core type prefixes are:

| Prefix | Type | Example |
|--------|------|---------|
| `v_` | Unknown / mixed type | `v_result` |
| `n_` | Number (integer or float) | `n_age` |
| `b_` | Boolean | `b_done` |
| `s_` | String | `s_name` |
| `o_` | Object (plain object or struct) | `o_config` |
| `a_` | Array | `a_item` |
| `f_` | Function | `f_callback` |

The `v_` prefix is reserved for genuinely polymorphic values — variables whose type is intentionally variable. Its presence signals to reviewers that this identifier requires careful handling.

**Rule:** A boolean variable never takes an `is_` prefix. `b_done` is correct; `b_is_done` is redundant and forbidden.

### 3.2 Compound Prefixes

When a container (array, object) has a homogeneous inner type, the prefix is compounded. Compound prefixes are formed by joining the container prefix, inner type prefix, and base name, all separated by underscores:

```
a_n_score      // array of numbers
a_s_name       // array of strings
a_o_user       // array of objects (user objects)
a_b_flag       // array of booleans
a_f_callback   // array of functions
a_a_o_point    // array of arrays of objects (e.g., a list of polygons, each a list of points)
```

This creates a type algebra: the compound prefix is a structured type expression read left-to-right. `a_o_user` is parsed as "array of object-type user." This is formally analogous to a parameterized type constructor `Array<Object>`.

### 3.3 No Plural Words

English pluralization encodes cardinality ambiguously and inconsistently (`user` / `users`, `datum` / `data`, `index` / `indices`). SPN forbids plural nouns. Cardinality is expressed entirely through the `a_` prefix.

- Forbidden: `users`, `numbers`, `filters`, `callbacks`
- Correct: `a_o_user`, `a_n_number`, `a_v_filter`, `a_f_callback`

A variable named `a_s_name` is correctly parsed as "an array containing string-type name values." The array itself is singular — it is one array. The `a_` prefix already communicates multiplicity; pluralizing the noun would be redundant.

### 3.4 Return Type Encoding in Function Names

Functions that return a value encode their return type as a second prefix between `f_` and the semantic name:

```
f_n_sum          // function returning a number
f_b_in_array     // function returning a boolean
f_s_label        // function returning a string
f_o_person       // factory function returning a person object
f_a_n_index      // function returning an array of numbers
```

Functions that return nothing (void functions, side-effect-only functions) omit the return type prefix:

```
f_calculate      // side-effect function, returns nothing
f_render         // side-effect function, mutates the DOM
```

The presence or absence of a return type prefix is itself a signal: `f_render` is a procedure; `f_n_render` is a function that returns a number. This distinction, invisible in conventional naming, is immediately apparent in SPN.

### 3.5 Factory Functions Instead of Classes

SPN recommends replacing class definitions with factory functions — plain functions that return object literals. This is consistent with the functional JavaScript pattern popularized by Eric Elliott [5]:

```javascript
// Conventional class (discouraged in SPN)
class Person {
  constructor(s_name, n_age) {
    this.s_name = s_name;
    this.n_age = n_age;
  }
}

// SPN factory function
let f_o_person = function(s_name, n_age) {
  return { s_name, n_age };
};
```

The factory function `f_o_person` clearly signals its return type (`o_` = object). It is a first-class value (can be passed, stored, and composed), avoids the `this`-binding pitfalls of class methods, and eliminates the prototype inheritance chain that complicates debugging.

### 3.6 Generic-First Naming Order

In conventional naming, qualifiers precede the base name: `filteredUsers`, `startIndex`, `frameId`. This groups items by qualifier rather than by concept, scattering related variables across an alphabetical listing.

SPN reverses this: the most generic (base) concept comes first, and qualifiers follow, separated by a double underscore (`__`):

```
a_o_user__filtered     // not: filtered_users
n_idx__start           // not: start_index / startIndex
n_idx__end             // not: end_index / endIndex
n_id__frame            // not: frame_id / frameId
n_id__timeout          // not: timeout_id / timeoutId
n_ms__timestamp        // not: timestamp_ms
o_user__hans           // a specific instance of a user object
o_user__gretel
```

The double underscore (`__`) is a deliberate separator that visually distinguishes the semantic base name from its qualifier. This is not a standard JavaScript convention, which makes it immediately recognizable as an SPN qualifier separator.

**Benefit:** In sorted variable lists, all variants of a concept are grouped together. `n_idx__end`, `n_idx__start` appear adjacent; `o_user__gretel`, `o_user__hans` appear adjacent. Conceptual grouping is automatic.

### 3.7 Relational Database Naming

SPN extends to relational database schemas. Tables are named with the `a_o_` prefix convention (signifying a collection of object-type rows). Primary keys follow the type prefix rule. Foreign keys encode both the referenced table and the referenced column:

```
-- Table: a_o_person
-- Columns:
--   n_id          (integer primary key)
--   s_name        (string)

-- Table: a_o_finger
-- Columns:
--   n_id                  (integer primary key)
--   n_o_person_n_id       (foreign key referencing a_o_person.n_id)
--   s_name                (string)
```

The foreign key name `n_o_person_n_id` is parsed as: "a number that is the `n_id` of an `o_person`." This encoding makes the join relationship explicit in the column name itself, without requiring an entity-relationship diagram.

**Rule for ID types:** Integer IDs are prefixed `n_id`. UUID or non-numeric IDs (as in PostgreSQL's UUID primary keys) are prefixed `s_id`, since a UUID contains non-digit characters and is better represented as a string.

### 3.8 Standard Abbreviation Glossary

SPN defines a mandatory abbreviation glossary to prevent ad-hoc abbreviation. Abbreviations are only used when they are in this glossary; otherwise, full words are used.

| Abbreviation | Meaning |
|---|---|
| `idx` | index |
| `pos` | position |
| `off` | offset |
| `k` | key |
| `el` | element |
| `evt` | event |
| `val` | value |
| `len` | length |
| `sz` | size |
| `cnt` | count |
| `cur` | cursor |
| `ptr` | pointer |
| `ms` | milliseconds |
| `us` | microseconds |
| `ns` | nanoseconds |
| `sec` | seconds |
| `ts` | timestamp |
| `dt` | delta time |
| `ttl` | time to live |
| `its` | iterations (count) |
| `it` | iteration (current) |
| `nor` | normalized (0.0–1.0 range) |
| `trn` | translation (geometry) |
| `scl` | scale (geometry); also used for width (`n_scl_x`) and height (`n_scl_y`) |
| `rot` | rotation (geometry) |
| `tau` | 2π (full circle in radians) |

**Rule:** Do not invent abbreviations outside this glossary. A long variable name is preferable to an ambiguous abbreviation. `a_o_person__filtered` is a legitimate and preferred name.

### 3.9 Loop and Normalization Pattern

In iterative and mathematical contexts (shaders, geometry, simulations), SPN defines a consistent loop variable pattern:

- `n_its_{domain}` — total iteration count for a given domain
- `n_it_{domain}` — current iteration index (loop variable)
- `n_it_nor_{domain}` — normalized iteration value in [0.0, 1.0]

Example (polygon generation):

```javascript
let n_its_polygon = 5;
let n_its_corner = 3;
let n_tau = Math.PI * 2;

for (let n_it_polygon = 0; n_it_polygon < n_its_polygon; n_it_polygon++) {
  let n_it_nor_polygon = n_it_polygon / n_its_polygon;  // in [0, 1)
  let a_o_point = [];
  let o_trn = {
    n_x: Math.sin(n_it_nor_polygon * n_tau) * n_radius,
    n_y: Math.cos(n_it_nor_polygon * n_tau) * n_radius
  };
  for (let n_it_corner = 0; n_it_corner < n_its_corner; n_it_corner++) {
    let n_it_nor_corner = n_it_corner / n_its_corner;
    a_o_point.push({
      n_x: o_trn.n_x + Math.sin(n_it_nor_corner * n_tau) * n_radius,
      n_y: o_trn.n_y + Math.cos(n_it_nor_corner * n_tau) * n_radius
    });
  }
  a_a_o_point.push(a_o_point);
}
```

The normalized variable `n_it_nor_polygon` is structurally distinct from the raw index. Its prefix communicates that it is a unitless ratio in [0, 1), which is the idiomatic input for trigonometric and parametric calculations.

---

## 4. Discussion

### 4.1 Comparison with TypeScript

TypeScript's type annotations are attached to declarations: `let users: User[] = []`. They are visible in an IDE but stripped at runtime and invisible in code reviews without syntax highlighting. SPN's type information is part of the identifier itself and is visible in any context: terminal output, log files, error messages, code review diffs, and plain text editors.

The two approaches are not mutually exclusive. TypeScript enforces types at compile time; SPN makes types visible at read time. A codebase using both is doubly self-documenting.

### 4.2 Cognitive Load Reduction

Research in program comprehension [6] demonstrates that developers spend more time reading code than writing it. A significant fraction of reading time is spent reconstructing type information: what is the type of this variable? What does this function return? SPN answers both questions at the site of use, not at the declaration site. This reduces the need to jump to definition, hover for tooltips, or consult documentation.

### 4.3 Error Prevention

Several classes of defect become visible before execution when SPN is applied consistently:

- Passing `n_age` where an `s_name` is expected is visually incongruent
- Iterating over `o_user` (an object) with `for...of` is visually flagged — it lacks the `a_` prefix
- A function call `f_render(a_o_user)` where `f_render` expects a single object reads as suspicious — `a_o_user` is an array, not an object
- Assigning the result of `f_b_in_array(...)` to `n_count` is immediately incongruent — a boolean is not a number

These are not caught by a linter. They are caught by human attention, because the notation makes the mismatch visually salient. This is the core claim of Apps Hungarian as described by Spolsky [2]: "The whole point is to make wrong code look wrong."

### 4.4 Universality

SPN is defined independently of any particular language, framework, or toolchain. It applies to:

- Any dynamically typed language (JavaScript, Python, Ruby, PHP, Lua)
- Both frontend and backend code
- Database schemas (Section 3.7)
- Configuration objects
- Mathematical/shader code (Section 3.9)

The only requirement is that the language allows underscores in identifiers — which is true of all major dynamically typed languages.

### 4.5 Limitations

SPN has the following limitations:

1. **Learning curve:** Developers unfamiliar with SPN must learn the prefix grammar before they can read SPN code fluently. This is an upfront cost, but is comparable to the cost of learning any team-specific style guide.
2. **Verbosity:** SPN names are longer than conventional names. `a_o_user__filtered` is longer than `filteredUsers`. This is an intentional trade-off: the name contains more information.
3. **No runtime enforcement:** SPN does not prevent incorrect naming. A developer can name a string variable `n_name` and SPN provides no mechanism to detect this. Enforcement requires code review discipline or a custom linter.
4. **IDE friction:** Many IDE autocompletion and refactoring tools assume camelCase identifiers. SPN uses snake_case with underscore prefixes, which may interact unexpectedly with some refactoring tools.

---

## 5. A Complete Example

The following example demonstrates a non-trivial code fragment with SPN applied throughout:

```javascript
// Factory function: returns an object representing a person
let f_o_person = function(s_name, n_age) {
  return { s_name, n_age };
};

// Array of person objects
let a_o_person = [
  f_o_person('hans', 20),
  f_o_person('gretel', 19),
  f_o_person('ueli', 34),
];

// Function returning a filtered array of person objects
let f_a_o_person__adult = function(a_o_person, n_age__min) {
  return a_o_person.filter(o_person => o_person.n_age >= n_age__min);
};

// Function returning a boolean
let f_b_name__starts_with = function(s_name, s_prefix) {
  return s_name.startsWith(s_prefix);
};

// Function returning a string (formatted label)
let f_s_label__person = function(o_person) {
  return `${o_person.s_name} (age ${o_person.n_age})`;
};

// Usage
let a_o_person__adult = f_a_o_person__adult(a_o_person, 18);
let a_s_label__adult = a_o_person__adult.map(f_s_label__person);
let b_has_hans = a_o_person.some(o => f_b_name__starts_with(o.s_name, 'hans'));
```

Each identifier communicates its structure. A reviewer reading `a_s_label__adult` immediately knows: array of strings, a specific subset (adult labels). No tooltip, no definition jump required.

---

## 6. Conclusion

Structured Prefix Notation (SPN) is a naming methodology that encodes type, cardinality, return type, and semantic qualifier information directly into identifier names. It is:

- **Tooling-free**: requires no compiler, type checker, or IDE extension
- **Universal**: applicable to any dynamically typed language
- **Composable**: compound prefixes form a readable type algebra
- **Self-documenting**: type information is visible in any medium

SPN does not replace static type systems or linters. It complements them. Its primary value is in contexts where full static type checking is unavailable, impractical, or undesired — and in making code readable to humans without mechanical assistance.

The complete specification, including all rules and examples, is available as open-source software under the MIT License at:

> https://github.com/[your-username]/coding_conventions_guidelines_syntax_rules

---

## References

[1] C. Simonyi, "Hungarian Notation," MSDN Library, Microsoft Corporation, 1999.

[2] J. Spolsky, "Making Wrong Code Look Wrong," Joel on Software, May 2005. Available: https://www.joelonsoftware.com/2005/05/11/making-wrong-code-look-wrong/

[3] Microsoft, "TypeScript: JavaScript With Syntax For Types," 2012. Available: https://www.typescriptlang.org/

[4] JSDoc Contributors, "JSDoc Reference," 2021. Available: https://jsdoc.app/

[5] E. Elliott, "Composing Software: An Introduction," Medium / JavaScript Scene, 2017.

[6] T. D. LaToza, G. Venolia, and R. DeLine, "Maintaining mental models: a study of developer work habits," in *Proceedings of the 28th International Conference on Software Engineering (ICSE)*, 2006, pp. 492–501.

---

## Appendix: Quick Reference Card

```
TYPE PREFIXES
  v_    unknown / mixed
  n_    number
  b_    boolean
  s_    string
  o_    object
  a_    array
  f_    function

COMPOUND PREFIXES
  a_n_    array of numbers
  a_s_    array of strings
  a_o_    array of objects
  a_b_    array of booleans
  a_a_    array of arrays

FUNCTION RETURN TYPE (second prefix)
  f_n_    returns number
  f_b_    returns boolean
  f_s_    returns string
  f_o_    returns object (factory)
  f_a_    returns array
  f_      (no second prefix) = void / side-effect

QUALIFIER SEPARATOR
  __      double underscore separates base name from qualifier
  a_o_user__filtered    (not: filtered_users)
  n_idx__start          (not: startIndex)

NAMING ORDER
  Generic → Specific
  n_id__frame      (not: frame_id)
  n_ms__timestamp  (not: timestamp_ms)

DATABASE
  Table name:   a_o_{entity}
  Primary key:  n_id  (integer)  or  s_id  (UUID)
  Foreign key:  n_o_{entity}_n_id

NO PLURAL WORDS
  a_o_user   (not: users)
  a_n_score  (not: scores)
```

---

*First published: 2026. Author: Jonas Immanuel Frey. License: MIT.*


--- 
notes about this. 
why this helps: 
 - programming happens in the brain of the programmer and not only in the source code. so this type of programming is usefull in any language not only dynamically ones. a programmer can see at the first glance only by looking at a variable name what it content could be. 
 - it does not require any specific I DE or additional software to work because the information is embedded into the variable names / into the text itself. you could print this on plain paper and it would work. it is a notation system not a software.
 - it shapes your brain and how you approach problems. especially the unwrapping part where one can for example create multidimensional arrays etc. its a logical visual representation of the content of any variable
 - it creates a global standard. because it elminates unneccessary synonyms like for example 
 - comments are often times meta infromation that is crucial for understanding a software, if information is crucial it has to be embedded into the software . comments however are looked as 'unimportant' by the software . so we have to embedd crucial information into comments and simply get rid of the comments!
 - almost no comments: maintaining comments is not a thing that lazy humans like to do, so they often times just don't. if we embed the comments into the system as a requirement we cannot dodge it and therefore the software will be maintained forcefully. 
 - its already done anyways, just in a worse non standard notation: how often do we come across function names like 'getEventsMdFromTypes' or 'hasTemplateLiteralType' , don't do the words 'get' and 'has' already exactly the thing i am describing? yes they do , but in a non standard and more complex way. 

justified criticism: 
- unneccessary 
   - at lower level of programming this becomes more and more unneccessary. for example in programming where we do not even have strings and almost all varaiables are numbers the 'n_' preifx would be obsolete and annoying
 - webgl/webgpu/shader programming
 - it make variable names very long and unreadable. long variable names is correct . but does source code really need to be as compact as possible? NO! it has to be understandable so that we can work on the same code again a year later and understand it in minutes without having to read a lot of comments to understand what is going on.  
 its not important how compact your code is to be performant, its much more important how maintainable it is to be performant. also storage capacity is no problem since a long time.


more:
programming is not natural language and so we dont have to treat it as such. in the end programmers are going into the state of a procedure and are precomputing the software when they write it. we dont have to try to make the software think like we humans. but we humans try to think how the programm thinks. this is now and will ever be the case. AI models are just a translator for this.
This system is only for real willing to understand the code developers. 
if you really want to use natural language just use LLM's and go vibe coding. 


--- 
conclusion , this system is not about having the exact datatype in the variable name , but the logical type. there are only a hand full of logical types that are all the same across all programming languages, for example 1, 1.23 are numbers. let nums = [1,2,3] and int nums[] = {23,12,0} are simply arrays. thisdict = {"brand": "Ford"} and let d = {n: 2,s: 'a'} are objects. so it is not about having the absolute variable type in the name but only the logical type. 

this system will change how the programmer can interpret the programm and essentially it will change the brain of the programmer , which is the most important. it will create a global standard for high level programming which will boost collaboration productivity of many programmers around the world. 

