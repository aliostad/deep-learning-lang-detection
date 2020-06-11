(**
\---
layout: post
title: "Catamorphisms"
tags: [F#,fold,list,data,types,recursion]
description: "Explains Catamorphisms in F#. That means the purpose of fold and foldBack."
keywords: f#, fsharp, functional, programming, catamorphisms, fold, foldback, foldleft, foldright
\---
*)

(*** hide ***)
module Main
open System.Diagnostics

(**
Up to this point I created various articles about `fold`, in my [Series](/Series) I
also created a category named **Fold (Catamorphisms)** but up till now I didn't explained
how this articles related to each other, or what *Catamorphisms* mean. In this article
I want to talk about the remaining parts.

## Table of Content

<ul class="toc">
  <li><a href="#TheLists">The List</a></li>
    <ul>
      <li><a href="#cata">Introducing Cata</a></li>
      <li><a href="#tail-recursion">Tail Recursion with FoldBack</a></li>
    </ul>
  <li><a href="#binary-trees">Binary Trees</a></li>
    <ul>
      <li><a href="#tree-cata">Cata for Tree</a></li>
      <li><a href="#fold-vs-foldback">Fold vs. FoldBack</a></li>
      <li><a href="#tree-foldback">FoldBack for Tree</a></li>
      <li><a href="#tree-foldback-examples">FoldBack examples</a></li>
      <li><a href="#tree-fold">Fold for Tree</a></li>
      <li><a href="#benchmarking">Some Benchmarking</a></li>
    </ul>
  <li><a href="#markdown">Markdown</a></li>
  <li><a href="#summary">Summary</a></li>
  <li><a href="#further">Further Reading</a></li>
  <li><a href="#comments">Comments</a></li>
</ul>

<a name="TheLists"></a>
## The List

Catamorphisms is a generalization that emerged from the list data-structure. The list
data-structure, how it is found in functional programming, is usually build as a single
linked list. Or to be more precise, it is build as a recursive data type expressed
as a Discriminated Union. That is the reason why
[Algebraic Data-Types]({% post_url 2016-04-26-algebraic-data-types %}) is the very first
entry.

Catamorphisms is the idea that we also implement `fold` and `foldBack` functions for
other discriminated unions besides list. Because of this it is important to first
understand how to define data-types, especially recursive discriminated unions.

To get a better understanding of the concept, this time we implement our own
list type.
*)

type List<'a> =
    | Empty
    | Cons of head:'a * tail:List<'a>

(** I also create additionally constructor functions for each case: *)

let empty    = Empty
let cons h t = Cons(h,t)

(**
<div class="info">
When you wonder about the name <code>Cons</code> this dates back to Lisp. For example
in <a href="http://www.racket-lang.org/">Racket</a> (a Lisp dialect) you can
build a list in such way.

    [lang=racket]
    (define xs (cons 1 (cons 2 (cons 3 empty))))

with the helper functions we defined in F# it almost looks the same.

    let xs = (cons 1 (cons 2 (cons 3 empty)))
</div>

As soon we have any kind of discriminated union, working with such a type follows
a straight pattern. Usually we create a function that matches on our type, and
we must provide code for every case we have. In our list case that means
we must match on the `Empty` case and on the `Cons(h,t)` case and do something
with every case.

But the `Cons` case is special, because it is recursive. So how do we work
with it? We just write a recursive function that recurs! Once you notice
this pattern, writing any kind of function for a recursive discriminated union
becomes easy. First, let's define some example data that we will use from now on:
*)

let l1 = (cons 1 (cons 2 (cons 3 empty)))
let l2 = (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 empty)))))
let l3 = (cons "Hello" (cons " " (cons "World!" empty)))

(** And our first example function `listLength'` *)

