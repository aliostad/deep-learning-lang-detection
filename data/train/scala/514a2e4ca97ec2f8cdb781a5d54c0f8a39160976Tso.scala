package trans

/**
  * Created by luis on 2/9/2017.
  */

import Operation._

import scala.collection.mutable

case class Tso(var read_timestamp:Long,var write_timestamp:Long) {

  val map = mutable.ListMap.empty[Int, Tso]





  def checkTso(transaction_timestamp: Long, Op: Op): String = {

    val oid=Op._3




    for( (k,v)<-map)
      {

        println(" id= "+ k+ " value read= "+ v.read_timestamp + "value write"+ v.write_timestamp)

      }


    if (Op._1 == 'r') map.get(oid) match {


      case None => {
        map+=oid->Tso(0,System.currentTimeMillis())
        println("after.......")
        for( (k,v)<-map)
        {

          println(" id= "+ k+ " value read= "+ v.read_timestamp + "value write"+ v.write_timestamp)

        }
        return "OK"
      }

      case Some(ts) =>{

        println(" comparing "+ transaction_timestamp + " with "+ ts.write_timestamp)

        if (transaction_timestamp< ts.write_timestamp)   {

          println("after.......")
          for( (k,v)<-map)
          {

            println(" id= "+ k+ " value read= "+ v.read_timestamp + "value write"+ v.write_timestamp)

          }

          return "ROLLBACK"
        }

        else{



          ts.read_timestamp= Math.max(transaction_timestamp,ts.read_timestamp)
          println("after.......")
          for( (k,v)<-map)
          {

            println(" id= "+ k+ " value read= "+ v.read_timestamp + "value write"+ v.write_timestamp)

          }
          return "OK"
        }

    }


    }


    if (Op._1 == 'w') map.get(oid) match {

      case None => {
        map+=oid->Tso(System.currentTimeMillis(),0)
        println("after.......")
        for( (k,v)<-map)
        {

          println(" id= "+ k+ " value read= "+ v.read_timestamp + "value write"+ v.write_timestamp)

        }
        return "OK"
      }

      case Some(ts) =>{

        println(" comparing "+ transaction_timestamp + " with "+ ts.read_timestamp+ " or "+ ts.write_timestamp)

        if((ts.read_timestamp>transaction_timestamp) || (ts.write_timestamp>transaction_timestamp)) {
          println("after.......")
          for( (k,v)<-map)
          {

            println(" id= "+ k+ " value read= "+ v.read_timestamp + "value write"+ v.write_timestamp)

          }
          return "ROLLBACK"
        }
        else {



          ts.write_timestamp=transaction_timestamp
          println("after.......")
          for( (k,v)<-map)
          {

            println(" id= "+ k+ " value read= "+ v.read_timestamp + "value write"+ v.write_timestamp)

          }
          return "OK"
        }


      }




    }


  return "ERROR"

  }

}
