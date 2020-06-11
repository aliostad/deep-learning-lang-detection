def getPrimeFactors (number: Int):Set[Int] = {
    var factors = Set.empty[Int]
    var value = number
    var primfact = 1
    while (value % 2 == 0){
        primfact *= 2
        value = value/2
    }
    if (primfact != 1){
        factors += primfact
    }
    for (i <- 3 to number/2 + 1 by 2){
        primfact = 1
        while (value % i == 0){
            primfact *= i
            value = value / i
        }
        if (primfact != 1){
            factors += primfact
        }
    }
    return factors
}


def findConsecutiveValues ():Boolean = {
    var oldOldOldValue = 0
    var oldOldOldSet = Set.empty[Int]
    var oldOldValue = 0
    var oldOldSet = Set.empty[Int]
    var oldValue = 0
    var oldSet = Set.empty[Int]
    for (i <- 10000 to 999999) {
        var primeFactors = getPrimeFactors(i)
        if (primeFactors.size >= 4){ 
            if ( oldValue == i-1 && oldOldValue == i-2 && oldOldOldValue == i-3){
                println (oldOldOldValue)
                println (oldOldOldSet)
                println (oldOldValue)
                println (oldOldSet)
                println (oldValue)
                println (oldSet)
                println (i)
                println(primeFactors)
                return true
            }
            oldOldOldValue = oldOldValue
            oldOldOldSet = oldOldSet
            oldOldValue = oldValue
            oldOldSet = oldSet
            oldValue = i
            oldSet = primeFactors
        }
    }
    return false
}


findConsecutiveValues()
