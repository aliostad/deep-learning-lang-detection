#!/usr/bin/sq
// Euler1 in Squirrel

// generate a list of ints
function genInts (i, acc=[]) {
    acc.append(i);
    if (i == 0) {
        return acc;
    } else {
        return genInts(i-1, acc);
    }
};

function Euler1(size) {
	local ints = genInts(size)

	local mapped = ::map(ints, function(val) {return val} )

	local filtered = mapped.filter( function(idx,val) {if (val%3==0 || val%5==0) return true else return false} )
	local reduced = filtered.reduce( function(x,y) {return x+y} )
	return reduced;
}

print ( Euler1(10) + "\n" );
