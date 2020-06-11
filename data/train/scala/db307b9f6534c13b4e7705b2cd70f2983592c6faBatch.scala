import java.time.{Duration, LocalDate, LocalDateTime}

import org.apache.spark.util.SizeEstimator
import org.apache.spark.{HashPartitioner, SparkConf, SparkContext}
import org.apache.spark.sql.cassandra.CassandraSQLContext
import org.apache.spark.sql.hive.HiveContext
import org.apache.spark.storage.StorageLevel
import com.datastax.spark.connector._
import org.apache.spark.rdd.RDD




/**
  * Created by torbjorn.torbjornsen on 18.07.2016.
  */
object Batch extends App {
  System.setProperty("hadoop.home.dir", "C:\\Users\\torbjorn.torbjornsen\\Hadoop\\")
  val conf = new SparkConf().setAppName("loadRaw").setMaster("local[4]").set("spark.cassandra.connection.host", "192.168.56.56")
  val sc = new SparkContext(conf)
  sc.setLogLevel("WARN")
  val csc = new CassandraSQLContext(sc)
  csc.setKeyspace("finncars")
  val hc = new HiveContext(sc)

  import hc.implicits._

  //allows registering temptables
  val dao = new DAO(hc, csc)



  val deltaLoadDates:Seq[String] = Utility.getDatesBetween(dao.getLatestLoadDate("prop_car_daily"), LocalDate.now) //prop_car_daily is the target table, check last load date
  //get all dates, not only delta
  //  val deltaLoadDates:Seq[String] = Utility.getDatesBetween(LocalDate.of(2016,7,15), LocalDate.now) //prop_car_daily is the target table, check last load date

  //  val url = "http://m.finn.no/car/used/ad.html?finnkode=79020080"

  val rddDeltaLoadAcqHeaderDatePartition = deltaLoadDates.map { date =>
    sc.cassandraTable[AcqCarHeader]("finncars", "acq_car_header").
      where("load_date = ?", date) //.where("url = ?", url)
  }

  val rddDeltaLoadAcqHeaderLastLoadTimePerDay = sc.union(rddDeltaLoadAcqHeaderDatePartition).
    map(row => ((row.load_date, row.url), (AcqCarHeader(title = row.title, url = row.url, location = row.location, year = row.year, km = row.km, price = row.price, load_time = row.load_time, load_date = row.load_date)))).reduceByKey((x, y) => if (y.load_time > x.load_time) y else x)

  val rddDeltaLoadAcqDetailsDatePartition = deltaLoadDates.map(date => sc.cassandraTable[AcqCarDetails]("finncars", "acq_car_details").
    where("load_date = ?", date) //.where("url = ?", url)
  )

  val rddDeltaLoadAcqDetailsLastLoadTimePerDay = sc.union(rddDeltaLoadAcqDetailsDatePartition).map(row =>
    ((row.load_date, row.url), (AcqCarDetails(url = row.url, load_date = row.load_date, load_time = row.load_time, properties = row.properties, equipment = row.equipment, information = row.information, deleted = row.deleted)))).
    reduceByKey((x, y) => if (y.load_time > x.load_time) y else x)

  //val propCarDeltaJoin:Array[((String, String), (AcqCarHeader, AcqCarDetails))] = rddDeltaLoadAcqHeaderLastLoadTimePerDay.join(rddDeltaLoadAcqDetailsLastLoadTimePerDay).collect
  //NOTE COALESCE(3), if more partitions there will be a deadlock. Possible to reengineer code?
  val propCarDeltaRDD = rddDeltaLoadAcqHeaderLastLoadTimePerDay.join(rddDeltaLoadAcqDetailsLastLoadTimePerDay).coalesce(3).map { row =>
    (row._1._2, PropCar(load_date = row._1._1, url = row._1._2, finnkode = Utility.parseFinnkode(row._1._2), title = row._2._1.title, location = row._2._1.location, year = Utility.parseYear(row._2._1.year), km = Utility.parseKM(row._2._1.km), price = dao.getLastPrice(row._2._1.price, row._2._1.url, row._2._1.load_date, row._2._1.load_time), properties = Utility.getMapFromJsonMap(row._2._2.properties), equipment = Utility.getSetFromJsonArray(row._2._2.equipment), information = Utility.getStringFromJsonString(row._2._2.information), sold = Utility.carMarkedAsSold(row._2._1.price), deleted = row._2._2.deleted, load_time = row._2._1.load_time))
  }
  propCarDeltaRDD.persist(StorageLevel.MEMORY_AND_DISK)

  //NOTE! Number of records between PropCar and AcqHeader/AcqDetails may differ. E.g. when traversing Finn header pages, some cars will be bound to come two times when new cars are entered. Duplicate entries may in other words occur due to load_time being part of Acq* primary key.
  propCarDeltaRDD.map(t => t._2).saveToCassandra("finncars", "prop_car_daily")
  println("Saved to prop_car_daily")

