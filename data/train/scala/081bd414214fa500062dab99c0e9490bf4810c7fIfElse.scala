package comparison

object IfElse {
    
    //112 chars
    def category(age:Int) =
        if (age < 18) {
            "Young"
        } else {
            "Old"
        }




    //168 chars
    def finestCategory(age: Int) = 
        if (age < 5) {
            "Kid"
        } else if (age < 18) {
            "Young"
        } else {
            "Old"
        }




    //416 chars
    def qualified(age:Int, kind:Short) =
        (if (age < 2) {
            "Baby "
        } else if (age < 5) {
            "Kid "
        } else if (age < 7) {
            "Young "
        } else {
            ""
        }) + 
        (if (kind == 1) {
           "Girl"
        } else if (kind == 2) {
            "Boy"
        } else if (kind == 3) {
            "Dog"
        } else {
            "Cat"
        })
 
}