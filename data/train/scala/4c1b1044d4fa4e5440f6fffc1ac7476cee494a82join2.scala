// # spark-shell --master yarn
val show_views_file = sc.textFile("input2/join2_gennum?.txt")

// show_views_file.take(1)

val show_views = show_views_file.map(line => {
    val fields = line.split(",")
    // show,views
    (fields(0), fields(1).toInt)
})

val show_channel_file = sc.textFile("input2/join2_genchan?.txt")

val show_channel = show_channel_file.map(line => {
    val fields = line.split(",")
    // show channel
    (fields(0), fields(1))
})

val joined_dataset = show_channel.join(show_views)

val channel_views = joined_dataset.map(show_views_channel => {
    val channel = show_views_channel._2._1
    val views = show_views_channel._2._2
    (channel, views)
})

channel_views.reduceByKey(_ + _).collect()
