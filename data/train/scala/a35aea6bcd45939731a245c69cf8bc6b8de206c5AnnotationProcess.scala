package com.young.distributed.core.annotation.support.base

import com.young.distributed.core.annotation.support.exception.AnnotationException

/**
  * Created by yangyong on 17-5-7.
  */
trait AnnotationProcess {
  @throws[AnnotationException]
  def process[T](annotationProcessEntitys: AnnotationProcessEntity[T]*): Unit

  @throws[AnnotationException]
  def checkAnnotation[T](annotationProcessEntity: AnnotationProcessEntity[T]): Unit = {
    if (annotationProcessEntity == null)
      throw new AnnotationException("annotationProcessEntity is not null")
    if (annotationProcessEntity.annotation == null) {
      throw new AnnotationException("annotationProcessEntity target is not null")
    }
    if (annotationProcessEntity.annotation == null) {
      throw new AnnotationException("annotationProcessEntity annotation is not null")
    }
  }
}