let rec listLength' list =
    match list with
    | Empty     -> 0
    | Cons(h,t) -> 1 + (listLength' t)

listLength' l1 // 3
listLength' l2 // 5
listLength' l3 // 3

(**
`listLength'` returns the amount of elements in our list. We just need to handle
both cases to achieve that. If we have an `Empty` case, the length is obvious,
then we have zero elements. If we have `Cons` then we have one element plus
the amount of elements of the remaining list. So we call `listLength' t` to
get it.
*)

let rec listSum' = function
    | Empty     -> 0
    | Cons(h,t) -> h + (listSum' t)

listSum' l1 // 6
listSum' l2 // 15

(**
<div class="info">
The keyword <code>function</code> is a shortcut. Instead of defining the last argument
and Pattern Match on it. We can directly use <code>function</code> that does the same.
This way we can omit the argument, and the <code>match</code> line.
</div

`listSum'` is just a simple *sum* function that adds a list of `int` together.
Probably at this time you start to see that `listLength'` and `listSum'` are
very similar. But let's create some more examples.
*)

let rec listMap' f = function
    | Empty     -> empty
    | Cons(h,t) -> (cons (f h) (listMap' f t))

listMap' (fun x -> x * x) l1 // Cons (1,Cons (4,Cons (9,Empty)))
listMap' (fun x -> x * x) l2 // Cons (1,Cons (4,Cons (9,Cons (16,Cons (25,Empty)))))
listMap' String.length l3    // Cons (5,Cons (1,Cons (6,Empty)))

(**
If you are not used to recursion then this looks a little bit more complicated, but it
is still the same. We expect that `map` runs a function on every element. So what do
we do we do with an empty list? We just return empty. Otherwise we have a single
element `h` and another list `t`. In that case we just call `(f h)` to transform
our `h` element, and how do we transform the remaining list `t`? With `listMap'`,
we only need to `cons` the result of both function calls.

In the next function we want to append an element to a list. Just think for a
moment for yourself how you achieve that. The answer: In the `Cons` case we do nothing, as
this is not the end of the list. Instead we transform an `Empty` with our element
appended.
*)

let rec listSnoc' x = function
    | Empty     -> (cons x empty)
    | Cons(h,t) -> (cons h (listSnoc' x t))

listSnoc' 4 l1        // Cons (1,Cons (2,Cons (3,Cons (4,Empty))))
listSnoc' "Kazom!" l3 // Cons ("Hello",Cons (" ",Cons ("World!",Cons ("Kazom!",Empty))))

(**
Okay, at this point we have enough examples. When we look at our examples, how do we work
with a discriminated union in general? All examples have one recurring pattern that we
do all over again.

1. We must pattern match on every case of the discriminated union.
1. In a non-recursive case we just do whatever needs to be done.
1. In a recursive case like `Cons` we have two data-fields. `h` and `t`. We just work
   with `h` however we need, exactly like a non-recursive case. For the recursive datum
   `t` we just call our function again and recurs.

This is a general pattern how we can work with any discriminated union and provide any
kind of transformation for it. But there can be two problems with this approach:

1. The function feels repetitive, or more important, always rewriting the whole recursion logic
   feels not like Don't-Repeat-Yourself.
1. None of the functions we have, are tail-recursive.

Let's address those problems separately.

<a name="cata"></a>
## Introducing Cata

We already identified our Pattern, so what we usually do is to create a `cata` function
that abstract those repetition. To describe the repetition in one sentence: *A `cata`
function abstracts the recursion over a data-structure.*

We handle the recursion inside of `cata`. `cata` then expects a function to handle
every case. New functions can then be created out of `cata`.

<div class="info">
Abstraction is probably the most important thing in programming. Abstraction is the idea
to see recurring patterns. That means in order to do abstraction we need at least
two things that are very similar (lets name them A and B). We then create a new function
(we name it C) that contains all the similar things between A and B. To handle the differences
we expect the differences to be passed as arguments to C (Often in the form of functions).
After we have C, we rewrite A and B by using C.
</div>

Our first version of `cata` could look like this.
*)

let rec listCata' fEmpty fCons = function
    | Empty     -> fEmpty ()
    | Cons(h,t) -> fCons h (listCata' fEmpty fCons t)

(**
Before we look closer in how it works, let's see how we can create a new length function
defined with `cata` instead.
*)

let listLength'' list = listCata' (fun _ -> 0) (fun h t -> 1 + t) list

listLength'' l1 // 3
listLength'' l2 // 5
listLength'' l3 // 3

(**
`listCata'` just expects two functions. The first functions handles the `Empty` case,
and the second functions handles the `Cons` case. But which arguments do we pass those function
exactly?

We pass the data that is attached to every case to the provided function. As the `Empty` case
don't contain any data, we just call `fEmpty ()` and pass it the **unit** value.

The `Cons` case contains two datums. It contains the *head* and the *tail* element. But we
do not pass the *tail* element directly. Just think about it for a minute. The purpose of
the `cata` function is to abstract the recursion, so the function passed to `cata`
don't need to handle the recursion. If we would pass `t` directly to `fCons` then
`fCons` again would need to handle the recursion. Instead of passing `t`, we pass the
result of the recursive call.

If this transformation looks strange. Actually we have written this kind of code multiple
times already. Let's look again at the first `listLength'` and lets think how we could
transform `listLength'` to the more abstract `listCata'`. When we look at the `Cons` line
It looked like this:

    | Cons(h,t) -> 1 + (listLength' t)

At first we can treat `+` just as a function. Instead of writing it infix between two arguments
we also can write it prefix before its arguments. Then it looks like a normal function call.

    |Cons(h,t) -> (+) 1 (listLength' t)

But in our `listCata'` function we don't want to calculate `(+)`, a hard-coded function, we
want to execute the function the user provided, so we write:

    |Cons(h,t) -> fCons 1 (listLength' t)

Additionally, we don't want to pass `1`. `1` was the replacement for `h` for the length function.
In the abstracted version we just pass `h` to `fCons` and `fCons` decide what to do
with `h`. And the last thing, our function is named `listCata'` so we need to recurs on
`listCata'` not `listLength'`. So we end with:

    |Cons(h,t) -> fCons h (listCata' fEmpty fCons t)

Now let's improve `listCata'` step by step. In the list example this isn't so obvious,
but as we see later when we have other discriminated unions with much more cases and a lot
more recursive cases, then calling a `cata` function can become annoying. We can fix that by
creating a partial applied function before we `match`.
*)

let rec listCata'' fEmpty fCons list =
    let recurs = listCata'' fEmpty fCons
    match list with
    | Empty     -> fEmpty ()
    | Cons(h,t) -> fCons h (recurs t)

(**
In the case of a list this isn't a big improvement, we also cannot use the `function` keyword anymore.
But usually it is a good idea and it makes the code a little bit cleaner, especially when we create
a `cata` function for more complicated discriminated unions.

A second improvement. Actually functions that take `unit` as a value are bad! A pure function that
expects `unit` always only can return the exact same value when it is called. F# is not a
pure-functional language, so theoretically `fEmpty` could do some kind of side-effects and always
return something different. But, I don't encourage such things. A `cata` function is really
the idea to transform a data-structure, there shouldn't be side-effects in it. So instead
of a function, we just expect a direct value that should be used for the `Empty` case. On top,
I name the return type `'State`. This is just a *generic-type*, but by having a more descriptive
name as `'a`, `'b` and so on, it can help in understanding the function signatures. Now our
third `listCata'''` version looks like this:
*)

let rec listCata''' empty fCons list : 'State =
    let recurs = listCata''' empty fCons
    match list with
    | Empty     -> empty
    | Cons(h,t) -> fCons h (recurs t)

(**
When we look at the type-signature of our function the type-signature should look familiar!

    empty:'State -> fCons:('a -> 'State -> 'State) -> list:List<'a> -> 'State

It is nearly the same as `foldBack`! The only difference is that the arguments are in another
order. Let's compare it with the signature of `List.foldBack`:

    folder:('T -> 'State -> 'State) -> list:list<'a> -> state:'State -> 'State

It just expects the `fCons` function first, here named `folder`, then the list to operator
on, and finally the value for the empty case, here just named `state`. So let's also
do this kind of re-order, and finally we end up with our final `listCata` function.
*)

(*** define:listcata ***)
let rec listCata fCons list state : 'State =
    match list with
    | Empty     -> state
    | Cons(h,t) -> fCons h (listCata fCons t state)

(*** include:listcata ***)

(**
Usually, i wouldn't do such a re-order for a `cata` function. We also lost the ability
to use partial application with the `recurs` function. But because our list type is anyway
so small, the re-order doesn't hurt much. Here, it is more an example to show more clearly
the relation that `cata` always has the same behaviour as `foldBack`.

<div class="info">
It is important to understand that it behaves like <code>foldBack</code> not like
<code>fold</code>! I will later go more deeply into this topic and show how <code>fold</code>
and <code>foldBack</code> differ, and why that difference is important.
</div>

Our goal why we created a `cata` function was that we have an abstraction, instead of writing
functions that do the recursion all over by themselves, we now can use `listCata` that abstract
this kind of thing for us. Now, we also should use `listCata` and rewrite all our functions
we created so far by using our abstraction. Here are the final list functions re-written with
`listCata` instead.
*)

let listLength list = listCata (fun x acc -> 1 + acc) list 0
let listSum    list = listCata (fun x acc -> x + acc) list 0
let listMap f  list = listCata (fun x acc -> cons (f x) acc) list empty
let listSnoc x list = listCata (fun x acc -> cons x acc) list (cons x empty)

(** And some examples to see that they work like expected: *)

listLength l1 // 3
listLength l2 // 5
listLength l3 // 3
listSum l1    // 6
listSum l2    // 15
listMap (fun x -> x * x) l1 // Cons (1,Cons (4,Cons (9,Empty)))
listMap (fun x -> x * x) l2 // Cons (1,Cons (4,Cons (9,Cons (16,Cons (25,Empty)))))
listSnoc 4 l1        // Cons (1,Cons (2,Cons (3,Cons (4,Empty))))
listSnoc "Kazoom" l3 // Cons ("Hello",Cons (" ",Cons ("World!",Cons ("Kazoom",Empty))))

(**
Let's summarize what we have done so far:

1. We usually start with a recursively defined discriminated union.
1. When we work with such a type, we need to write recursive functions.
1. Instead of writing functions with recursion directly, we create a `cata` function
   that abstracts the recursion for us.
1. The `cata` function expects a function for every case.
1. Cases without data can be simple values instead of functions.
1. We just pass all data associated with that case to the correct function.
1. We don't pass a datum that is recursive to the functions. Those datum must be
   first passed to `cata` itself.
1. The behaviour of `cata` is the same as `foldBack`.
1. `cata` is not tail-recursive.

<a name="tail-recursion"></a>
## Tail Recursion with FoldBack

At this point we should ask ourselves if we really need tail-recursion. The answer is
not always **yes**. We really should think of the use-cases we have, and what kind
of data-structure we defined. And in the most cases, the answer is **No**.

It is important to understand that we only run into problems with recursion when we
have a data-structure with a linear depth. In our list example, this is the case.
What does it mean exactly? It means that it is pretty normal to have very deep
recursion, usually a case where every additional element increases the depth by one.

For a single linked list this is the case. A list with 10,000 elements will also
create a stack depth of 10,000. So it is important to create tail-recursive
functions. But does that mean all the work on `cata` was wasted?

Absolutely not. We just take `cata` as the starting point and we just try to make
`cata` tail-recursive. The tail recursive version then is what we call `foldBack`.

And this leads to the next articles in my series. Converting functions into
tail-recursive functions is a task on its own that needs proper explanation.

One technique that is most often used is the idea of an accumulator. Instead of
doing a calculation once a function finished, we do the calculations immediately and
pass the result to the next function call. I explain this conept in more detail
in: [From mutable loops to immutability]({% post_url 2016-04-05-mutable-loops-to-immutability %})

Another idea is to use a continuation function, I already provide two articles explaining
the ideas behind this technique. In [Continuations and foldBack]({% post_url 2016-04-16-fold-continuations %})
I explain in deep how a tail-recursive `foldBack` works. And in my article
[CPS fold -- fold with early exit]({% post_url 2016-05-07-cps-fold %}) I explain
the idea of a continuation function a second time with `fold`.

But it doesn't mean both ideas are interchangeable. When we directly want to create
a tail-recursive `foldBack` function then we need to use the continuation-function
approach. We cannot create a tail-recursive `foldBack` with an accumulator approach.

As I already have three articles on those topics I don't go into much further
detail, so I just provide a quick explanation. We just start with the `cata` function.
In `cata` we see something like this:

    | Cons(h,t) -> fCons h (listCata fCons t state)

So, the second argument to `fCons` is a recursive call. Let's shortly rethink what it does.
It calls the function and it will return some kind of data, this data is then passed to
the `fCons` function as the second argument. With the continuation approach we just assume
we already have that data. So we just replace every recursive call with some variable
we don't have yet.

    | Cons(h,t) -> fCons h racc

Sure, that wouldn't compile now, because we didn't define `racc` anywhere, so we wrap it
inside a function, that functions then becomes `racc` somewhere in the future.

    | Cons(h,t) -> (fun racc -> fCons h racc)

But that isn't anything, we still need to somehow traverse our list, and call that function.
In short, we change our previously defined `cata` all in all to something like that.
Let's see the `cata` and `foldBack` directly to each other.
*)

(*** include:listcata ***)

let listFoldBack fCons list state : 'State =
    let rec loop list cont =
        match list with
        | Empty     -> cont state
        | Cons(h,t) -> loop t (fun racc -> cont (fCons h racc))
    loop list id

(**
The implementation of our list functions also didn't change at all. Instead of
`listCata` they just use `listFoldBack`.

    let listLength list = listFoldBack (fun x acc -> 1 + acc) list 0
    let listSum    list = listFoldBack (fun x acc -> x + acc) list 0
    let listMap f  list = listFoldBack (fun x acc -> cons (f x) acc) list empty
    let listSnoc x list = listFoldBack (fun x acc -> cons x acc) list (cons x empty)

<a name="binary-trees"></a>
## Binary Trees

Up so far we explored the concept of the `cata` function only with the list and when we make that
function tail-recursive we call it `foldBack`. But as said before, Catamorphisms are a generalization.
That means, the concept of writing a `cata` function and creating tail-recursive version out of it
should also be done for other discriminated unions, not just for a list.

For the next example we will look at a binary tree. A binary tree is quite interesting
because it is very similar to a list. But let's see that in more detail:
*)

type Tree<'a> =
    | Leaf
    | Node of 'a * Tree<'a> * Tree<'a>

(** Once again I also introduce some helper functions to create the cases. *)

let node x l r = Node(x,l,r)
let endNode x  = node x Leaf Leaf

(** And a simple tree that contains the numbers 1 to 7 ordered. *)

let tree =
    (node 4
        (node 2 (endNode 1) (endNode 3))
        (node 6 (endNode 5) (endNode 7)))

(**
So, why is a Tree similar to a list? Because the definition is nearly the same. If you look closer
you see that a tree has two cases exactly like a list has. `Leaf` marks the end exactly like
`Empty` did for the list. Instead of `Cons` with two datums, we have `Node` with three datums.

The only difference between a list and a binary tree is that every element in a list only has one
child, while a binary tree has two child's. Those child's are often named *Left* and *Right*.
That's also the reason why I named the variables `l` and `r` in the functions.

<a name="tree-cata"></a>
## Cata for Tree

So, let's start by creating a `cata` function for our tree.
*)

let rec treeCata' fLeaf fNode tree =
    match tree with
    | Leaf        -> fLeaf ()
    | Node(x,l,r) -> fNode x (treeCata' fLeaf fNode l) (treeCata' fLeaf fNode r)

(**
We started by just turning every case into a function. This time we name them `fLeaf`
and `fNode`, after the cases. The pattern is the same. The `Leaf` case has no data, so
we just call `fLeaf` with the unit value `()`. We should remember that we can eliminate
the function in a next version.

The difference in the `Node` case to the previous `Cons` case in the list is, that we have
three datums. So `fNode` will also receive three arguments. But the second and third
argument is a tree again. So before we pass those, we need to recursively call `treeCata'`
on those trees again.

The two recursive calls looks quite long, so we first create a partial applied `recurs`
function. Now we have:
*)

let rec treeCata'' fLeaf fNode tree =
    let recurs = treeCata'' fLeaf fNode
    match tree with
    | Leaf        -> fLeaf ()
    | Node(x,l,r) -> fNode x (recurs l) (recurs r)

(** Next, we eliminate the function for the leaf case. *)

let rec treeCata''' leaf fNode tree =
    let recurs = treeCata''' leaf fNode
    match tree with
    | Leaf        -> leaf
    | Node(x,l,r) -> fNode x (recurs l) (recurs r)

(**
As a tree also only has two cases, and one of them is not a function, we already see that
we already have a signature like `foldBack`. So let's re-order the function arguments.
Previously I said we loose the ability for the partial applied `recurs` function. But
we still can write a `recurs` function. We only need to know which argument changes.

In the code above you see that we call `(recurs l)` and `(recurs r)`. So we only want
to pass the next tree it should work on. So we create a `recurs` function that only
expects the remaining tree. All in one, we now end with:
*)

(*** define:treecata ***)
let rec treeCata folder tree acc : 'State =
    let recurs t = treeCata folder t acc
    match tree with
    | Leaf        -> acc
    | Node(x,l,r) -> folder x (recurs l) (recurs r)

(*** include:treecata ***)

(** Let's create a `length`, `sum` and a `map` function with our `cata` function. *)

let treeLength tree = treeCata (fun x l r -> 1 + l + r) tree 0
let treeSum    tree = treeCata (fun x l r -> x + l + r) tree 0
let treeMap f  tree = treeCata (fun x l r -> node (f x) l r) tree Leaf

// tree was:
// (node 4
//   (node 2 (endNode 1) (endNode 3))
//   (node 6 (endNode 5) (endNode 7)))

treeLength tree // 7
treeSum tree    // 28
treeMap (fun x -> x * x) tree
// (node 16
//   (node 4  (endNode 1)  (endNode 9))
//   (node 36 (endNode 25) (endNode 49)))

(**
<a name="fold-vs-foldback"></a>
## Fold vs. FoldBack

Before we talk about how to turn `cata` into a tail-recursive function we should talk
about the difference between `fold` and `foldBack`. I explained that if we turn `cata`
into a tail-recursive function we get back `foldBack`. If I mention `cata` or `foldBack`
i use the terms interchangeable. The fact that one is tail-recursive and the other not,
is not important right now, it is more important how they behave.

But it opens up an important question. When we forget for a moment the mechanical
implementation to create the `cata` function. How do we know how to implement `fold` and
`foldBack` and how do we know how they should behave? Or what is anyway the exact
behaviour of `fold` and `foldBack`?

If the question is unclear, let's look again at a list and lets see how `fold`
and `foldBack` behaves.

![Single-Linked list](/images/2016/catamorphisms/list.svg)

We can visualize a single-linked list like boxes, and every box points to the next element
in the list. Until the last element points to the end `Empty`. In the visualization above
represented as `/`.

The functions `fold` and `foldBack` are also often named `foldLeft` and `foldRight` in
other languages. They are named like this, because they describe how a list will be
traversed. `fold` (or `foldLeft`) traverses a list from left-to-right, while `foldBack`
(or `foldRight`) traverses the list from right-to-left.

So when we use `fold` the function we provide `fold` first sees `1`, then `2`, then `3`
and so on. While when using `foldBack` we first encounter `5`, then `4`, then `3` and so
on. This is easy to understand.

But how do they anyway translate to something like a binary tree? Our `tree` that we used
so far looks like this:

<div style="width:50%;margin: 0 auto">
<img src="/images/2016/catamorphisms/tree.svg" alt="Binary Tree" />
</div>

When we think of `fold` as left-to-right and `foldBack` as right-to-left, how do we translate
that to a tree? The problem we have, there doesn't exists only one way to traverse a tree.
[There are many way to traverse a tree][tree-traversal], and even then the question
is which traversal we identify as *left* or *right*.

Up so far I made it easy, as I just said that `cata` is `foldBack` without further describing
the idea behind it why that is so. So let's re-look at `fold` and `foldBack` for the list
and let's see if we can describe the operation slightly different.

Previously we already noticed that a list and a binary tree are very similar. We can think of
a list that contains one-element and a one recursive argument, or one-child. A binary
tree on the other hand is one-element and two-child's. When we visualize a tree we usually
show the deeper (recursive) layers underneath an element. In the above visualization we
have `4` and underneath it `2` and `6`. But we also can think of a list in such a way.

<div style="width:25%;margin:0 auto">
<img src="/images/2016/catamorphisms/list_as_tree.svg" alt="List as Tree" />
</div>

We have `1` and we have the recursive child `2`. Instead of thinking of traversing a list
from left-to-right or right-to-left, we look at the **folder-function**, and we describe
what the **folder-function** sees. So when we sum all elements in a list like this:
*)

List.fold (fun acc x -> acc + x) 0 [1;2;3;4]

(**
What does the **folder-function** `(fun acc x -> acc + x)` sees exactly? Let's say `fold`
is at the element `1`, which values do we have?

We have `0` and `1`. Or more precisely, we get the accumulator so-far, and one-element
of our data-structure. What do we see when `fold` is at element `2`? We get `1` and `2`.
Once again we get the accumulator so far, and the current element.

Generally speaking, with `fold` we get the current element and an accumulator that
is the combination of all the things we already have seen. When `fold` hits `3`,
then we get `3` and `3`. The first `3` the *accumulator* was computed by the already seen
elements `1` and `2` (1 + 2).

We also can think of `fold` as looping. Because in looping we usually start with some
mutable initial value, and when we loop over a data-structure we combine the current element
with some outer element.
*)

let mutable acc = 0
for x in [1..4] do
    acc <- acc + x

(** But when we look at `foldBack` it behaves differently. When we write: *)

List.foldBack (fun x acc -> x + acc) [1;2;3;4] 0

(**
We get the same result, because the order of `+` operation doesn't matter. But the behaviour
is different. When our **folder-function** hits the element `1`, which data, do we get?

We get `1` and `9`. `1` is the current element. But what is `9`? `9` is the result of the combination
of the child we have at this point. In `foldBack` we don't get an accumulation of the things
we already have seen, we get the combination of the things we didn't have seen so far!

With `foldBack` we get the current element, and the combination of all its child elements. When
we hit `2` for example, then we just see `2` and `7`. Because the child of `2` is `3 + 4`. But
we didn't see `1`, because `1` is on top of `2`.

All in one we can say that `foldBack` is a *structure-preserving* function. We not get
the current element and an accumulation so far, we get the current element including one
value for each child. And with a tree this distinction becomes more clear. When we look again
at our tree.

<div style="width:50%;margin: 0 auto">
<img src="/images/2016/catamorphisms/tree.svg" alt="Binary Tree" />
</div>

Which arguments does the *folder-functions* sees when we are at the top element `4`? We see
`4` the current element, `6` for the left child (1 + 2 + 3) and `18` (5 + 6 + 7) for the
*right-child*. In `foldBack` we always get the exact same amount of arguments a case has.

The definition of `Node` was `Node of 'a * Tree<'a> * Tree<'a>` so we also get three
arguments in the folder function. But instead of two trees, we already get the result
of them. That means, while `fold` is like iteration/looping, `foldBack` is like recursion.

Consider how we would write a recursive `sum` function without `cata`, the `Node` case
would look something like that.

    | Node(x,l,r) -> x + (sum l) + (sum r)

As `(sum l)` is a function call it just starts calculating a value, but when it returns
it contains the sum of the left child. So once `(sum l)` and `(sum r)` completes we have
a line like `x + y + z`. We just add three values together. `foldBack` is exactly that
behaviour. `foldBack` always works like recursion. That is why `cata` is always
like `foldBack`. `foldBack` only ensures that we have tail-recursion.

So how does `fold` for a tree look like? In fact the *folder-function* only sees **two**
arguments not **three**. Why is that so? Because `fold` only sees the things it already
have seen.

The `Node` case only contains a single non-recursive datum. That means the `fold` function only
sees an accumulator so far and all the current non-recursive elements. For our specified binary
tree that are only two arguments.

But how does `fold` traverse a tree? The answer is, it doesn't matter. The purpose
of `fold` is not to provide a specific order. The purpose of `fold` is just to visit
every element. `fold` is ideal for things that behave like [Monoids][monoids]. `fold`
is in general a good choice if the operation you have doesn't depend on the structure
itself only on the elements itself.

You also can compare `fold` with `foreach` in C#. With `foreach` in C#, you just iterate
through a data-structure. You also can iterate through a dictionary, and you get the
*key* and *value* of every element, but you don't get any information of the structure
of the Dictionary itself. When you loop over a dictionary with foreach you just expect
to somehow get all the values, but you don't expect a particular order.

But if you need the additional information of the structure and somehow work with the
full tree, then you must use `foldBack`. Because of that, `foldBack` is more powerful than
`fold` as you always can use `foldBack` instead of `fold`. But the reverse is not true.

<a name="tree-foldback"></a>
## FoldBack for Tree

I will implement `foldBack` with the Continuation approach, but I don't go into
much detail how the implementation works exactly, you can read more of those
details here:

* [Continuations and foldBack]({% post_url 2016-04-16-fold-continuations %})
* [CPS Fold -- fold with early exit]({% post_url 2016-05-07-cps-fold %})

First, we look again at `cata`.
*)

(*** include:treecata ***)

(**
Instead of a recursive `treeCata` we will create an inner `loop` function that
is used for recursion.

    let treeCata folder tree acc =
        let rec loop t =
            match t with
            | Leaf        -> acc
            | Node(x,l,r) -> folder x (loop l) (loop r)
        loop tree

As we now have an inner recursive loop we also need to explicitly
start the recursion with `loop tree`. In the next step we expand the
`Node` case and remove the nested `loop` calls and put each on its own line.

    let treeCata folder tree acc =
        let rec loop t =
            match t with
            | Leaf        -> acc
            | Node(x,l,r) ->
                let lacc = loop l
                let racc = loop r
                folder x lacc racc
        loop tree

Finally, we add `cont` (the continuation) to the `loop` function and
rename the function to `treeFoldBack`.
*)

let treeFoldBack folder tree acc : 'State =
    let rec loop t cont =
        match t with
        | Leaf        -> cont acc
        | Node(x,l,r) ->
            loop l (fun lacc ->
            loop r (fun racc ->
                cont (folder x lacc racc)
                ))
    loop tree id
(**
Before, we had code like:

    let lacc = loop l

it was recursive and it meant: Recurse on `loop l`. Somewhere in the future
(after many more recursive calls) it will return a result that we save in `lacc`.

Then we executed:

    let racc = loop r

It was recursive again and after many more recursive calls we got the result
and saved it in `racc`. But all of this is not tail-recursive. The new
`treeFoldBack` function really only has one function call.

    loop l (fun ...)

The idea of continuations is like this: Please execute `loop l callback`. When
you finished calculating the result, please call the `callback` function
and pass it the result. *Callback* or *Continuation* really means the same.

But in this case we call `loop` that is in tail position. So we end up with a
tail-recursive function.

<a name="tree-foldback-examples"></a>
## FoldBack examples

Instead let's focus on things we can do with `foldBack` but not with `fold`. As `foldBack`
preserves the structure, we can actually very easily convert a Tree into a string representation.

We just convert a `Leaf` node into the String `"Leaf"`, and a `Node` will be converted with
`Node(%d, %s, %s)` into a string. Because we get the string results instead of the recursive
values, this kind of task is pretty easy.
*)

treeCata     (sprintf "Node(%d, %s, %s)") tree "Leaf"
treeFoldBack (sprintf "Node(%d, %s, %s)") tree "Leaf"

(**
`treeCata` and `foldBack` both return the same string:
`"Node(4, Node(2, Node(1, Leaf, Leaf), Node(3, Leaf, Leaf)), Node(6, Node(5, Leaf, Leaf), Node(7, Leaf, Leaf)))"`

I used the `tree` variable so far as a binary search tree. That means it is ordered. The left child's are
smaller, the right child's are bigger then the current element. We also can create an ordered list from
our tree. A Leaf node must be converted into an empty list. Otherwise we just need to concat the left,
current and the right node.
*)

let ordered = treeFoldBack (fun x l r -> l @ [x] @ r) tree [] // [1;2;3;4;5;6;7]

(** or any other order we like: *)

let reversed  = treeFoldBack (fun x l r -> r @ [x] @ l) tree [] // [7;6;5;4;3;2;1]
let preOrder  = treeFoldBack (fun x l r -> [x] @ l @ r) tree [] // [4;2;1;3;6;5;7]
let postOrder = treeFoldBack (fun x l r -> l @ r @ [x]) tree [] // [1;3;2;5;7;6;4]

(**
Let's turn the Tree into Lisp code. In Lisp a tree is just represented as a list with
tree elements. The first element is the current node, the second and third element represent
the left and right node, and are just lists themselves. The Leaf node is represented as the
empty list.
*)

"(quote " + treeFoldBack (sprintf "(%d %s %s)") tree "empty" + ")"
// "(quote (4 (2 (1 empty empty) (3 empty empty)) (6 (5 empty empty) (7 empty empty))))"

(**
Let's test it in Racket.

    [lang=racket]
    (define tree (quote (4 (2 (1 empty empty) (3 empty empty)) (6 (5 empty empty) (7 empty empty)))))
    (define (left tree)  (car (cdr tree)))
    (define (right tree) (car (cdr (cdr tree))))
    (define (datum tree) (car tree))

and in the REPL:

    [lang=console]
    > (datum (left (left tree)))
    1
    > (datum (left (right tree)))
    5

Nice, this is correct. For the last example let's look again at our example tree:

<div style="width:50%;margin: 0 auto">
<img src="/images/2016/catamorphisms/tree.svg" alt="Binary Tree" />
</div>

Let's say we want to create a path to a specific element. For example when we search for `5`, we want
the steps to find `5`. When we start at `4` we first must go right, and then Left. So we want "Right Left"
as a result. When we search for `1` we get "Left Left" and so on.
*)

let path search tree =
    let leaf = (false, [])
    let node x (lb,lp) (rb,rp) =
        if x = search then
            (true, [])
        elif lb = true then
            (true, "Left" :: lp)
        elif rb = true then
            (true, "Right" :: rp)
        else
            (false, [])
    let path = treeFoldBack node tree leaf
    match path with
    | (true, []) -> "First element"
    | (true, p)  -> String.concat " " p
    | (false, _) -> "Not in Tree"

path 1 tree // "Left Left"
path 2 tree // "Left"
path 3 tree // "Left Right"
path 4 tree // "First Element"
path 5 tree // "Right Left"
path 9 tree // "Not in Tree"

(**
In the solution I just transform every node into a tuple that contains two informations. A boolean that
contains the information if the child contains the searched element. And when it is `true` the
node above prepend either `"Left"` or `"Right"` to the list. As an example, when we search for
`5` we get the following transformations:

![Tree with path to 5](/images/2016/catamorphisms/tree_path_5.svg)

<a name="tree-fold"></a>
## Fold for Tree

At last we want to look at `fold`. As we learned so far, we don't need to implement a particular
tree traversal order. For `fold` it is only important that we visit every node and we treat an
accumulator through the calculation. For implementing `fold` we should just pick the easiest
or fastest way we can come up with.

Up so far, including the other blog posts, I showed two ways how to achieve tail-recursion. Either
way through an accumulator or through a continuation function. But both ideas don't work
with our tree. The problem is that we don't just have a simple calculation that we can forward
as an accumulator, we always must traverse two child's for every node.

The solution to fix that is that we manage the stack ourselves. This is the typical solution
how languages without proper tail-call-optimization handles recursion. But in the F#
case we don't need to switch completely to looping. We just make the stack part as an additional
value on the recursive inner loop function. We also could say, we use two accumulators. One
for the value we computed so far, and another that keeps track of task we still need to do later.

So here is the idea. At first we identify what we actually need to do in the `Node` case.
And they are three things we need to do:

1. Process the current element
1. Recurs on the left child
1. Recurs on the right child

We should pick a order of the operation so that only one task remains open. And this task is pushed
onto a stack that can be later processed. One way to achieve that is.

1. We process the current element
1. We put the right child onto the stack
1. We loop on the left child

Let's give it a first try:
*)

let treeFold' folder acc tree =
    let rec loop acc stack tree =
        match tree with
        | Leaf        -> acc
        | Node(x,l,r) -> loop (folder acc x) (r :: stack) l
    loop acc [] tree

(** Let's test it: *)

treeFold' (fun acc x -> printf "%d " x) () tree // 4 2 1

(**
Okay, that's not quite right, but I wrote it in this way so we can discuss what happens. This makes it
easier to understand the full solution. At first, if you find the short `Node` case hard to understand,
you can expand it. The line:

    loop (folder acc x) (r :: stack) l

is the same as:

    let newAcc   = folder acc x
    let newStack = r :: stack
    loop newAcc newStack l

But all in one, here are the things that are happening:

1. We enter the tree.
1. We process element `4`, by printing it `(folder acc x)`
1. The right child of `4` is added to the stack `r :: stack`
1. We loop on the left-child
1. We process element `2`, by printing it
1. The right child of `2` is added to the stack
1. We loop on the left-child
1. We process element `1`, by printing it
1. The right child of `1` is added to the stack (a Leaf)
1. We loop on the left-child
1. We hit a Leaf, and we return `acc`.

So what are we missing? Sure, we forgot to process the *right-child's*. We put them all
onto the stack, but we never look at them. So what we need to do is to extend the `Leaf` case.
Instead of immediately returning `acc`, we first need to check if there are pending
trees in the `stack`. If yes, we need to loop on those. Only if the `stack` is empty
we can return `acc`. So our final `treeFold` looks like this:
*)

let treeFold folder acc tree =
    let rec loop acc stack tree =
        match tree with
        | Leaf ->
            match stack with
            | []          -> acc
            | tree::stack -> loop acc stack tree
        | Node(x,l,r) -> loop (folder acc x) (r :: stack) l
    loop acc [] tree

(** Now we get all numbers printed. *)

treeFold (fun acc x -> printf "%d " x) () tree // 4 2 1 3 6 5 7

(**
And if you noticed, this kind of tree-traversal is a pre-order tree traversal. But it is only pre-order
traversal by accident. I just thought of an easy way to traverse so we need to put as few things as possible
onto the `stack` variable. Someone should not expect a specific tree traversal order for `fold`.

<a name="benchmarking"></a>
## Some Benchmarking

I think some simple benchmarks are quite good. At first, we always talk about tail-recursion and
I provided ways to achieve it, but never looked at performance. And there are two things to say here.

First, tail-recursion is not about performance. Yes, sometimes it also improves performance, but the
main point of tail-recursion is that we don't end up with stack overflows. We first care for
correctness, only then comes speed. If you think otherwise, then answer me the following question:
What exactly do we get out of a function that is theoretically fast, but practically we cannot
execute it because it crashes with a stack overflow? So the main point of tail-recursion is
Correctness, that it is *sometimes* faster is more an additional benefit.

Second, tail-recursion with a continuation approach how i used it with `foldBack` is usually
**slower** than pure recursion!

All of those are important. At first, you shouldn't implement tail-recursion just because someone
told you it is better or faster. It not only can be slower, it also can be harder to understand
and to maintain. So you really should ask yourself if you really need tail-recursion. And
for a binary tree this question is already legit. If you create a binary tree that always balance
itself, then you will less likely run into any kind of problems with a non tail-recursive `cata`
function.

With a stack depth of 1 you can handle two values (empty and one value), with a stack depth
of 2 you can handle 4 values. 3 is already 8 values. So the amount of values doubles by just
increasing the depth by one. With a stack depth of 32, what is just peanuts, you already
can handle 4.294.967.296 values. Before you run into problems with the stack depth you run
into completely other problems! Even if you just save 32-bit integers just the integers alone
already need 16 GiB of memory, and that does not include the `Node(x,l,r)` objects that also
consumes memory. So you should ask yourself if you really need a `fold` or `foldback` function
that are harder to develop and probably even can be slower!

But let's see some benchmarks. First I create some helper functions for the creation of some trees.
*)

let createTree builder init depth =
    let rec loop count tree =
        if   count < depth
        then loop (count+1) (builder tree)
        else tree
    loop 1 init

let createLeftTree  = createTree (fun tree -> node 1 tree Leaf) (endNode 1)
let createRightTree = createTree (fun tree -> node 1 Leaf tree) (endNode 1)
let createBalanced  = createTree (fun tree -> node 1 tree tree) (endNode 1)

(** So let's create some small trees with 10K nodes. *)

let smallL = createLeftTree  10000
let smallR = createRightTree 10000

(**
Those trees are not balanced, but they can still be handled by `cata` on my machine. But just benchmarking
one call is still too fast, so I create a `bench` function that calls some code a specific amount of time.
*)

let bench times f =
    let sw = Stopwatch.StartNew()
    for i in 1 .. times do
        f () |> ignore
    sw.Stop()
    printfn "Timing: %O" sw.Elapsed

(**
So, when we sum up every 10.000 nodes with `treeCata` and do that 10.000 times, which timings do we
get for `treeCata` and `foldBack`? I run every `bench` line twice.
*)

bench 10000 (fun _ -> treeCata (fun x l r -> x + l + r) smallL 0)
// Real: 00:00:04.290, CPU: 00:00:04.296, GC gen0: 0, gen1: 0, gen2: 0
// Real: 00:00:04.292, CPU: 00:00:04.265, GC gen0: 0, gen1: 0, gen2: 0

bench 10000 (fun _ -> treeCata (fun x l r -> x + l + r) smallR 0)
// Real: 00:00:04.145, CPU: 00:00:04.140, GC gen0: 0, gen1: 0, gen2: 0
// Real: 00:00:04.144, CPU: 00:00:04.140, GC gen0: 0, gen1: 0, gen2: 0

bench 10000 (fun _ -> treeFoldBack (fun x l r -> x + l + r) smallL 0)
// Real: 00:00:07.518, CPU: 00:00:07.546, GC gen0: 1617, gen1: 1616, gen2: 1
// Real: 00:00:07.448, CPU: 00:00:07.437, GC gen0: 1621, gen1: 1621, gen2: 0

bench 10000 (fun _ -> treeFoldBack (fun x l r -> x + l + r) smallR 0)
// Real: 00:00:08.076, CPU: 00:00:08.078, GC gen0: 1628, gen1: 1628, gen2: 0
// Real: 00:00:08.146, CPU: 00:00:08.140, GC gen0: 1625, gen1: 1625, gen2: 0

(**
So overall, the `foldBack` result are disastrous. At first, creating a lot of continuation
functions creates a lot of garbage, all those closure functions needs to be managed on
the heap. As a result the garbage collector runs quite often. 1600 gen0 and 1600 gen1 clean-ups!
Overall `foldBack` is tail-recursive, but takes the double of time to finish compared
to the `cata` functions. On top, the `cata` functions trigger not a single garbage collection
clean-up, that is probably also the reason why they are faster.

But we also should consider `treeFold`. Actually just summing up the nodes is also a task
that can be done by `treeFold`, so how fast is `treeFold`?
*)

bench 10000 (fun _ -> treeFold (+) 0 smallL)
// Real: 00:00:02.882, CPU: 00:00:02.890, GC gen0: 508, gen1: 508, gen2: 0
// Real: 00:00:02.864, CPU: 00:00:02.859, GC gen0: 508, gen1: 508, gen2: 0

bench 10000 (fun _ -> treeFold (+) 0 smallR)
// Real: 00:00:02.830, CPU: 00:00:02.812, GC gen0: 508, gen1: 508, gen2: 0
// Real: 00:00:02.824, CPU: 00:00:02.828, GC gen0: 509, gen1: 509, gen2: 0

(**
Those results are quite interesting. They are faster as `treeCata` and `treeFoldback`. I
expected that it is faster as `foldBack`, because just handling a stack of trees should
be way more efficient as handling a lot of closure functions. But even the fact that
they still trigger quite a lot of garbage clean-ups, it is still nearly twice as fast
as the `cata` function! By the way, we can even get the amount of GCs down. Actually
there is no point in using an immutable stack. We also can use an mutable stack
in `fold`. This makes the implementation a little bit harder again.
*)

let treeFoldStack folder acc tree =
    let stack = System.Collections.Generic.Stack<_>()
    let rec loop acc tree =
        match tree with
        | Leaf ->
            if   stack.Count > 0
            then loop acc (stack.Pop())
            else acc
        | Node(x,l,r) ->
            stack.Push r
            loop (folder acc x) l
    loop acc tree

(** Let's see how it compares to `treeFold` *)

bench 10000 (fun _ -> treeFoldStack (+) 0 smallL)
// Real: 00:00:04.018, CPU: 00:00:04.015, GC gen0: 416, gen1: 416, gen2: 0
// Real: 00:00:04.029, CPU: 00:00:04.015, GC gen0: 416, gen1: 416, gen2: 0

bench 10000 (fun _ -> treeFoldStack (+) 0 smallR)
// Real: 00:00:04.000, CPU: 00:00:03.984, GC gen0: 0, gen1: 0, gen2: 0
// Real: 00:00:03.994, CPU: 00:00:03.953, GC gen0: 0, gen1: 0, gen2: 0

(**
Also, this is not what I expected, it becomes slower to the speed of the `cata` function. And
in the `smallL` case it still triggers a lot of GC clean-ups. On a tree only with right nodes
we don't have any clean-ups because we don't save anything in the stack. It is still quite interesting
to see that the timing with and without GC clean-ups are the same. So it seems the GC clean-ups are
so fast that they overall don't matter at all for the overall timing. At least on my machine.

So, how are the timings for really big but balanced trees? A balanced tree with a depth
of 25 contains 33.554.431 entries. How are the timings here?
*)

let balanced25 = createBalanced 25
let sum x l r = x + l + r

treeCata sum balanced25 0
// Real: 00:00:01.242, CPU: 00:00:01.234, GC gen0: 0, gen1: 0, gen2: 0
// Real: 00:00:01.239, CPU: 00:00:01.218, GC gen0: 0, gen1: 0, gen2: 0

treeFoldBack sum balanced25 0
// Real: 00:00:02.501, CPU: 00:00:02.500, GC gen0: 556, gen1: 555, gen2: 1
// Real: 00:00:02.451, CPU: 00:00:02.453, GC gen0: 555, gen1: 555, gen2: 0

treeFold (+) 0 balanced25
// Real: 00:00:01.000, CPU: 00:00:00.968, GC gen0: 171, gen1: 171, gen2: 0
// Real: 00:00:01.000, CPU: 00:00:01.000, GC gen0: 171, gen1: 171, gen2: 0

treeFoldStack (+) 0 balanced25
// Real: 00:00:01.418, CPU: 00:00:01.421, GC gen0: 0, gen1: 0, gen2: 0
// Real: 00:00:01.412, CPU: 00:00:01.406, GC gen0: 0, gen1: 0, gen2: 0

(**
All in one, the `cata` function overall is usually the easiest to implement, in its performance it is
also quite good, at least better as a naive implementation with continuation functions. Because
most memory get handled by the stack, it also don't causes garbage collection.

An implementation with a mutable stack also can be efficient in terms of garbage collection, but at least
on my machine it is still slower compared to the pure recursive version.

As an overall result you shouldn't abandon the `cata` function, just because you fear that
non tail-recursive functions are automatically slower. Usually they are very easy to implement
and the speed is quite good. Instead you should consider if you expect problems with the stack depth.
When you create balanced trees this is quite uncommon that you run into problems with the stack depth.

But with a type like a list that has linear recursion, where every element increases the stack depth
by one, you should consider more time in writing tail-recursive functions.

<a name="markdown"></a>
## Markdown

Up so far I only talked about lists and binary trees, but both types basically contain everything
you need to know. Any other type is basically just repetition of what was said so far. As a last
example I want to show the small Markdown example that I created in the
[Algebraic-Data Types][algebraic] article. It is not a full description of the Markdown definition,
but is good enough as an example.
*)

type Markdown =
    | NewLine
    | Literal    of string
    | Bold       of string
    | InlineCode of string
    | Block      of Markdown list

(**
Our Markdown definition contains 4 non-recursive cases and one recursive case. We just did what we did
so far. We create a `cata` function that expects a function for every case. As `NewLine` contains no
data, we can just expect a plain value.

The recursive element is quite different from what we have seen so far. Instead of a single recursive
element we have a list of recursive elements. But that shouldn't be much of a difference. We just
call the `recurs` function for every element in the list with `List.map`. Overall we end up
with the following `cata` function.
*)

let rec markCata newline literal bold code block doc : 'r =
    let recurs = markCata newline literal bold code block
    match doc with
    | NewLine        -> newline
    | Literal    str -> literal str
    | Bold       str -> bold str
    | InlineCode str -> code str
    | Block      doc -> block (List.map recurs doc)

(**
Do we need a `fold` or `foldBack`? Well, I don't know you, but I don't think we ever see a markdown
document that has some ten thousand of nested blocks so recursion becomes a problem. Probably even
a nesting more than 5 is already rare. So overall I think writing `fold` and `foldBack` is probably
just a waste of time. So let's once again write a function that turns a markdown document into
HTML.
*)

let produceHtml =
    let escape         = System.Web.HttpUtility.HtmlEncode
    let wrap tag str   = sprintf "<%s>%s</%s>" tag str tag
    let wrapEscape tag = wrap tag << escape
    markCata "<br/>" escape (wrapEscape "strong") (wrapEscape "code") (wrap "p" << String.concat "")

(**
Probably there isn't much to say here. The `escape` function correctly escapes HTML characters.
As I always need to wrap string into tags I just created a `wrap` function that I can pass a
*tag* and a *string* that does that. But I need a version that escapes the string, and one that
doesn't. The last one is important for a recursive case. Because we don't want to escape the HTML
tags itself. The arguments of the `wrap` and `wrapEscape` function are chosen in a way so I can
use currying, so I don't need to create a lot of lambda expressions.
*)

let document =
    Block [
        Literal "Hello"; Bold "World!"; NewLine
        Literal "InlineCode of"; InlineCode "let sum x y = x + y"; NewLine
        Block [
            Literal "This is the end with some <html>that should be escaped</html>"
        ]
    ]

produceHtml document
// "<p>Hello<strong>World!</strong><br/>InlineCode of<code>let sum x y = x + y</code><br/>
//  <p>This is the end with some &lt;html&gt;that should be escaped&lt;/html&gt;</p></p>"

(**
<a name="summary"></a>
## Summary

We have seen how to create a `cata` function, and we learned that `foldBack` is just `cata`
written tail-recursive. For the `fold` implementation of the tree, i choosed another way to
create a tail-recursive function that manages the stack directly.

In benchmarking we also saw that the last way is also quite better in terms of speed and
garbage collection compared to a continuation approach. With a mutable stack we can even further
eliminate garbage collection cleanup.

But overall we have seen that `cata` is very fast and it doesn't mean that tail-recursion
is automatically better or faster.

<a name="further"></a>
## Further Reading

* [Recursive types and folds][scott-fold]
* [Catamorphisms, part one][cata-one]

<a name="comments"></a>

[scott-fold]: http://fsharpforfunandprofit.com/series/recursive-types-and-folds.html
[cata-one]: https://lorgonblog.wordpress.com/2008/04/05/catamorphisms-part-one/
[monoids]: {% post_url 2016-05-24-monoids %}
[tree-traversal]: https://en.wikipedia.org/wiki/Tree_traversal
[algebraic]: {% post_url 2016-04-26-algebraic-data-types %}
*)
