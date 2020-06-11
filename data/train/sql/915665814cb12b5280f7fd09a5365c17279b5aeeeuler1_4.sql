#!/usr/bin/sq
// Euler1 in Squirrel

// calculate solution based on Quicksort problem decomposition
function euler(L, acc=0) {
    if (L.len() == 0) return acc

    local pivot = L.len() / 2

    return (euler( L.slice(0,pivot), acc )
          + euler( L.slice(pivot+1), acc )
          + ( (L[pivot]%3 == 0 || L[pivot]%5 == 0)  &&  L[pivot]  ||  0 )
          + acc)
}

// generate a list of ints using tail recursion
function genInts (i, acc=[]) {
    acc.append(i);
    if (i == 0) {
        return acc;
    } else {
        return genInts(i-1, acc);
    }
};

function Euler1(size) {
    return euler( genInts(size) );
}

print ( Euler1(999) + "\n" );
