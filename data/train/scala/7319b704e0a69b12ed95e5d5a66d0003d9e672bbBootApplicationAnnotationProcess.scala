package com.young.distributed.core.annotation.support

import java.lang.annotation.Annotation

import com.young.distributed.core.annotation.{Config, LeaderTask, LoopThread}
import com.young.distributed.core.annotation.support.base.{AnnotationProcess, AnnotationProcessEntity}
import com.young.distributed.core.annotation.support.exception.AnnotationException

/**
  * Created by yangyong on 17-5-6.
  */
class BootApplicationAnnotationProcess extends AnnotationProcess {

  private val annotation_mapping: Map[String, AnnotationProcess] = Map((classOf[Config].getName, new ConfigAnnotationProcess),(classOf[LeaderTask].getName,new LeaderTaskAnnotationProcess),(classOf[LoopThread].getName,new LoopThreadAnnotationProcess))

  @throws[AnnotationException]
  override def process[T](annotationProcessEntitys: AnnotationProcessEntity[T]*): Unit = ???
}
