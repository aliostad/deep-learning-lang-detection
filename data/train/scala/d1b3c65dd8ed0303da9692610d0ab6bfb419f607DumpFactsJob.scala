package com.ambiata.ivory.operation.debug

import com.ambiata.mundane.control._
import com.ambiata.mundane.io._
import com.ambiata.ivory.core._
import com.ambiata.ivory.mr._
import com.ambiata.ivory.operation.extraction.IvoryInputs
import com.ambiata.ivory.storage.fact._
import com.ambiata.ivory.storage.repository.HdfsGlobs.FactsetPartitionsGlob
import com.ambiata.poacher.mr._

import org.apache.hadoop.fs.Path
import org.apache.hadoop.io._
import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.io.compress._
import org.apache.hadoop.mapreduce._
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat
import org.apache.hadoop.mapreduce.lib.input.MultipleInputs
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat

import scalaz._, Scalaz._

object DumpFactsJob {
  def run(
    repository: HdfsRepository
  , dictionary: Dictionary
  , datasets: Datasets
  , entities: List[String]
  , attributes: List[String]
  , output: Path
  , codec: Option[CompressionCodec]
  ): RIO[Unit] = for {
    job <- RIO.io { Job.getInstance(repository.configuration) }
    ctx <- RIO.io { MrContextIvory.newContext("ivory-dump-facts", job) }
    r   <- RIO.io {
        job.setJarByClass(classOf[DumpFactsSnapshotMapper[_]])
        job.setJobName(ctx.id.value)
        job.setMapOutputKeyClass(classOf[NullWritable])
        job.setMapOutputValueClass(classOf[Text])
        job.setNumReduceTasks(0)

        IvoryInputs.configure(ctx, job, repository, datasets, {
          case FactsetFormat.V1 => classOf[DumpFactsV1FactsetMapper]
          case FactsetFormat.V2 => classOf[DumpFactsV2FactsetMapper]
        }, {
          case SnapshotFormat.V1 => classOf[DumpFactsV1SnapshotMapper]
          case SnapshotFormat.V2 => classOf[DumpFactsV2SnapshotMapper]
        })

        val tmpout = new Path(ctx.output, "dump-facts")
        job.setOutputFormatClass(classOf[TextOutputFormat[_, _]])
        FileOutputFormat.setOutputPath(job, tmpout)
        codec.foreach(cc => {
          Compress.intermediate(job, cc)
          Compress.output(job, cc)
        })
        write(job.getConfiguration, Keys.Entities, entities)
        write(job.getConfiguration, Keys.Attributes, attributes)

        job.waitForCompletion(true)
      }
    _   <- RIO.unless(r, RIO.fail("Ivory dump facts failed to complete, please see job tracker."))
    _   <- Committer.commit(ctx, {
          case "dump-facts" => output
        }, true).run(repository.configuration)
  } yield ()

  def write(c: Configuration, k: String, vs: List[String]): Unit =
    c.set(k, vs.mkString(","))

  def read(c: Configuration, k: String): List[String] =
    // getOrElse("") required to handle hadoop null-ing of empty strings in config
    Option(c.get(k)).getOrElse("").split(",").toList.filter(!_.isEmpty)

  object Keys {
    val Attributes = "ivory.dump-facts.attributes"
    val Entities = "ivory.dump-facts.entities"
  }
}

abstract class DumpFactsFactsetMapper[K <: Writable] extends CombinableMapper[K, BytesWritable, NullWritable, Text] with MrFactFormat[K, BytesWritable] {
  val serializer = ThriftSerialiser()
  val buffer = new StringBuilder(4096)
  val kout = NullWritable.get
  val vout = new Text
  var fact: MutableFact = createMutableFact
  var mapper: DumpFactsMapper = null
  var converter: MrFactConverter[K, BytesWritable] = null

  final override def setupSplit(context: Mapper[K, BytesWritable, NullWritable, Text]#Context, split: InputSplit): Unit = {
    val path = MrContext.getSplitPath(split)
    val (id, _) = FactsetInfo.getBaseInfo(path)
    val source = s"Factset[${id.render}]"
    val entities = DumpFactsJob.read(context.getConfiguration, DumpFactsJob.Keys.Entities).toSet
    val attributes = DumpFactsJob.read(context.getConfiguration, DumpFactsJob.Keys.Attributes).toSet
    mapper = DumpFactsMapper(entities, attributes, source)
    converter = factConverter(path)
  }

  override def map(key: K, value: BytesWritable, context: Mapper[K, BytesWritable, NullWritable, Text]#Context): Unit = {
    converter.convert(fact, key, value)
    if (mapper.accept(fact)) {
      vout.set(mapper.renderWith(fact, buffer))
      context.write(kout, vout)
    }
  }
}

class DumpFactsV1FactsetMapper extends DumpFactsFactsetMapper[NullWritable] with MrFactsetFactFormatV1
class DumpFactsV2FactsetMapper extends DumpFactsFactsetMapper[NullWritable] with MrFactsetFactFormatV2

abstract class DumpFactsSnapshotMapper[K <: Writable] extends CombinableMapper[K, BytesWritable, NullWritable, Text] with MrFactFormat[K, BytesWritable] {
  val serializer = ThriftSerialiser()
  val fact: MutableFact = createMutableFact
  val buffer = new StringBuilder(4096)
  val key = NullWritable.get
  val out = new Text
  val missing = "NA"
  var converter: MrFactConverter[K, BytesWritable] = null
  var mapper: DumpFactsMapper = null

  final override def setupSplit(context: Mapper[K, BytesWritable, NullWritable, Text]#Context, split: InputSplit): Unit = {
    val path = MrContext.getSplitPath(split)
    val id = snapshotIdFromPath(FilePath.unsafe(path.toString)).getOrElse(Crash.error(Crash.DataIntegrity, s"Can not parse snapshot id from path: ${path}"))
    val source = s"Snapshot[${id.render}]"
    val entities = DumpFactsJob.read(context.getConfiguration, DumpFactsJob.Keys.Entities).toSet
    val attributes = DumpFactsJob.read(context.getConfiguration, DumpFactsJob.Keys.Attributes).toSet
    mapper = DumpFactsMapper(entities, attributes, source)
    converter = factConverter(MrContext.getSplitPath(split))
  }

  def snapshotIdFromPath(path: FilePath): Option[SnapshotId]

  override def map(key: K, value: BytesWritable, context: Mapper[K, BytesWritable, NullWritable, Text]#Context): Unit = {
    converter.convert(fact, key, value)
    write(fact, context)
  }

  def write(fact: Fact, context: Mapper[K, BytesWritable, NullWritable, Text]#Context): Unit = {
    if (mapper.accept(fact)) {
      out.set(mapper.renderWith(fact, buffer))
      context.write(key, out)
    }
  }
}

class DumpFactsV1SnapshotMapper extends DumpFactsSnapshotMapper[NullWritable] with MrSnapshotFactFormatV1 {
  override def snapshotIdFromPath(path: FilePath): Option[SnapshotId] =
    SnapshotId.parse(path.dirname.components.last)
}

class DumpFactsV2SnapshotMapper extends DumpFactsSnapshotMapper[IntWritable] with MrSnapshotFactFormatV2 {
  override def snapshotIdFromPath(path: FilePath): Option[SnapshotId] =
    SnapshotId.parse(path.dirname.dirname.components.last)
}
