package org.github.mq.common.protocol.route

import scala.collection.mutable

/**
  * Created by error on 2017/1/12.
  */
class BrokerData extends Comparable[BrokerData] {
  var cluster = ""
  var brokerName = ""
  var brokerAddrs : mutable.HashMap[Long, String] = null

  override def compareTo(o: BrokerData): Int =  {
    this.brokerName.compareTo(o.brokerName)
  }

  override def toString = s"BrokerData(cluster=$cluster, brokerName=$brokerName, brokerAddrs=$brokerAddrs)"

  def canEqual(other: Any): Boolean = other.isInstanceOf[BrokerData]

  override def equals(obj: Any): Boolean = {
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    if (getClass() != obj.getClass())
      return false;
    val other = obj.asInstanceOf[BrokerData];
    if (brokerAddrs == null) {
      if (other.brokerAddrs != null)
        return false;
    } else if (!brokerAddrs.equals(other.brokerAddrs))
      return false;
    if (brokerName == null) {
      if (other.brokerName != null)
        return false;
    } else if (!brokerName.equals(other.brokerName))
      return false;
    return true;
  }

  override def hashCode(): Int = {
    val prime = 31;
    var result = 1;
    result = prime * result + (if(brokerAddrs == null) 0 else brokerAddrs.hashCode);
    result = prime * result + (if(brokerName == null) 0 else brokerName.hashCode);
    return result;
  }
}
