package models

case class LoadBalancer(
  id: String,
  name: String
)

object AWS {

  val prodLoadBalancers = Seq(
    LoadBalancer("discussio-ModTools-13M3ZPT13T26H", "Discussion Mod Tools"),
    LoadBalancer("discussio-ElasticL-BQPUDV2W424L", "Discussion API"),
    LoadBalancer("discussio-EsPublic-3G2KTHC288EX", "Discussion Elasticsearch")
  )

  val codeLoadBalancers = Seq(
    LoadBalancer("discussio-ModTools-WL8L08GFH90M", "Discussion Mod Tools"),
    LoadBalancer("discussio-ElasticL-17RZKJ8MJFB1K", "Discussion API"),
    LoadBalancer("discussio-EsPublic-H6NEEISPG7QD", "Discussion Elasticsearch")
  )

  val allLoadBalancers = prodLoadBalancers ++ codeLoadBalancers

  val fastlyHitMissMetrics = List(
    ("200/500", "region", "service")
  )

}
