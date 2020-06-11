package hystrix

import scala.annotation.tailrec
import java.util.concurrent.atomic.AtomicReference
import com.netflix.hystrix.contrib.metrics.eventstream.HystrixMetricsPoller

private[hystrix] class MetricJsonListener(capacity: Int) extends HystrixMetricsPoller.MetricsAsJsonPollerListener {

  private final val metrics = new AtomicReference[Vector[String]](Vector())

  @tailrec
  final def set(oldValue: Vector[String], newValue: Vector[String]): Boolean = {
    metrics.compareAndSet(oldValue, newValue) || set(oldValue, newValue)
  }

  private[this] final def getAndSet(newValue: Vector[String]): Vector[String] = {
    val oldValue = metrics.get
    set(oldValue, newValue)
    oldValue
  }

  override def handleJsonMetric(json: String): Unit = {
    val oldMetrics = metrics.get()
    if (oldMetrics.size >= capacity)
      throw new IllegalStateException("Metrics size has been exceeded")

    val newMetrics = oldMetrics :+ json
    set(oldMetrics, newMetrics)
  }

  def getJsonMetrics: Vector[String] = getAndSet(Vector())
}