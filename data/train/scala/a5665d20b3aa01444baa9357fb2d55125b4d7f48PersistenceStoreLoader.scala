package models.persistenceStore.loaders

import interfaces.presistenceStore.{IPersistenceStoreDataLoader, IPersistenceStoreLoader, IPersistenceStoreRangeLoader, IPersistenceStoreSensorsLoader}
import models.DataStructures.DataDBJson.DataAnalizeDBJson
import models.DataStructures.RangeModel.RangeType
import models.DataStructures.SensorModel.SensorType.SensorType
import org.joda.time.{DateTime, ReadableDuration}
import play.api.libs.iteratee.Enumerator
import reactivemongo.bson.BSONDocument

import scala.concurrent.duration.{Duration, FiniteDuration}

/**
  * Created by Enrico Benini (AKA Benkio) benkio89@gmail.com on 1/16/16.
  */
class PersistenceStoreLoader(psdl:IPersistenceStoreDataLoader, psrl:IPersistenceStoreRangeLoader, pssl:IPersistenceStoreSensorsLoader) extends IPersistenceStoreLoader {

  ///////////////////////////////////////
  ////////////Range Load Operations//////
  ///////////////////////////////////////
  override def loadRange(rangeType: RangeType.Value, startDate: DateTime, duration:ReadableDuration) =
    psrl.loadRange(rangeType, startDate, duration)

  override def loadLastRange(rangeType: RangeType.Value) =
    psrl.loadLastRange(rangeType)

  override def loadLastRanges =
    psrl.loadLastRanges

  ///////////////////////////////////////
  ////////////Data Load Operations///////
  ///////////////////////////////////////

  override def loadCurrentSensorsData() =
    psdl.loadCurrentSensorsData()

  override def loadCurrentSensorDataContinuously(duration: FiniteDuration): Enumerator[BSONDocument] =
    psdl.loadCurrentSensorDataContinuously(duration)

  override def loadData(sensorName: String, startDate: DateTime, duration:ReadableDuration)=
    psdl.loadData(sensorName,startDate,duration)

  override def loadCurrentSensorData(sensorName: String) =
    psdl.loadCurrentSensorData(sensorName)

  override def loadMininumValue(sensorType: SensorType) =
    psdl.loadMininumValue(sensorType)

  override def loadAverageValue(sensorType: SensorType) =
    psdl.loadAverageValue(sensorType)

  override def loadMaximumValue(sensorType: SensorType) =
    psdl.loadMaximumValue(sensorType)

  ///////////////////////////////////////
  ////////////Sensors Load Operations///
  ///////////////////////////////////////

  override def loadSensors =
    pssl.loadSensors

}
