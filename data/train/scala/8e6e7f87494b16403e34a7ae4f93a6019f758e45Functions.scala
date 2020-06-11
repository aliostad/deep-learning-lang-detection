object Functions {
    def main(args:Array[String]) {
        def dub (value:Int) = {
            2 * value
        }

        def dump (value:Int) {
            println (value)
        }

        dump(dub(5))

        class Helper (var value:Int) {
            def reset = {
                value = 0
                this
            }

            def mult (m:Int) = {
                value = m * value
                this
            }

            def sum (m:Int) = {
                value = value + m
                this
            }

            def dump1 (comment:String) = {
                println (comment + " " + value)
                this
            }
        }

        val h = new Helper (10)
        h mult 2
        h dump1 "Result"

        h mult 2 dump1 "Res:"
        h.reset

        h sum 10 mult 2 dump1 "Res:"
    }
}