  /* Start populating BTL-layer */
  //get the urls that are part of the delta load
  val btlDeltaUrlList = propCarDeltaRDD.map(row => row._1).distinct.collect

  //create propcar lookup table, limit by x number of days
  val propCarYearRDD = dao.getPropCarDateRange(LocalDate.now.plusDays(-365), LocalDate.now)
  propCarYearRDD.persist(StorageLevel.MEMORY_AND_DISK)

  val propCarYearDeletedCarsMap = sc.broadcast(Utility.getFirstRecordFromFilteredPropCarRDD(propCarYearRDD, (t => t._2.deleted == true)).collectAsMap)
  val propCarYearSoldCarsMap = sc.broadcast(Utility.getFirstRecordFromFilteredPropCarRDD(propCarYearRDD, (t => t._2.sold == true)).collectAsMap)

  /* START populate key figures in BTL based on the first record */
  val propCarFirstRecordsRDD = Utility.getFirstRecordFromFilteredPropCarRDD(propCarYearRDD)
  propCarFirstRecordsRDD.persist(StorageLevel.MEMORY_AND_DISK)
  val propCarLastRecordsRDD = Utility.getLastPropCarAll(propCarDeltaRDD)
  propCarLastRecordsRDD.persist(StorageLevel.MEMORY_AND_DISK)

  val btlCar = btlDeltaUrlList.map{url =>
    val btlCarKf_FirstLoad:BtlCar = Utility.getBtlKfFirstLoad(Utility.popTopPropCarRecord(propCarFirstRecordsRDD ,url))
    val btlCarKf_LastLoad:BtlCar = Utility.getBtlKfLastLoad(Utility.popTopPropCarRecord(propCarLastRecordsRDD,url))
    val btlCarKf_sold_date = propCarYearSoldCarsMap.value.getOrElse(url, PropCar()).load_date
    val btlCarKf_deleted_date = propCarYearDeletedCarsMap.value.getOrElse(url, PropCar()).load_date

//    val btlCarKf_EventDates:BtlCar = Utility.getBtlKfEventDates(propCarYearRDD, url)
    BtlCar(url = url,
      finnkode = btlCarKf_LastLoad.finnkode,
      title = btlCarKf_LastLoad.title,
      location = btlCarKf_LastLoad.location,
      year = btlCarKf_LastLoad.year,
      km = btlCarKf_LastLoad.km,
      price_first = btlCarKf_FirstLoad.price_first,
      price_last = btlCarKf_LastLoad.price_last,
      price_delta = (btlCarKf_LastLoad.price_last - btlCarKf_FirstLoad.price_first),
      sold = btlCarKf_LastLoad.sold,
      sold_date = btlCarKf_sold_date,
      lead_time_sold = Utility.getDaysBetweenStringDates(btlCarKf_FirstLoad.load_date_first, btlCarKf_sold_date),
      deleted = btlCarKf_LastLoad.deleted,
      deleted_date = btlCarKf_deleted_date,
      lead_time_deleted = Utility.getDaysBetweenStringDates(btlCarKf_FirstLoad.load_date_first, btlCarKf_deleted_date),
      load_date_first = btlCarKf_FirstLoad.load_date_first,
      load_date_latest = btlCarKf_LastLoad.load_date_latest,
      automatgir = btlCarKf_LastLoad.automatgir,
      hengerfeste = btlCarKf_LastLoad.hengerfeste,
      skinninterior = btlCarKf_LastLoad.skinninterior,
      drivstoff = btlCarKf_LastLoad.drivstoff,
      sylindervolum = btlCarKf_LastLoad.sylindervolum,
      effekt = btlCarKf_LastLoad.effekt,
      regnsensor = btlCarKf_LastLoad.regnsensor,
      farge = btlCarKf_LastLoad.farge,
      cruisekontroll = btlCarKf_LastLoad.cruisekontroll,
      parkeringsensor = btlCarKf_LastLoad.parkeringsensor,
      antall_eiere = btlCarKf_LastLoad.antall_eiere,
      kommune = btlCarKf_LastLoad.kommune,
      fylke = btlCarKf_LastLoad.fylke,
      xenon = btlCarKf_LastLoad.xenon,
      navigasjon = btlCarKf_LastLoad.navigasjon,
      servicehefte = btlCarKf_LastLoad.servicehefte,
      sportsseter = btlCarKf_LastLoad.sportsseter,
      tilstandsrapport = btlCarKf_LastLoad.tilstandsrapport,
      vekt = btlCarKf_LastLoad.vekt
      )
  }

  sc.parallelize(btlCar).saveToCassandra("finncars", "btl_car")
  println("Saved to btl_car")
  /* END populate key figures in BTL based on the first record */



}