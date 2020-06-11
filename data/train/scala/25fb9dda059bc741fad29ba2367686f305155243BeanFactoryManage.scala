package com.bear.common.manage

import org.springframework.beans.factory.{BeanFactory, BeanFactoryAware}
import org.springframework.stereotype.Service
/**
  * Created by tanghong on 16/6/29.
  */
@Service
class BeanFactoryManage extends BeanFactoryAware{
  private[this] var beanFactory: BeanFactory = null

  override def setBeanFactory(beanFactory: BeanFactory): Unit = {
    this.beanFactory = beanFactory
  }

  private[this] def getBeanFactory: BeanFactory = beanFactory

  def getBean[T](name: String): T = {
    //val clazz = (implicitly[Manifest[T]]).runtimeClass
    getBeanFactory.getBean(name).asInstanceOf[T]
  }
}
