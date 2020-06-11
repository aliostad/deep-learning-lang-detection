

val old_new_salaries = Seq(
    // (old_salary, new_salary)
    (2401, 2507), (2172, 2883), (2463, 2867), (2462, 3325), (2949, 2974),
    (2713, 3109), (2778, 3771), (2596, 3045), (2819, 2848), (2974, 3322),
    (2539, 2790), (2440, 3051), (2526, 3240), (2869, 3635), (2341, 2495),
    (2197, 2897), (2706, 2782), (2712, 3056), (2666, 2959), (2149, 2377)
)

def is_high_raise(r: Int) =
    r > 500

val raises = old_new_salaries.map(ss => ss._2 - ss._1)
val high_raises = ???
val total_high_raises = high_raises.reduce(???)

println(s"total high raises: $total_high_raises")
