#!/usr/bin/sq
// Euler1 in Squirrel
// Generic recursive Map, Filter, Reduce using Tail Call Optimization

// Map - transform each item to something else
function map (ls, f, acc=null) {
    if (acc == null) acc = [];
    if (ls.len() == 0) {
        return acc;
    } else {
        return map( ls.slice(1,ls.len()), f, [f(ls[0])].extend(acc) );
    }
};

// Filter - remove selected items
function filter (ls, f, acc=null) {
    if (acc == null) acc = [];
    if (ls.len() == 0) {
        return acc;
    } else if (f(ls[0]) == true) {
        return filter( ls.slice(1,ls.len()), f, [f(ls[0])].extend(acc) );
    } else {
        return filter( ls.slice(1,ls.len()), f, acc );
    }
};

// Reduce - calculate a value based on all items
function reduce (ls, f, acc=null) {
    if (ls.len() == 0) {
        return acc;
    } else {
        return reduce( ls.slice(1,ls.len()), f, f(ls[0], acc) );
    }
};

// generate a list of ints
function genInts (i, acc=null) {
    if (acc == null) acc = [];
	print(i + "\n");
	print("acc\n");
	foreach(val in acc)
		print("value="+val+"\n");
	print("\n");
    if (i == 0) {
        return acc;
    } else {
        return genInts(i-1, acc.append(i));
    }
};

// Define anonymous mapping/filtering/reducing functions
// and pass them as parameters

local ints = genInts(9);
print("ints\n");
foreach(val in ints)
    print("value="+val+"\n");
print("\n");

local mapped = map(ints,
        function(val) { return val; });
print("mapped\n");
foreach(val in mapped)
    print("value="+val+"\n");
print("\n");

local filtered = filter(mapped,
        function(val) { if (val%3==0 || val%5==0) return true;
                        else return false; });
print("filtered\n");
foreach(val in filtered)
    print("value="+val+"\n");
print("\n");

local reduced = reduce(filtered,
        function(x, acc) { if (acc == null) return x;
                           else return acc+x; });

print (reduced + "\n");
